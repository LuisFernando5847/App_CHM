import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin.dart';
import 'crearcuenta.dart';
import 'trabajadores.dart';
import 'users.dart';
import 'nuevoCliente.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('es', 'MX'), Locale('en', 'US')],
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _cargarCredenciales();
  }

  /// ===============================
  /// 🔄 CARGAR CREDENCIALES GUARDADAS
  /// ===============================
  Future<void> _cargarCredenciales() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userController.text = prefs.getString('username') ?? '';
      _passController.text = prefs.getString('password') ?? '';
    });
  }

  /// ===============================
  /// 💾 GUARDAR CREDENCIALES
  /// ===============================
  Future<void> _guardarCredenciales(String user, String pass) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', user);
    await prefs.setString('password', pass);
  }

  /// ===============================
  /// 🔐 LOGIN
  /// ===============================
  Future<void> _login() async {
    final username = _userController.text.trim();
    final password = _passController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se permiten campos vacíos',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.deepOrange,
        ),
      );
      return;
    }

    final backendUrl = Uri.parse(
      'https://apichm-gjabejbmdza5gefe.mexicocentral-01.azurewebsites.net/api/Login',
    );

    try {
      final response = await http.post(
        backendUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          await _guardarCredenciales(username, password);

          final nombres = (data['nombres'] ?? '').toString();
          final apellidoP = (data['apellidoP'] ?? '').toString();
          final apellidoM = (data['apellidoM'] ?? '').toString();
          final correo = (data['correo'] ?? '').toString();
          final empresa = (data['empresa'] ?? '').toString();

          final raw = data['esAdmin'];
          final int esAdmin = (raw is bool)
              ? (raw ? 1 : 0)
              : (raw is num)
                  ? raw.toInt()
                  : int.tryParse(raw?.toString() ?? '') ?? 0;

          final nombreCompleto = '$nombres $apellidoP $apellidoM'.trim();

          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Bienvenido'),
              content: Text('Hola $nombreCompleto'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();

                    if (esAdmin == 1) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Admin(
                            nombreCompleto: nombreCompleto,
                            correo: correo,
                          ),
                        ),
                      );
                    } else if (esAdmin == 2) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NuevoCliente(
                            nombreCompleto: nombreCompleto,
                            correo: correo,
                            empresa: empresa,
                          ),
                        ),
                      );
                    } else if (esAdmin == 0) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TrabajadoresPage(
                            userName: nombreCompleto,
                            userEmail: correo,
                          ),
                        ),
                      );
                    } else if (esAdmin == 3) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Users(
                            nombreCompleto: nombreCompleto,
                            correo: correo,
                            empresa: empresa,
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text("Continuar"),
                ),
              ],
            ),
          );
        } else {
          String msg = data['error'] ?? 'Credenciales inválidas';

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                msg,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.lightGreen,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Sus credenciales son inválidas',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.lightGreen,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Error de conexión',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  /// ===============================
  /// 🎨 UI
  /// ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Fondo_Azul.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// LOGO
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 30),
              child: Image.asset(
                'assets/Logo_contorno_blanco.png',
                width: 100,
                height: 100,
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 120),
              child: Column(
                children: [
                  const Text(
                    'Bienvenido',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 37,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Image.asset(
                    'assets/animacion6.gif',
                    width: 200,
                    height: 200,
                  ),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 255, 255, 0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Ingrese sus datos',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextField(
                          controller: _userController,
                          decoration: InputDecoration(
                            labelText: 'Usuario',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextField(
                          controller: _passController,
                          obscureText: !_showPassword,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF192557),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: _login,
                          child: const Text(
                            'Iniciar sesión',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 245, 156, 22),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const RegisterPage()),
                            );
                          },
                          child: const Text(
                            'Crear una cuenta',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}