import 'dart:convert';
import 'package:chm_ios/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class NuevoCliente extends StatefulWidget {
  final String nombreCompleto;
  final String correo;
  final String empresa;

  const NuevoCliente({
    super.key,
    required this.nombreCompleto,
    required this.correo,
    required this.empresa,
  });

  @override
  State<NuevoCliente> createState() => _NuevoClienteState();
}

class _NuevoClienteState extends State<NuevoCliente> {
  // Variables para despues enviar por correo
  final telefonoController = TextEditingController();
  final notasController = TextEditingController();

  // METODOS PARA ENVIAR CORREOS ELECTRONICOS
  Future<void> Solicitud_Nuevo_Cliente({
    required String toEmail,
    required String nombreCompleto,
    required String empresa,
    required String numero,
    required String notas,
  }) async {
    final url = Uri.parse(
      'http://10.7.234.136:5090/api/email/solicitud-nuevocliente',
    );

    final body = {
      'toEmail': toEmail,
      'nombreCompleto': nombreCompleto,
      'empresa': empresa,
      'numero': numero,
      'notas': notas,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Tu solicitud ha sido enviada correctamente",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      throw Exception('Error al enviar el correo: ${response.body}');
    }
  }

  @override
  void initState() {
    super.initState();
    //Mostrar Snackbar despues de la pantalla cargue
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Preciona el asistente para saber mas",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.blue,
            duration: Duration(seconds: 6),
          ),
        );
      }
    });
  }

  void _mostrarDialogo() {
    //Cierra el dialogo si esta abierto
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Gracias por elegirnos"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Ingresa un número telefónico, para contactarte."),
                const SizedBox(height: 10),
                //Campo de telefono
                TextField(
                  controller: telefonoController,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: const InputDecoration(
                    labelText: "Número telefonico",
                    counterText: "",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Anota una breve descripción de lo que necesitas y uno de nuestros asesores te atenderá.",
                ),
                const SizedBox(height: 10),
                //Campo Notas
                TextField(
                  controller: notasController,
                  maxLines: 10,
                  maxLength: 1000,
                  decoration: const InputDecoration(
                    labelText: "Notas",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Enviar"),
              onPressed: () async {
                String telefono = telefonoController.text.trim();
                String notas = notasController.text.trim();

                if (telefono.isEmpty || notas.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'No dejes los campos vacios',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                      duration: Duration(seconds: 3),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                if (telefono.length < 10) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'El número debe de tener 10 digitos',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                      duration: Duration(seconds: 3),
                      backgroundColor: Colors.deepOrangeAccent,
                    ),
                  );
                  return;
                }

                // Cierra el dialogo
                Navigator.of(context).pop();

                // Mostrar indicador de progreso
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        CircularProgressIndicator(
                          value: null,
                          color: Colors.white,
                        ),
                        SizedBox(width: 16),
                        Text(
                          "Enviando solicitud...",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    duration: Duration(seconds: 5),
                    backgroundColor: Colors.blue,
                  ),
                );

                // Proceso de envio
                try {
                  await Solicitud_Nuevo_Cliente(
                    toEmail: widget.correo,
                    nombreCompleto: widget.nombreCompleto,
                    empresa: widget.empresa,
                    numero: telefono,
                    notas: notas,
                  );

                  telefonoController.clear();
                  notasController.clear();
                  
                } catch (e) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error al enviar la solicitud: $e"),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 4),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CHM Movil',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF192557),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirmar'),
                    content: const Text('¿Deseas cerrar sesión?'),
                    actions: [
                      TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: const Text('Cerrar Sesión'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyHomePage(),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset('assets/Fondo_Azul.png', fit: BoxFit.cover),
          ),

          // Contenido central
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Imagen central con gesture Detector
                GestureDetector(
                  onTap: _mostrarDialogo,
                  child: Image.asset('assets/animacion6.gif', width: 210),
                ),
                const SizedBox(height: 20),

                // Texto de bienvenida
                const Text(
                  'Bienvenido',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 5,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
