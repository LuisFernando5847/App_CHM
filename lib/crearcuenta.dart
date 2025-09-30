import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Pantalla de registro de usuario
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controladores de texto para los campos del formulario
  final usuarioController = TextEditingController();
  final passwordController = TextEditingController();
  final nombreController = TextEditingController();
  final empresaController = TextEditingController();
  final correoController = TextEditingController();
  // Número de cliente
  final numeroclienteController = TextEditingController();

  bool registroexitoso = false;

  // Función para validar y enviar OTP
  Future<void> _validarYEnviarOtp() async {
    final usuario = usuarioController.text.trim();
    final password = passwordController.text.trim();
    final nombre = nombreController.text.trim();
    final empresa = empresaController.text.trim();
    final correo = correoController.text.trim();
    final numeroCliente = numeroclienteController.text.trim();

    // Validación de campos
    if (usuario.isEmpty ||
        password.isEmpty ||
        nombre.isEmpty ||
        empresa.isEmpty ||
        correo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, completa todos los campos requeridos'),
        ),
      );
      return;
    }

    // Validación de formato de correo
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(correo)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, ingresa un correo electrónico válido'),
        ),
      );
      return;
    }
    // Validación de dominio de correo
    final partesCorreo = correo.split('@');
    if (partesCorreo.length != 2 ||
        [
          'gmail.com',
          'yahoo.com',
          'outlook.com',
        ].contains(partesCorreo[1].toLowerCase())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se permiten correos con dominios públicos o inválidos',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.amber
        ),
      );
      return;
    }

    // Separar nombre completo
    List<String> partes = nombre.split(" ");
    String nombres = "", apellidoP = "", apellidoM = "";
    if (partes.length >= 3) {
      nombres = partes.sublist(0, partes.length - 2).join(" ");
      apellidoP = partes[partes.length - 2];
      apellidoM = partes[partes.length - 1];
    } else if (partes.length == 2) {
      nombres = partes[0];
      apellidoP = partes[1];
    } else if (partes.length == 1) {
      nombres = partes[0];
    }

    // Enviar OTP
    await _enviarOtp(
      usuario,
      password,
      nombres,
      apellidoP,
      apellidoM,
      empresa,
      correo,
      numeroCliente,
    );
  }

  // Envía el OTP al correo y muestra el diálogo para ingresar el código
  Future<void> _enviarOtp(
    String usuario,
    String password,
    String nombres,
    String apellidoP,
    String apellidoM,
    String empresa,
    String correo,
    String numeroCliente,
  ) async {
    final url = Uri.parse('http://10.7.234.136:5035/api/email/send');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'ToEmail': correo}),
    );

    if (response.statusCode == 200) {
      // Muestra el diálogo para ingresar el código de verificación
      _pedirCodigoVerificacion(
        usuario,
        password,
        nombres,
        apellidoP,
        apellidoM,
        empresa,
        correo,
        numeroCliente,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al enviar código OTP')),
      );
    }
  }

  // Diálogo para ingresar el código de verificación
  void _pedirCodigoVerificacion(
    String usuario,
    String password,
    String nombres,
    String apellidoP,
    String apellidoM,
    String empresa,
    String correo,
    String numeroCliente,
  ) {
    final otpController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verifica tu correo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nombre: $nombres $apellidoP $apellidoM"),
            const SizedBox(height: 10),
            Text("Se ha enviado un correo a:"),
            const SizedBox(height: 10),
            Text("   $correo"),
            const SizedBox(height: 10),
            TextField(
              controller: otpController,
              decoration: const InputDecoration(
                labelText: 'Código de verificación',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Editar"),
          ),
          TextButton(
            onPressed: () async {
              final codigo = otpController.text.trim();
              if (codigo.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Por favor, ingresa el código de verificación',
                    ),
                  ),
                );
                return;
              }
              final ok = await _verificarOtp(correo, codigo);
              Navigator.of(context).pop();

              if (ok) {
                _enviarRegistro(
                  usuario,
                  password,
                  nombres,
                  apellidoP,
                  apellidoM,
                  empresa,
                  correo,
                  numeroCliente,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Código incorrecto o expirado'),
                  ),
                );
              }
            },
            child: const Text("Validar"),
          ),
        ],
      ),
    );
  }

  // Verifica el código OTP con el backend
  Future<bool> _verificarOtp(String correo, String codigo) async {
    final url = Uri.parse('http://10.7.234.136:5035/api/email/verify');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'ToEmail': correo, 'Code': codigo}),
    );
    return response.statusCode == 200;
  }

  // Envía los datos al backend para registrar el usuario
  Future<void> _enviarRegistro(
    String usuario,
    String password,
    String nombres,
    String apellidoP,
    String apellidoM,
    String empresa,
    String correo,
    String numeroCliente,
  ) async {
    final url = Uri.parse('http://10.7.234.136:5035/api/Usuarios/registrar');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'Usuario': usuario,
        'Password': password,
        'Nombres': nombres,
        'Apellido_P': apellidoP,
        'Apellido_M': apellidoM,
        'Empresa': empresa,
        'Correo': correo,
        //'EsAdmin': 3,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario registrado con éxito')),
      );
      // Cierra el diálogo y regresa a la pantalla anterior
      Navigator.pop(context);
    } else {
      final mensaje = jsonDecode(response.body)['mensaje'];
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mensaje ?? 'Error al registrar')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crear una cuenta',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF192557),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/FondoBlanco.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Registro de Usuario',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: usuarioController,
                      decoration: const InputDecoration(labelText: 'Usuario'),
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                      ),
                    ),
                    TextField(
                      controller: nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre Completo',
                      ),
                    ),
                    TextField(
                      controller: empresaController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre de la Empresa',
                      ),
                    ),
                    TextField(
                      controller: correoController,
                      decoration: const InputDecoration(
                        labelText: 'Correo Electrónico',
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _validarYEnviarOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF192557),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Registrar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
