import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_localizations/flutter_localizations.dart';

import 'admin.dart';
import 'crearcuenta.dart';
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

  Future<void> _login() async {
    final username = _userController.text.trim();
    final password = _passController.text.trim();

    //verificar que el login no este vacio
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se permiten campos vacios',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.deepOrange,
        ),
      );
      return;
    }

    final backendUrl = Uri.parse('https://apichm-gjabejbmdza5gefe.mexicocentral-01.azurewebsites.net/api/Login',);

    try {
      final response = await http.post(
        backendUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          final nombres = data['nombres'] ?? '';
          final apellidoP = data['apellidoP'] ?? '';
          final apellidoM = data['apellidoM'] ?? '';
          final empresa = data['empresa'] ?? '';
          final correo = data['correo'] ?? '';
          final esAdmin = data['esAdmin'] ?? 0;

          print("Valor recibido de esAdmin: $esAdmin");

          final nombreCompleto = '$nombres $apellidoP $apellidoM';

          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Bienvenido'),
              content: Text('Hola $nombreCompleto'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);

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
                            nombreCompleto:nombreCompleto,
                            correo: correo,
                            empresa: empresa,
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
        } else if (data['success'] == false) {
          
          String mensaje_error = data['error'] ?? 'Credenciales inválidas';

          ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
              content: Text(
                mensaje_error,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.lightGreen,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Sus credenciales son invalidas',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.lightGreen,
          ),
        );
        _mostrarDialogo('Error', 'Estado HTTP: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Sus credenciales son invalidas',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.lightGreen,
        ),
      );
      _mostrarDialogo('Error', 'No se pudo conectar:\n$e');
    }
  }

  void _mostrarDialogo(String titulo, String mensaje) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,// NO SE MUEVE NADA SE QUEDA FIJO CUANDO ENTRA EL TECLADO
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Fondo_Azul.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
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
            SingleChildScrollView(//EVITA LINEA AMARILLA
              child: Column(
                children: [
                  const SizedBox(height: 90),
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      'Bienvenido',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 37,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Image.asset('assets/animacion6.gif', width: 200, height: 200),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 255, 255, 0.7),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
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
                            labelStyle: const TextStyle(color: Colors.black87),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _passController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            labelStyle: const TextStyle(color: Colors.black87),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF192557),
                            foregroundColor: Colors.white.withOpacity(0.9),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            shadowColor: Colors.black,
                            elevation: 10,
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
                            backgroundColor: const Color.fromARGB(
                              255,
                              245,
                              156,
                              22,
                            ),
                            foregroundColor: Colors.white.withOpacity(0.9),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            shadowColor: Colors.black,
                            elevation: 10,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterPage(),
                              ),
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
          ],
        ),
      ),
    );
  }
}
