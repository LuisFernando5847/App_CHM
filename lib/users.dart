import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'main.dart'; // Para volver al login

class Users extends StatefulWidget {
  final String nombreCompleto;
  final String correo;
  final String empresa; // Agrega la variable empresa

  const Users({
    super.key,
    required this.nombreCompleto,
    required this.correo,
    required this.empresa,
  });

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  // VARIABLES PARA MOSTRAR PRODUCTOS
  bool mostrarPolipastos = false;
  bool mostrarServicios = false;
  bool mostrarAccesorios = false;
  bool mostrarPatines = false;
  bool mostrarCapacitaciones = false;
  bool mostrarProyectos = false;

  // METODOS PARA ENVIAR CORREOS ELECTRONICOS

  Future<void> enviarCorreoServicios({
    required String toEmail,
    required String nombreCompleto,
    required String empresa,
    required String nombreServicio,
    required String dia,
    required String hora,
    Map<String, dynamic>? extras,
  }) async {
    final url = Uri.parse(
      'http://10.7.234.137:5090/api/email/solicitud-servicios',
    );

    final body = {
      'toEmail': toEmail,
      'nombreCompleto': nombreCompleto,
      'empresa': empresa,
      'nombreServicio': nombreServicio,
      'dia': dia,
      'hora': hora,
      'extras': extras ?? {},
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
          backgroundColor: Colors.greenAccent,
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      throw Exception('Error al enviar el correo: ${response.body}');
    }
  }

  Future<void> enviarCorreoPolipastos({
    required String toEmail,
    required String nombreCompleto,
    required String empresa,
    required String nombrePolipasto,
    required Map<String, String> datosFormulario,
  }) async {
    final url = Uri.parse(
      'http://10.7.234.137:5090/api/email/solicitud-polipastos',
    );
    final body = {
      'toEmail': toEmail,
      'nombreCompleto': nombreCompleto,
      'empresa': empresa,
      'nombrePolipasto': nombrePolipasto,
      'campos': datosFormulario,
    };

    final respuesta = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (respuesta.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Tu solicitud ha sido enviada correctamente",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.greenAccent,
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      throw Exception('Error al enviar el correo: ${respuesta.body}');
    }
  }

  Future<void> enviarCorreoAccesorio({
    required String toEmail,
    required String nombreCompleto,
    required String empresa,
    required String nombreAccesorio, // Para saber cuál se envía
    required Map<String, String> datosFormulario, // Campos dinámicos
  }) async {
    final url = Uri.parse(
      'http://10.7.234.137:5090/api/email/solicitud-accesorios',
    );

    final body = {
      'toEmail': toEmail,
      'nombreCompleto': nombreCompleto,
      'empresa': empresa,
      'nombreAccesorio': nombreAccesorio,
      'campos': datosFormulario, // Aquí van los datos dinámicos
    };

    final respuesta = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (respuesta.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Solicitud enviada correctamente",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.greenAccent,
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      throw Exception('Error al enviar el correo: ${respuesta.body}');
    }
  }

  Future<void> enviarCorreoPatinHidraulico({
    required String toEmail,
    required String nombreCompleto,
    required String empresa,
    required String nombrePatin,
    required Map<String, String> datosFormulario,
  }) async {
    final url = Uri.parse(
      'http://10.7.234.137:5090/api/email/solicitud-patines',
    );
    final respuesta = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'toEmail': toEmail,
        'nombreCompleto': nombreCompleto,
        'empresa': empresa,
        'nombrePatin': nombrePatin,
        'campos': datosFormulario,
      }),
    );
    if (respuesta.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Tu solicitud ha sido enviada correctamente",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.greenAccent,
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      throw Exception('Error al enviar el correo: ${respuesta.body}');
    }
  }

  Future<void> enviarCorreoCapacitaciones({
    required String toEmail,
    required String nombreCompleto,
    required String empresa,
    required String nombreCapacitacion,
    required String dia,
    required String hora,
    required Map<String, String> adicional,
  }) async {
    final url = Uri.parse(
      'http://10.7.234.137:5090/api/email/solicitud-capacitaciones',
    );

    final body = {
      'toEmail': toEmail,
      'nombreCompleto': nombreCompleto,
      'empresa': empresa,
      'tipCap': nombreCapacitacion,
      'dias': dia,
      'horaE': hora,
      'extras': adicional,
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
          backgroundColor: Colors.teal,
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      throw Exception('Error al enviar el correo: ${response.body}');
    }
  }

  Future<void> enviarCorreoProyectos({
    required String toEmail,
    required String nombreCompleto,
    required String empresa,
    required String nombreProyecto,
    required Map<String, String> adicional,
  }) async {
    final url = Uri.parse(
      'http://10.7.234.137:5090/api/email/solicitud-proyecto',
    );

    final body = {
      'toEmail': toEmail,
      'nombreCompleto': nombreCompleto,
      'empresa': empresa,
      'tipCap': nombreProyecto,
      'extras': adicional,
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

  // Encuesta de satisfacción
  Future<void> enviarEncuestaSatisfaccion({
    required String toEmail,
    required String nombreCompleto,
    required String empresa,
    required String contacto,
    required String fecha,
    required String puesto,
    required String calificacion,
    required String conformidad,
    required String notas,
  }) async {
    final url = Uri.parse(
      'http://10.7.234.137:5090/api/email/encuesta-satisfaccion', // endpoint dedicado
    );

    final body = {
      'toEmail': toEmail,
      'nombreCompleto': nombreCompleto,
      'empresa': empresa,
      'contacto': contacto,
      'fecha': fecha,
      'puesto': puesto,
      'calificacion': calificacion,
      'conformidad': conformidad,
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
            "Agradecemos por tu tiempo",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.greenAccent,
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      throw Exception("Error al enviar encuesta: ${response.body}");
    }
  }

  // METODOS PARA POLIPASTOS
  final List<Map<String, dynamic>> _cargarPolipastos = [
    {
      'id': '1',
      'nombre': 'Polipasto Electrico',
      'categoria': 'Polipastos',
      'descripcion':
          'Levantamiento de carga segura y eficiente medinate el uso manual',
      'imagen': 'assets/polipastos_electricos.webp',
      'campos': [
        {
          'label': 'Tipo',
          'tipo': 'selector',
          'opciones': ['De Cadena (Cadena de eslabón)', 'De Cable de Acero'],
        },
        {
          'label': 'Capacidad de carga',
          'tipo': 'selector',
          'opciones': [
            '250 kg',
            '500 kg',
            '750 kg',
            '1000 kg',
            '1500 kg',
            '2000 kg',
            '2500 kg',
            '3000 kg',
            '3500 kg',
          ],
        },
        {
          'label': 'Tipo de suspensión',
          'tipo': 'selector',
          'opciones': ['Gancho', 'Carro eléctrico', 'Carro manual'],
        },
        {
          'label': 'Voltaje',
          'tipo': 'selector',
          'opciones': ['110 V', '220 V', '440 V'],
        },
        {
          'label': 'Aplicación del equipo',
          'tipo': 'selector',
          'opciones': ['Químico', 'Mécanico', 'Corrosivo'],
        },
        {
          'label': 'Izaje (m)',
          'tipo': 'selector',
          'opciones': [
            '3 m',
            '4 m',
            '5 m',
            '6 m',
            '7 m',
            '8 m',
            '9 m',
            '10 m',
            '11 m',
            '12 m',
            '13 m',
            '14 m',
            '15 m',
          ],
        },
        {
          'label': 'Notas',
          'tipo': 'texto',
          'multilinea': true,
          'maxCaracteres': 500,
        },
      ],
    },
    {
      'id': '2',
      'nombre': 'Polipasto Neumático',
      'categoria': 'Polipastos',
      'descripcion': 'Elevación medinate aire comprimido',
      'imagen': 'assets/polipasto_neumatico.png',
      'campos': [
        {
          'label': 'Capacidad de carga',
          'tipo': 'selector',
          'opciones': ['250 kg', '500 kg', '1000 kg', '2000 kg', '3000 kg'],
        },
        {
          'label': 'Izaje (m)',
          'tipo': 'selector',
          'opciones': [
            '3 m',
            '4 m',
            '5 m',
            '6 m',
            '7 m',
            '8 m',
            '9 m',
            '10 m',
            '11 m',
            '12 m',
            '13 m',
            '14 m',
            '15 m',
          ],
        },
        {
          'label': 'Tipo de suspensión',
          'tipo': 'selector',
          'opciones': ['Gancho', 'Trole motorizado', 'Trole manual'],
        },
        {
          'label': 'Aplicación del equipo',
          'tipo': 'selector',
          'opciones': ['Químico', 'Mécanico', 'Corrosivo'],
        },
        {
          'label': 'Notas',
          'tipo': 'texto',
          'multilinea': true,
          'maxCaracteres': 500,
        },
      ],
    },
    {
      'id': '3',
      'nombre': 'Polipasto Manual de Cadena',
      'categoria': 'Polipastos',
      'descripcion':
          'Elevación de cargas mediante cadena de mano, operación manual',
      'imagen': 'assets/poli_cadena_m.webp',
      'campos': [
        {
          'label': 'Capacidad de carga',
          'tipo': 'selector',
          'opciones': ['1000 kg', '2000 kg', '3000 kg', '5000 kg', '10000 kg'],
        },
        {
          'label': 'Izaje (m)',
          'tipo': 'selector',
          'opciones': [
            '3 m',
            '4 m',
            '5 m',
            '6 m',
            '7 m',
            '8 m',
            '9 m',
            '10 m',
            '11 m',
            '12 m',
            '13 m',
            '14 m',
            '15 m',
          ],
        },
        {
          'label': 'Tipo de suspensión',
          'tipo': 'selector',
          'opciones': ['Gancho', 'Trole manual'],
        },
        {
          'label': 'Aplicación del equipo',
          'tipo': 'selector',
          'opciones': ['Químico', 'Mécanico', 'Corrosivo'],
        },
        {
          'label': 'Notas',
          'tipo': 'texto',
          'multilinea': true,
          'maxCaracteres': 500,
        },
      ],
    },
    {
      'id': '4',
      'nombre': 'Polipasto Manual de Palanca',
      'categoria': 'Polipastos',
      'descripcion':
          'Utilizado para tensar y arrastrar cargas mediante palanca',
      'imagen': 'assets/poli_palanca.jpg',
      'campos': [
        {
          'label': 'Capacidad de carga',
          'tipo': 'selector',
          'opciones': ['750 kg', '1500 kg', '3000 kg', '6000 kg'],
        },
        {
          'label': 'Izaje (m)',
          'tipo': 'selector',
          'opciones': [
            '3 m',
            '4 m',
            '5 m',
            '6 m',
            '7 m',
            '8 m',
            '9 m',
            '10 m',
            '11 m',
            '12 m',
            '13 m',
            '14 m',
            '15 m',
          ],
        },
        {
          'label': 'Aplicación del equipo',
          'tipo': 'selector',
          'opciones': ['Químico', 'Mécanico', 'Corrosivo'],
        },
        {
          'label': 'Notas',
          'tipo': 'texto',
          'multilinea': true,
          'maxCaracteres': 500,
        },
      ],
    },
  ];

  void _mostrarFormularioPolipastos(
    BuildContext context,
    Map<String, dynamic> polipast,
  ) {
    final campos = polipast['campos'] as List<dynamic>;
    final scaffoldContext = context;

    // Controladores para los campos de texto y seleccionados
    final Map<String, TextEditingController> txtControllers = {};
    final Map<String, String?> selecValuesController = {};

    for (var campo in campos) {
      if (campo['tipo'] == 'selector') {
        selecValuesController[campo['label']] = null;
      } else {
        txtControllers[campo['label']] = TextEditingController();
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text("Accesorio: ${polipast['nombre']}"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Categoría: ${polipast['categoria']}"),
                const SizedBox(height: 8),
                Text("Descripción: ${polipast['descripcion']}"),
                const SizedBox(height: 16),

                // Generar campos dinámicamente
                for (var campo in campos)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: campo['tipo'] == 'selector'
                        ? DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: selecValuesController[campo['label']],
                            items: (campo['opciones'] as List<String>)
                                .map(
                                  (opcion) => DropdownMenuItem(
                                    value: opcion,
                                    child: Text(
                                      opcion,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              selecValuesController[campo['label']] = value;
                            },
                            decoration: InputDecoration(
                              labelText: campo['label'],
                              border: OutlineInputBorder(),
                            ),
                          )
                        : TextField(
                            controller: txtControllers[campo['label']],
                            keyboardType: campo['tipo'] == 'numero'
                                ? TextInputType.number
                                : (campo['multilinea'] == true
                                      ? TextInputType.multiline
                                      : TextInputType.text),
                            //: TextInputType.text,
                            maxLines: campo['multilinea'] == true ? null : 1,
                            inputFormatters: [
                              if (campo['tipo'] == 'numero') ...[
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]'),
                                ),
                                if (campo['label'].toLowerCase() == 'cantidad')
                                  LengthLimitingTextInputFormatter(4),
                              ],
                              if (campo['tipo'] == 'texto' &&
                                  campo['multilinea'] != true) ...[
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]'),
                                ),
                                LengthLimitingTextInputFormatter(10),
                              ],
                              if (campo['multilinea'] == true) ...[
                                LengthLimitingTextInputFormatter(
                                  campo['maxCaracteres'] ?? 100,
                                ),
                              ],
                              if (campo['label'].toLowerCase().contains(
                                    'Modelo',
                                  ) ||
                                  campo['label'].toLowerCase().contains(
                                    'Número de Serie',
                                  )) ...[
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'a-zA-Z0-9áéíóúÁÉÍÓÚñÑ\s]'),
                                ),
                                LengthLimitingTextInputFormatter(10),
                              ],
                            ],
                            decoration: InputDecoration(
                              labelText: campo['label'],
                              border: const OutlineInputBorder(),
                            ),
                          ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                bool camposCompletos = true;

                txtControllers.forEach((label, controller) {
                  if (controller.text.trim().isEmpty) {
                    camposCompletos = false;
                  }
                });
                selecValuesController.forEach((label, valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    camposCompletos = false;
                  }
                });

                if (!camposCompletos) {
                  ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                    const SnackBar(
                      content: Text("Por favor completa todos los campos."),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return; // No cerrar y no enviar
                }

                Navigator.of(context).pop();
                // Recolectamos los Datos del formulario
                Map<String, String> datosFormulario = {};
                txtControllers.forEach((label, controller) {
                  datosFormulario[label] = controller.text;
                });
                selecValuesController.forEach((label, valor) {
                  datosFormulario[label] = valor ?? '';
                });

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
                        Text("Enviando solicitud..."),
                      ],
                    ),
                    duration: Duration(seconds: 5),
                    backgroundColor: Colors.blue,
                  ),
                );

                // Enviar correo con los datos
                try {
                  await enviarCorreoPolipastos(
                    toEmail: widget.correo,
                    nombreCompleto: widget.nombreCompleto,
                    empresa: widget.empresa,
                    nombrePolipasto: polipast['nombre'],
                    datosFormulario: datosFormulario,
                  );
                } catch (e) {
                  // if(!mounted) return; // chequeo de seguridad
                  ScaffoldMessenger.of(scaffoldContext).hideCurrentSnackBar();
                  ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                    SnackBar(
                      content: Text("Error al enviar la solicitud: $e"),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  Widget _vistaPolipastos() {
    if (_cargarPolipastos.isEmpty) {
      return const Center(child: Text('No hay accesorios disponibles'));
    }
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 80), // espacio para el FAB
      childAspectRatio: 0.70,
      children: _cargarPolipastos.map((producto) {
        final nombre = producto['nombre']!;
        final categoria = producto['categoria']!;
        final descripcion = producto['descripcion']!;
        final imagenlocal = producto['imagen']!;

        return GestureDetector(
          onTap: () => _mostrarFormularioPolipastos(context, producto),
          child: Card(
            elevation: 5,
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.asset(imagenlocal, fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nombre,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "Categoría: $categoria",
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        "Descripción: $descripcion",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // METODOS DE SERVICIOS
  final List<Map<String, dynamic>> _cargarServicios = [
    {
      'id': '1',
      'nombre': 'Mantenimiento Preventivo',
      'categoria': 'Servicios',
      'descripcion': 'Revisión mecánica y eléctrica completa para reducir desgastes y/o daños mayores.',
      'imagen': 'assets/Serv_MantePrev.jpeg',
      "campos": [
        {
          "label": "Comentarios / observaciones",
          "tipo": "texto",
          'multilinea': true,
          'maxCaracteres': 500,
        },
      ],
    },
    {
      'id': '2',
      'nombre': 'Mantenimiento Correctivo',
      'categoria': 'Servicios',
      'descripcion': 'Correción y cambio de piezas para un correcto funcionamiento eléctrico y mecánico.',
      'imagen': 'assets/Serv_Rep_E.jpeg',
      "campos": [
        {
          "label": "Comentarios / observaciones",
          "tipo": "texto",
          'multilinea': true,
          'maxCaracteres': 500,
        },
      ],
    },
    {
      'id': '3',
      'nombre': 'Montaje de equipo',
      'categoria': 'Servicios',
      'descripcion': 'Colocación del equipo y correcta conexión de fases y pruebas de uso.',
      'imagen': 'assets/Serv_Instalacion.jpeg',
      "campos": [
        {"label": "Área a trabajar", "tipo": "texto"},
        {"label": "Altura (m)", "tipo": "numero"},
        {
          "label": "Tipo de suspención",
          "tipo": "selector",
          "opciones": ["Trole", "Gancho", "Fija"],
        },
        {"label": "Número de contacto", "tipo": "numero"},
      ],
    },
    {
      'id': '4',
      'nombre': 'Levantamiento',
      'categoria': 'Servicios',
      'descripcion':
          'Visita ténica para mediciones, características y revisión para la instalación de equipos de carga.',
      'imagen': 'assets/Serv_Inspeccion.jpeg',
      "campos": [
        {"label": "EPP a ocupar", "tipo": "texto"},
      ],
    },
  ];

  Widget _vistaServicios() {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 80),
      childAspectRatio: 0.70,
      children: _cargarServicios.map((servicio) {
        final nombre = servicio['nombre']!;
        final descripcion = servicio['descripcion']!;
        final imagen = servicio['imagen']!;
        final campos = servicio['campos'] as List<dynamic>;

        return GestureDetector(
          onTap: () {
            // Campos comunes
            final fechaController = TextEditingController();
            final horaController = TextEditingController();

            // Campos propios de cada capacitación
            final Map<String, TextEditingController> camposControllers = {};
            for (var campo in campos) {
              camposControllers[campo['label']] = TextEditingController();
            }

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      scrollable: true,
                      title: Text(
                        "Capacitación: $nombre \n $descripcion",
                        style: const TextStyle(fontSize: 20),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Campo de Fecha
                          TextField(
                            controller: fechaController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Fecha de capacitación',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.calendar_today_rounded),
                            ),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                locale: const Locale('es', 'MX'),
                              );
                              if (pickedDate != null) {
                                fechaController.text =
                                    "${pickedDate.day.toString().padLeft(2, '0')}/"
                                    "${pickedDate.month.toString().padLeft(2, '0')}/"
                                    "${pickedDate.year}";
                              }
                            },
                          ),
                          const SizedBox(height: 12),

                          // Campo de Hora
                          TextField(
                            controller: horaController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Hora de capacitación',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.access_alarm_rounded),
                            ),
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (pickedTime != null) {
                                final now = DateTime.now();
                                horaController.text = DateFormat.jm().format(
                                  DateTime(
                                    now.year,
                                    now.month,
                                    now.day,
                                    pickedTime.hour,
                                    pickedTime.minute,
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 12),

                          // 📝 Campos propios de cada servicio
                          ...campos.map((campo) {
                            final label = campo['label'] as String;
                            final tipo = campo['tipo'] as String;
                            final opciones =
                                campo['opciones'] as List<dynamic>?;

                            // Controlador de texto
                            final controller = camposControllers[label]!;

                            // Si es selector, usa Dropdown
                            if (tipo == 'selector' && opciones != null) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: label,
                                    border: const OutlineInputBorder(),
                                  ),
                                  items: opciones.map<DropdownMenuItem<String>>(
                                    (opcion) {
                                      return DropdownMenuItem(
                                        value: opcion.toString(),
                                        child: Text(opcion.toString()),
                                      );
                                    },
                                  ).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      controller.text = value ?? '';
                                    });
                                  },
                                  value: controller.text.isNotEmpty
                                      ? controller.text
                                      : null,
                                ),
                              );
                            }

                            // Si es número
                            if (tipo == 'numero') {
                              return Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: TextField(
                                  controller: controller,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    if (label == "Número de contacto")
                                      LengthLimitingTextInputFormatter(10),
                                  ],
                                  decoration: InputDecoration(
                                    labelText: label,
                                    hintText: label == "Número de contacto"
                                        ? "Ingresa un número de 10 dígitos"
                                        : null,
                                    border: const OutlineInputBorder(),
                                  ),
                                ),
                              );
                            }

                            // Por defecto: texto
                            return Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: TextField(
                                controller: controller,
                                keyboardType: campo['multilinea'] == true
                                    ? TextInputType.multiline
                                    : TextInputType.text,
                                //: TextInputType.text,
                                maxLines: campo['multilinea'] == true
                                    ? null
                                    : 1,
                                inputFormatters: [
                                  if (campo['multilinea'] == true) ...[
                                    LengthLimitingTextInputFormatter(
                                      campo['maxCaracteres'] ?? 100,
                                    ),
                                  ],
                                ],
                                decoration: InputDecoration(
                                  labelText: label,
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Cancelar"),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final fecha = fechaController.text.trim();
                            final hora = horaController.text.trim();
                            // Capturar campos propios
                            final datosServicio = <String, String>{};
                            camposControllers.forEach((campo, controller) {
                              datosServicio[campo] = controller.text.trim();
                            });

                            if (fecha.isEmpty || hora.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Por favor completa los campos de fecha y hora",
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            // Validacion de campos no vacios 
                            // Verificar que todos los campos del servicio estén llenos
                            bool camposVacios = false;
                            camposControllers.forEach((label, controller) {
                              if (controller.text.trim().isEmpty) {
                                camposVacios = true;
                              }
                            });

                            if (camposVacios) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Por favor completa todos los campos antes de enviar."),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            

                            // FILTRAR campo "Número de contacto"
                            final numeroContacto =
                                datosServicio["Número de contacto"];
                            if (numeroContacto != null &&
                                numeroContacto.isNotEmpty) {
                              if (numeroContacto.length != 10) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "El número de contacto debe tener 10 dígitos.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                                return;
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Por favor ingresa un número de contacto.",
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

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
                                    Text("Enviando solicitud..."),
                                  ],
                                ),
                                duration: Duration(seconds: 3),
                                backgroundColor: Colors.blue,
                              ),
                            );

                            try {
                              await enviarCorreoServicios(
                                toEmail: widget.correo,
                                nombreCompleto: widget.nombreCompleto,
                                empresa: widget.empresa,
                                nombreServicio: nombre,
                                dia: fecha,
                                hora: hora,
                                extras: datosServicio,
                              );
                            } catch (e) {
                              // if(!mounted) return; // chequeo de seguridad
                              ScaffoldMessenger.of(
                                context,
                              ).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Error al enviar la solicitud: $e",
                                  ),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          child: const Text("Enviar solicitud"),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
          child: Card(
            elevation: 5,
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.asset(imagen, fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nombre,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "Descripción: $descripcion",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
  // METODOS PARA ACCESORIOS
  final List<Map<String, dynamic>> _cargarAccesorios = [
    {
      'id': '1',
      'nombre': 'Botonera',
      'categoria': 'Accesorios',
      'descripcion': 'Botonera de velocidades y movimientos.',
      'imagen': 'assets/BOTONERA.jpg',
      'campos': [
        {
          'label': 'Cantidad',
          'tipo': 'selector',
          'opciones': ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
        },
        {
          'label': 'Tipo de Botonera',
          'tipo': 'selector',
          'opciones': ['Inalámbrica', 'Colgante'],
        },
        {
          'label': 'Numero de movimientos',
          'tipo': 'selector',
          'opciones': ['2 movimientos', '4 movimientos', '6 movimientos'],
        },
        {
          'label': 'Paro de emergencia',
          'tipo': 'selector',
          'opciones': ['Con paro de emergencia', 'Sin paro de emergencia'],
        },
        {
          'label': 'Tipo de arranque',
          'tipo': 'selector',
          'opciones': ['Con encendido', 'Sin encendido'],
        },
        {
          'label': 'Numero de velocidades',
          'tipo': 'selector',
          'opciones': ['1 velocidad', '2 velocidades'],
        },
        {
          'label': 'Notas',
          'tipo': 'texto',
          'multilinea': true,
          'maxCaracteres': 100,
        },
      ],
    },
    {
      'id': '2',
      'nombre': 'Trole',
      'categoria': 'Accesorios',
      'descripcion': 'Trole y trole para vigas curvas',
      'imagen': 'assets/TROLE.webp',
      'campos': [
        {
          'label': 'Tipo',
          'tipo': 'selector',
          'opciones': ['Manual', 'Neumático', 'Eléctrico'],
        },
        {'label': 'Capacidad de carga', 'tipo': 'numero'},
        {'label': 'Dimensiones de la viga', 'tipo': 'texto'},
        {
          'label': 'Voltaje',
          'tipo': 'selector',
          'opciones': ['220 V', '440 V'],
        },
        {'label': 'Notas', 'tipo': 'texto'},
      ],
    },
    {
      'id': '3',
      'nombre': 'Cable de Carga',
      'categoria': 'Accesorios',
      'descripcion': 'Cable espaecial para realizar cargas.',
      'imagen': 'assets/cableAcero.jpeg',
      'campos': [
        {'label': 'Estructura', 'tipo': 'texto'},
        {'label': 'Longitud', 'tipo': 'numero'},
        {'label': 'Capacidad de carga', 'tipo': 'numero'},
        {'label': 'Marca del polipasto', 'tipo': 'texto'},
        {'label': 'Tipo de terminado en extremos', 'tipo': 'texto'},
        {'label': 'Modelo del polipasto', 'tipo': 'texto'},
      ],
    },
    {
      'id': '4',
      'nombre': 'Gancho de carga',
      'categoria': 'Accesorios',
      'descripcion': 'Gancho de seguridad para polipastos y grúas.',
      'imagen': 'assets/GanchoSeguridad.jpeg',
      'campos': [
        {
          'label': 'Tipo de polipasto',
          'tipo': 'selector',
          'opciones': ['De Cable', 'De Cadena'],
        },
        {'label': 'Marca del polipasto', 'tipo': 'texto'},
        {'label': 'Número de Parte', 'tipo': 'texto'},
        {'label': 'Modelo del polipasto', 'tipo': 'texto'},
        {'label': 'Capacidad de carga', 'tipo': 'numero'},
      ],
    },
    {
      'id': '5',
      'nombre': 'Frenos de disco / Balatas',
      'categoria': 'Accesorios',
      'descripcion': 'Frenos de rodamiento',
      'imagen': 'assets/FRENOS.jpeg',
      'campos': [
        {'label': 'Capacidad de carga', 'tipo': 'numero'},
        {'label': 'Marca del polipasto', 'tipo': 'texto'},
        {'label': 'No. de parte', 'tipo': 'texto'},
        {'label': 'Modelo del polipasto', 'tipo': 'texto'},
      ],
    },
    {
      'id': '6',
      'nombre': 'Estrobo de Carga',
      'categoria': 'Accesorios',
      'descripcion': 'Estrobo para levantamiento de cargas pesadas.',
      'imagen': 'assets/ESTROBO_DE_CARGA.jpg',
      'campos': [
        {
          'label': 'Tipo',
          'tipo': 'selector',
          'opciones': ['Cable de acero', 'Cadena', 'Poliester'],
        },
        {'label': 'Longitud', 'tipo': 'numero'},
        {
          'label': 'Número de ramales',
          'tipo': 'selector',
          'opciones': ['1', '2', '3', '4'],
        },
        {'label': 'Capacidad de carga', 'tipo': 'numero'},
        {'label': 'Acessorios', 'tipo': 'texto'},
      ],
    },
    {
      'id': '7',
      'nombre': 'Contactores',
      'categoria': 'Accesorios',
      'descripcion':
          'Elemento que establece o interrumpe la corriente electrica.',
      'imagen': 'assets/CONTACTORES.png',
      'campos': [
        {
          'label': 'Voltaje',
          'tipo': 'selector',
          'opciones': ['220 V', '440 V'],
        },
        {'label': 'Marca', 'tipo': 'texto'},
        {'label': 'No. de parte', 'tipo': 'texto'},
        {'label': 'Modelo', 'tipo': 'texto'},
      ],
    },
    {
      'id': '8',
      'nombre': 'Tirfor',
      'categoria': 'Accesorios',
      'descripcion': 'Tirfor para tracción manual de cargas.',
      'imagen': 'assets/TIRFOR.webp',
      'campos': [
        {
          'label': 'Tipo',
          'tipo': 'selector',
          'opciones': ['Acero', 'Aluminio'],
        },
        {'label': 'Modelo', 'tipo': 'texto'},
        {'label': 'Capacidad de carga', 'tipo': 'numero'},
        {
          'label': 'Cable incluido',
          'tipo': 'selector',
          'opciones': ['Sí', 'No'],
        },
        {'label': 'Longitud', 'tipo': 'numero'},
        {'label': 'Accesorios de cable', 'tipo': 'texto'},
      ],
    },
    {
      'id': '9',
      'nombre': 'Seguro de gancho',
      'categoria': 'Accesorios',
      'descripcion': 'Mosquetón con cierre de seguridad.',
      'imagen': 'assets/SEGURO_DE_GANCHO.jpg',
      'campos': [
        {'label': 'Modelo', 'tipo': 'texto'},
        {'label': 'Marca', 'tipo': 'texto'},
        {'label': 'No. de parte', 'tipo': 'texto'},
      ],
    },
    {
      'id': '10',
      'nombre': 'Guias de cadena',
      'categoria': 'Accesorios',
      'descripcion':
          'Componente que regula el angulo y dirección de la cadena.',
      'imagen': 'assets/GUIA_DE_CADENA.jpeg',
      'campos': [
        {'label': 'Capacidad de carga', 'tipo': 'numero'},
        {'label': 'Marca', 'tipo': 'numero'},
        {'label': 'No. de parte', 'tipo': 'texto'},
        {'label': 'Modelo', 'tipo': 'numero'},
      ],
    },
    {
      'id': '11',
      'nombre': 'Guarda cadena',
      'categoria': 'Accesorios',
      'descripcion': 'Protege, sostiene y transporta cadenas en su interior.',
      'imagen': 'assets/GUARDA_CADENA.png',
      'campos': [
        {'label': 'Marca', 'tipo': 'texto'},
        {'label': 'Modelo', 'tipo': 'texto'},
        {'label': 'Longitud de cadena (m)', 'tipo': 'numero'},
      ],
    },
    {
      'id': '12',
      'nombre': 'Cadena',
      'categoria': 'Accesorios',
      'descripcion': 'Elemento que soporta y eleva cargas.',
      'imagen': 'assets/CADENAS_DE_ELEVACION.avif',
      'campos': [
        {'label': 'Longitud (m)', 'tipo': 'numero'},
        {'label': 'Medida', 'tipo': 'numero'},
        {'label': 'Marca', 'tipo': 'texto'},
        {'label': 'Modelo', 'tipo': 'texto'},
        {'label': 'Capacidad de carga', 'tipo': 'numero'},
        {'label': 'No. de parte', 'tipo': 'texto'},
        {'label': 'Características especiales', 'tipo': 'texto'},
      ],
    },
    {
      'id': '13',
      'nombre': 'Bobina / inductor',
      'categoria': 'Accesorios',
      'descripcion': 'Bobinas de freno electromagnéticas.',
      'imagen': 'assets/BOBINAS.jpeg',
      'campos': [
        {
          'label': 'Voltaje',
          'tipo': 'selector',
          'opciones': ['220 V', '440 V'],
        },
        {
          'label': 'Corriente',
          'tipo': 'selector',
          'opciones': ['Directa', 'Alterna'],
        },
        {'label': 'Marca', 'tipo': 'texto'},
        {'label': 'Modelo', 'tipo': 'texto'},
        {'label': 'No. de parte', 'tipo': 'texto'},
      ],
    },
    {
      'id': '14',
      'nombre': 'Nuez de carga',
      'categoria': 'Accesorios',
      'descripcion':
          'Herramienta de sujeción que garantiza el izaje de objetos pesados.',
      'imagen': 'assets/NUEZ_DE_CARGA.jpg',
      'campos': [
        {'label': 'Capacidad de carga', 'tipo': 'numero'},
        {'label': 'Marca del polipasto', 'tipo': 'texto'},
        {'label': 'No. de parte', 'tipo': 'texto'},
        {'label': 'Modelo del polipasto', 'tipo': 'texto'},
      ],
    },
    {
      'id': '15',
      'nombre': 'Engranes',
      'categoria': 'Accesorios',
      'descripcion': 'Mecanismo motriz que recibe movimiento o fuerza.',
      'imagen': 'assets/ENGRANE.jpg',
      'campos': [
        {'label': 'Marca', 'tipo': 'texto'},
        {'label': 'Modelo', 'tipo': 'texto'},
        {'label': 'No. de parte', 'tipo': 'texto'},
      ],
    },
    {
      'id': '16',
      'nombre': 'Limit switch',
      'categoria': 'Accesorios',
      'descripcion': 'Dispositivo de seguridad para evitar sobrecarga.',
      'imagen': 'assets/LIMITADOR.png',
      'campos': [
        {'label': 'Marca', 'tipo': 'texto'},
        {'label': 'Modelo', 'tipo': 'texto'},
        {'label': 'No. de parte', 'tipo': 'texto'},
        {
          'label': 'Instalacion',
          'tipo': 'selector',
          'opciones': ['Con instalación', 'Sin instalación'],
        },
        {
          'label': 'Voltaje de conexión',
          'tipo': 'selector',
          'opciones': ['24 V', '48 V', '110 V', '220 V', '440 V'],
        },
      ],
    },
    {
      'id': '17',
      'nombre': 'Cable de control',
      'categoria': 'Accesorios',
      'descripcion': 'Cables para alimentación de polipastos.',
      'imagen': 'assets/CABLE_ALIMENTACION.webp',
      'campos': [
        {'label': 'Calibre', 'tipo': 'texto'},
        {'label': 'Numero de hilos', 'tipo': 'numero'},
        {'label': 'Longitud (m)', 'tipo': 'numero'},
        {'label': 'Notas', 'tipo': 'texto'},
      ],
    },
    {
      'id': '18',
      'nombre': 'Rodamientos',
      'categoria': 'Accesorios',
      'descripcion':
          'Rodamiento para altas jornadas laborales, para polipastos o similares',
      'imagen': 'assets/RODAMIENTOS.jpg',
      'campos': [
        {'label': 'Marca del polipasto', 'tipo': 'texto'},
        {'label': 'No. de parte', 'tipo': 'texto'},
        {'label': 'Modelo del polipasto', 'tipo': 'texto'},
        {'label': 'Nomenclatura del rodamiento', 'tipo': 'texto'},
      ],
    },
    {
      'id': '19',
      'nombre': 'Flechas o ejes de piñon',
      'categoria': 'Accesorios',
      'descripcion': 'Eje que conecta los engranes internos del equipo para realizar el movimiento subir bajar (elemento de desgaste)',
      'imagen': 'assets/FLECHA.jpg',
      'campos': [
        {'label': 'Marca del polipasto', 'tipo': 'texto'},
        {'label': 'No. de parte', 'tipo': 'texto'},
        {'label': 'Modelo del polipasto', 'tipo': 'texto'},
      ],
    },
    {
      'id': '20',
      'nombre': 'Ruedas o rodajas de trole',
      'categoria': 'Accesorios',
      'descripcion': 'Elementos que permiten el traslado del trole sobre el patin de la viga',
      'imagen': 'assets/RODAJA.jpg',
      'campos': [
        {'label': 'Marca del polipasto', 'tipo': 'texto'},
        {'label': 'No. de parte', 'tipo': 'texto'},
        {'label': 'Modelo del polipasto', 'tipo': 'texto'},
        {'label': 'Capacidad de carga (kg)', 'tipo': 'numero'},
      ],
    },
  ];

  void _mostrarFormularioAccesorios(
    BuildContext context,
    Map<String, dynamic> accesorio,
  ) {
    final campos = accesorio['campos'] as List<dynamic>;
    final scaffoldContext = context;

    // Controladores para los campos de texto y seleccionados
    final Map<String, TextEditingController> txtControllers = {};
    final Map<String, String?> selecValuesController = {};

    for (var campo in campos) {
      if (campo['tipo'] == 'selector') {
        selecValuesController[campo['label']] = null;
      } else {
        txtControllers[campo['label']] = TextEditingController();
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text("Accesorio: ${accesorio['nombre']}"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Categoría: ${accesorio['categoria']}"),
                const SizedBox(height: 8),
                Text("Descripción: ${accesorio['descripcion']}"),
                const SizedBox(height: 16),

                // Generar campos dinámicamente
                for (var campo in campos)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: campo['tipo'] == 'selector'
                        ? DropdownButtonFormField<String>(
                            value: selecValuesController[campo['label']],
                            items: (campo['opciones'] as List<String>)
                                .map(
                                  (opcion) => DropdownMenuItem(
                                    value: opcion,
                                    child: Text(opcion),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              selecValuesController[campo['label']] = value;
                            },
                            decoration: InputDecoration(
                              labelText: campo['label'],
                              border: OutlineInputBorder(),
                            ),
                          )
                        : TextField(
                            controller: txtControllers[campo['label']],
                            keyboardType: campo['tipo'] == 'numero'
                                ? TextInputType.number
                                : (campo['multilinea'] == true
                                      ? TextInputType.multiline
                                      : TextInputType.text),
                            //: TextInputType.text,
                            maxLines: campo['multilinea'] == true ? null : 1,
                            inputFormatters: [
                              if (campo['tipo'] == 'numero') ...[
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]'),
                                ),
                                if (campo['label'].toLowerCase() == 'cantidad')
                                  LengthLimitingTextInputFormatter(4),
                              ],
                              if (campo['tipo'] == 'texto' &&
                                  campo['multilinea'] != true) ...[
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]'),
                                ),
                                LengthLimitingTextInputFormatter(10),
                              ],
                              if (campo['multilinea'] == true) ...[
                                LengthLimitingTextInputFormatter(
                                  campo['maxCaracteres'] ?? 100,
                                ),
                              ],
                              if (campo['label'].toLowerCase().contains(
                                    'Modelo',
                                  ) ||
                                  campo['label'].toLowerCase().contains(
                                    'Número de Serie',
                                  )) ...[
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'a-zA-Z0-9áéíóúÁÉÍÓÚñÑ\s]'),
                                ),
                                LengthLimitingTextInputFormatter(10),
                              ],
                            ],
                            decoration: InputDecoration(
                              labelText: campo['label'],
                              border: const OutlineInputBorder(),
                            ),
                          ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                bool camposCompletos = true;

                txtControllers.forEach((label, controller) {
                  if (controller.text.trim().isEmpty) {
                    camposCompletos = false;
                  }
                });
                selecValuesController.forEach((label, valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    camposCompletos = false;
                  }
                });

                if (!camposCompletos) {
                  ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                    const SnackBar(
                      content: Text("Por favor completa todos los campos."),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return; // No cerrar y no enviar
                }

                Navigator.of(context).pop();
                // Recolectamos los Datos del formulario
                Map<String, String> datosFormulario = {};
                txtControllers.forEach((label, controller) {
                  datosFormulario[label] = controller.text;
                });
                selecValuesController.forEach((label, valor) {
                  datosFormulario[label] = valor ?? '';
                });

                print('Datos Recolectados: $datosFormulario');

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
                        Text("Enviando solicitud..."),
                      ],
                    ),
                    duration: Duration(seconds: 5),
                    backgroundColor: Colors.blue,
                  ),
                );

                // Enviar correo con los datos
                try {
                  await enviarCorreoAccesorio(
                    toEmail: widget.correo,
                    nombreCompleto: widget.nombreCompleto,
                    empresa: widget.empresa,
                    nombreAccesorio: accesorio['nombre'],
                    datosFormulario: datosFormulario,
                  );

                  // Usar el contexto del widget padre (evitar contextos cerrados)
                  //if (!mounted) return;
                  //ScaffoldMessenger.of(scaffoldContext).hideCurrentSnackBar();
                } catch (e) {
                  // if(!mounted) return; // chequeo de seguridad
                  ScaffoldMessenger.of(scaffoldContext).hideCurrentSnackBar();
                  ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                    SnackBar(
                      content: Text("Error al enviar la solicitud: $e"),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  Widget _vistaAccesorios() {
    if (_cargarAccesorios.isEmpty) {
      return const Center(child: Text('No hay accesorios disponibles'));
    }
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 80), // espacio para el FAB
      childAspectRatio: 0.70,
      children: _cargarAccesorios.map((producto) {
        final nombre = producto['nombre']!;
        final categoria = producto['categoria']!;
        final descripcion = producto['descripcion']!;
        final imagenlocal = producto['imagen']!;

        return GestureDetector(
          onTap: () => _mostrarFormularioAccesorios(context, producto),
          child: Card(
            elevation: 5,
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.asset(imagenlocal, fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nombre,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "Categoría: $categoria",
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        "Descripción: $descripcion",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // METODOS PARA PATINES
  final List<Map<String, dynamic>> _cargarPatines = [
    {
      "id": "1",
      "nombre": "Patín Hidráulico",
      "categoria": "Equipos de Carga",
      "descripcion": "Patín hidráulico de la marca Crown",
      "imagen": "assets/PATIN_H.png",
      "campos": [
        {"label": "Modelo", "tipo": "texto"},
        {
          "label": "Capacidad de carga (kg)",
          "tipo": "selector",
          "opciones": ["1000", "1500", "2000", "2500", "3000", "5000"],
        },
        {"label": "Altura mínima (mm)", "tipo": "numero"},
        {"label": "Altura máxima (mm)", "tipo": "numero"},
        {"label": "Longitud de horquillas (mm)", "tipo": "numero"},
        {"label": "Ancho total (mm)", "tipo": "numero"},
        {
          "label": "Material de ruedas",
          "tipo": "selector",
          "opciones": ["Nylon", "Poliuretano", "Goma"],
        },
        {
          "label": "Tipo de ruedas",
          "tipo": "selector",
          "opciones": ["Simples", "Dobles", "Articuladas"],
        },
        {"label": "Peso del equipo (kg)", "tipo": "numero"},
        {"label": "Garantía (años)", "tipo": "numero"},
        {"label": "Comentarios / extras", "tipo": "texto"},
      ],
    },
    {
      "id": "2",
      "nombre": "Mini Montacargas",
      "categoria": "Equipos de Carga",
      "descripcion": "Patín hidráulico de la marca Toyota",
      "imagen": "assets/MINI_MONTA_MANUAL.png",
      "campos": [
        {"label": "Modelo", "tipo": "texto"},
        {
          "label": "Capacidad de carga (lb)",
          "tipo": "selector",
          "opciones": ["3000", "4500", "6000", "8000"],
        },
        {"label": "Altura mínima (mm)", "tipo": "numero"},
        {"label": "Altura máxima (mm)", "tipo": "numero"},
        {"label": "Longitud de horquillas (in)", "tipo": "numero"},
        {"label": "Ancho total (in)", "tipo": "numero"},
        {
          "label": "Material de ruedas",
          "tipo": "selector",
          "opciones": ["Nylon", "Poliuretano"],
        },
        {"label": "Peso del equipo (kg)", "tipo": "numero"},
        {"label": "Voltaje / sistema eléctrico", "tipo": "texto"},
        {"label": "Garantía", "tipo": "texto"},
      ],
    },
    {
      "id": "3",
      "nombre": "Carga Tambos",
      "categoria": "Equipos de Carga",
      "descripcion": "Patín hidráulico de la marca Toyota",
      "imagen": "assets/CARGA_TAMBOS.png",
      "campos": [
        {"label": "Modelo", "tipo": "texto"},
        {
          "label": "Capacidad de carga (lb)",
          "tipo": "selector",
          "opciones": ["3000", "4500", "6000", "8000"],
        },
        {"label": "Altura mínima (mm)", "tipo": "numero"},
        {"label": "Altura máxima (mm)", "tipo": "numero"},
        {"label": "Longitud de horquillas (in)", "tipo": "numero"},
        {"label": "Ancho total (in)", "tipo": "numero"},
        {
          "label": "Material de ruedas",
          "tipo": "selector",
          "opciones": ["Nylon", "Poliuretano"],
        },
        {"label": "Peso del equipo (kg)", "tipo": "numero"},
        {"label": "Voltaje / sistema eléctrico", "tipo": "texto"},
        {"label": "Garantía", "tipo": "texto"},
      ],
    },
  ];

  void _mostrarFormularioPatines(
    BuildContext context,
    Map<String, dynamic> patin,
  ) {
    final campos = patin['campos'] as List<dynamic>;
    final scaffoldContext = context;

    // Controladores para los campos de texto y seleccionados
    final Map<String, TextEditingController> txtControllers = {};
    final Map<String, String?> selecValuesController = {};

    for (var campo in campos) {
      if (campo['tipo'] == 'selector') {
        selecValuesController[campo['label']] = null;
      } else {
        txtControllers[campo['label']] = TextEditingController();
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text("Patín: ${patin['nombre']}"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Categoría: ${patin['categoria']}"),
                const SizedBox(height: 8),
                Text("Descripción: ${patin['descripcion']}"),
                const SizedBox(height: 16),

                // Generar campos dinámicamente
                for (var campo in campos)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: campo['tipo'] == 'selector'
                        ? DropdownButtonFormField<String>(
                            value: selecValuesController[campo['label']],
                            items: (campo['opciones'] as List<String>)
                                .map(
                                  (opcion) => DropdownMenuItem(
                                    value: opcion,
                                    child: Text(opcion),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              selecValuesController[campo['label']] = value;
                            },
                            decoration: InputDecoration(
                              labelText: campo['label'],
                              border: OutlineInputBorder(),
                            ),
                          )
                        : TextField(
                            controller: txtControllers[campo['label']],
                            keyboardType: campo['tipo'] == 'numero'
                                ? TextInputType.number
                                : (campo['multilinea'] == true
                                      ? TextInputType.multiline
                                      : TextInputType.text),
                            //: TextInputType.text,
                            maxLines: campo['multilinea'] == true ? null : 1,
                            inputFormatters: [
                              if (campo['tipo'] == 'numero') ...[
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]'),
                                ),
                                if (campo['label'].toLowerCase() == 'cantidad')
                                  LengthLimitingTextInputFormatter(4),
                              ],
                              if (campo['tipo'] == 'texto' &&
                                  campo['multilinea'] != true) ...[
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]'),
                                ),
                                LengthLimitingTextInputFormatter(10),
                              ],
                              if (campo['multilinea'] == true) ...[
                                LengthLimitingTextInputFormatter(
                                  campo['maxCaracteres'] ?? 100,
                                ),
                              ],
                              if (campo['label'].toLowerCase().contains(
                                    'Modelo',
                                  ) ||
                                  campo['label'].toLowerCase().contains(
                                    'Número de Serie',
                                  )) ...[
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'a-zA-Z0-9áéíóúÁÉÍÓÚñÑ\s]'),
                                ),
                                LengthLimitingTextInputFormatter(10),
                              ],
                            ],
                            decoration: InputDecoration(
                              labelText: campo['label'],
                              border: const OutlineInputBorder(),
                            ),
                          ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                bool camposCompletos = true;

                txtControllers.forEach((label, controller) {
                  if (controller.text.trim().isEmpty) {
                    camposCompletos = false;
                  }
                });
                selecValuesController.forEach((label, valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    camposCompletos = false;
                  }
                });

                if (!camposCompletos) {
                  ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                    const SnackBar(
                      content: Text("Por favor completa todos los campos."),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return; // No cerrar y no enviar
                }

                Navigator.of(context).pop();
                // Recolectamos los Datos del formulario
                Map<String, String> datosFormulario = {};
                txtControllers.forEach((label, controller) {
                  datosFormulario[label] = controller.text;
                });
                selecValuesController.forEach((label, valor) {
                  datosFormulario[label] = valor ?? '';
                });

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
                        Text("Enviando solicitud..."),
                      ],
                    ),
                    duration: Duration(seconds: 5),
                    backgroundColor: Colors.blue,
                  ),
                );

                // Enviar correo con los datos==================================
                try {
                  await enviarCorreoPatinHidraulico(
                    toEmail: widget.correo,
                    nombreCompleto: widget.nombreCompleto,
                    empresa: widget.empresa,
                    nombrePatin: patin['nombre'],
                    datosFormulario: datosFormulario,
                  );
                } catch (e) {
                  // if(!mounted) return; // chequeo de seguridad
                  ScaffoldMessenger.of(scaffoldContext).hideCurrentSnackBar();
                  ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                    SnackBar(
                      content: Text("Error al enviar la solicitud: $e"),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  Widget _vistaPatines() {
    if (_cargarPatines.isEmpty) {
      return const Center(child: Text('No hay accesorios disponibles'));
    }
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 80), // espacio para el FAB
      childAspectRatio: 0.70,
      children: _cargarPatines.map((producto) {
        final nombre = producto['nombre']!;
        //final categoria = producto['categoria']!;
        final descripcion = producto['descripcion']!;
        final imagenlocal = producto['imagen']!;

        return GestureDetector(
          onTap: () => _mostrarFormularioPatines(context, producto),
          child: Card(
            elevation: 5,
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.asset(imagenlocal, fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nombre,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      /*Text(
                        "Categoría: $categoria",
                        style: const TextStyle(fontSize: 14),
                      ),*/
                      Text(
                        "Descripción: $descripcion",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // METODOS PARA CAPACITACIONES
  final List<Map<String, dynamic>> _cargarCapacitaciones = [
    {
      "id": "1",
      "nombre": "Manejo de Polipastos",
      "categoria": "Capacitaciones",
      "descripcion": "Capacitación práctica sobre manejo seguro de polipastos.",
      "imagen": "assets/M_POLIPASTO.png",
      "campos": [
        {
          "label": "Capacitación",
          "tipo": "selector",
          "opciones": ["Con certificado", "Solo capacitación"],
        },
        {"label": "Número de personas", "tipo": "numero"},
        {
          "label": "Tipo de polipasto",
          "tipo": "selector",
          "opciones": ["Manual", "Eléctrico", "Neumático"],
        },
        {"label": "Número de contacto", "tipo": "numero"},
        {
          "label": "Comentarios / observaciones",
          "tipo": "texto",
          'multilinea': true,
          'maxCaracteres': 500,
        },
      ],
    },
    {
      "id": "2",
      "nombre": "Capacitación de bombas ENERPAC",
      "categoria": "Capacitaciones",
      "descripcion":
          "Capacitación sobre el suso adecuado de bombas de la linea ENERPAC",
      "imagen": "assets/CAP_ENERPAC.png",
      "campos": [
        {
          "label": "Capacitación",
          "tipo": "selector",
          "opciones": ["Con certificado", "Solo capacitación"],
        },
        {"label": "Número de personas", "tipo": "numero"},
        {"label": "Número de contacto", "tipo": "numero"},
        {
          "label": "Comentarios / observaciones",
          "tipo": "texto",
          'multilinea': true,
          'maxCaracteres': 500,
        },
      ],
    },
    {
      "id": "3",
      "nombre": "Manejo seguro de grúas viajeras",
      "categoria": "Capacitaciones",
      "descripcion":
          "Capacitación práctica sobre manejo seguro de grúas viajeras y protocolos de seguridad.",
      "imagen": "assets/MANEJO_GRUAS.png",
      "campos": [
        {
          "label": "Modelo de grúa",
          "tipo": "selector",
          "opciones": [
            "Bandera",
            "Portico Manual",
            "Portico Electrica",
            "Portico Virriel",
            "Suspendida",
          ],
        },
        {
          "label": "Capacitación",
          "tipo": "selector",
          "opciones": ["Con certificado", "Solo capacitación"],
        },
        {"label": "Número de participantes", "tipo": "numero"},
        {"label": "Número de contacto", "tipo": "numero"},
        {"label": "Lugar de capacitación", "tipo": "texto"},
        {
          "label": "Comentarios / observaciones",
          "tipo": "texto",
          'multilinea': true,
          'maxCaracteres': 500,
        },
      ],
    },
  ];

  Widget _vistaCapacitaciones() {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 80),
      childAspectRatio: 0.70,
      children: _cargarCapacitaciones.map((capacitacion) {
        final nombre = capacitacion['nombre']!;
        final descripcion = capacitacion['descripcion']!;
        final imagen = capacitacion['imagen']!;
        final campos = capacitacion['campos'] as List<dynamic>;

        return GestureDetector(
          onTap: () {
            // Campos comunes
            final fechaController = TextEditingController();
            final horaController = TextEditingController();

            // Campos propios de cada capacitación
            final Map<String, TextEditingController> camposControllers = {};
            for (var campo in campos) {
              camposControllers[campo['label']] = TextEditingController();
            }

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      scrollable: true,
                      title: Text(
                        "Capacitación: $nombre \n $descripcion",
                        style: const TextStyle(fontSize: 20),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Campo de Fecha
                          TextField(
                            controller: fechaController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Fecha de capacitación',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.calendar_today_rounded),
                            ),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                locale: const Locale('es', 'MX'),
                              );
                              if (pickedDate != null) {
                                fechaController.text =
                                    "${pickedDate.day.toString().padLeft(2, '0')}/"
                                    "${pickedDate.month.toString().padLeft(2, '0')}/"
                                    "${pickedDate.year}";
                              }
                            },
                          ),
                          const SizedBox(height: 12),

                          // Campo de Hora
                          TextField(
                            controller: horaController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Hora de capacitación',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.access_alarm_rounded),
                            ),
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (pickedTime != null) {
                                final now = DateTime.now();
                                horaController.text = DateFormat.jm().format(
                                  DateTime(
                                    now.year,
                                    now.month,
                                    now.day,
                                    pickedTime.hour,
                                    pickedTime.minute,
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 12),

                          // 📝 Campos propios de cada capacitación
                          ...campos.map((campo) {
                            final label = campo['label'] as String;
                            final tipo = campo['tipo'] as String;
                            final opciones =
                                campo['opciones'] as List<dynamic>?;

                            // Controlador de texto
                            final controller = camposControllers[label]!;

                            // Si es selector, usa Dropdown
                            if (tipo == 'selector' && opciones != null) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: label,
                                    border: const OutlineInputBorder(),
                                  ),
                                  items: opciones.map<DropdownMenuItem<String>>(
                                    (opcion) {
                                      return DropdownMenuItem(
                                        value: opcion.toString(),
                                        child: Text(opcion.toString()),
                                      );
                                    },
                                  ).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      controller.text = value ?? '';
                                    });
                                  },
                                  value: controller.text.isNotEmpty
                                      ? controller.text
                                      : null,
                                ),
                              );
                            }

                            // Si es número
                            if (tipo == 'numero') {
                              return Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: TextField(
                                  controller: controller,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    if (label == "Número de contacto")
                                      LengthLimitingTextInputFormatter(10),
                                  ],
                                  decoration: InputDecoration(
                                    labelText: label,
                                    hintText: label == "Número de contacto"
                                        ? "Ingresa un número de 10 dígitos"
                                        : null,
                                    border: const OutlineInputBorder(),
                                  ),
                                ),
                              );
                            }

                            // Por defecto: texto
                            return Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: TextField(
                                controller: controller,
                                keyboardType: campo['multilinea'] == true
                                    ? TextInputType.multiline
                                    : TextInputType.text,
                                //: TextInputType.text,
                                maxLines: campo['multilinea'] == true
                                    ? null
                                    : 1,
                                inputFormatters: [
                                  if (campo['multilinea'] == true) ...[
                                    LengthLimitingTextInputFormatter(
                                      campo['maxCaracteres'] ?? 100,
                                    ),
                                  ],
                                ],
                                decoration: InputDecoration(
                                  labelText: label,
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Cancelar"),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final fecha = fechaController.text.trim();
                            final hora = horaController.text.trim();

                            if (fecha.isEmpty || hora.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Por favor completa fecha y hora",
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            // Capturar campos propios
                            final datosCapacitacion = <String, String>{};
                            camposControllers.forEach((campo, controller) {
                              datosCapacitacion[campo] = controller.text.trim();
                            });

                            // Validacion de campos no vacios 
                            // Verificar que todos los campos del servicio estén llenos
                            bool camposVacios = false;
                            camposControllers.forEach((label, controller) {
                              if (controller.text.trim().isEmpty) {
                                camposVacios = true;
                              }
                            });

                            if (camposVacios) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Por favor completa todos los campos antes de enviar."),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            // FILTRAR campo "Número de contacto"
                            final numeroContacto =
                                datosCapacitacion["Número de contacto"];
                            if (numeroContacto != null &&
                                numeroContacto.isNotEmpty) {
                              if (numeroContacto.length != 10) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "El número de contacto debe tener 10 dígitos.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                                return;
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Por favor ingresa un número de contacto.",
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

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
                                    Text("Enviando solicitud..."),
                                  ],
                                ),
                                duration: Duration(seconds: 3),
                                backgroundColor: Colors.blue,
                              ),
                            );

                            try {
                              await enviarCorreoCapacitaciones(
                                toEmail: widget.correo,
                                nombreCompleto: widget.nombreCompleto,
                                empresa: widget.empresa,
                                nombreCapacitacion: nombre,
                                dia: fecha,
                                hora: hora,
                                adicional: datosCapacitacion,
                              );
                            } catch (e) {
                              // if(!mounted) return; // chequeo de seguridad
                              ScaffoldMessenger.of(
                                context,
                              ).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Error al enviar la solicitud: $e",
                                  ),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          child: const Text("Enviar solicitud"),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
          child: Card(
            elevation: 5,
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.asset(imagen, fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nombre,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "Descripción: $descripcion",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // METODOS DE PROYECTOS
  final List<Map<String, dynamic>> _cargarProyectos = [
    {
      "id": "1",
      "nombre": "Grúa Bandera",
      "categoria": "Proyecto de Fabricación",
      "descripcion":
          "Diseño, fabricación y ensamble de grúa bandera conforme a especificaciones técnicas y normativas de seguridad industrial.",
      "imagen": "assets/GRUA_BANDERA.png",
      "campos": [
        {"label": "Altura", "tipo": "numero"},
        {
          "label": "Capacidad (kg)",
          "tipo": "selector",
          "opciones": ["1000 kg", "1500 kg", "2000 kg"],
        },
        {
          "label": "Rango de giro (grados)",
          "tipo": "selector",
          "opciones": ["90°", "180°", "270°", "360°"],
        },
        {
          "label": "Voltaje (V)",
          "tipo": "selector",
          "opciones": ["220", "440"],
        },
        {
          "label": "Tipo de equipo",
          "tipo": "selector",
          "opciones": ["Manual", "Eléctrico", "Neumático"],
        },
        {"label": "Número de contacto", "tipo": "numero"},
        {
          "label": "Observaciones / notas técnicas",
          "tipo": "texto",
          'multilinea': true,
          'maxCaracteres': 500,
        },
      ],
    },
    {
      "id": "2",
      "nombre": "Grúa Portico Eléctrica",
      "categoria": "Proyecto de Fabricación",
      "descripcion":
          "Diseño, fabricación y ensamble de grúa portico eléctrica conforme a especificaciones técnicas industrial.",
      "imagen": "assets/GRUA_PORTICO_ELEC.jpg",
      "campos": [
        {"label": "Altura", "tipo": "numero"},
        {"label": "Recorrido de grúa (longitud)", "tipo": "numero"},
        {"label": "Recorrido de trole (longitud)", "tipo": "numero"},
        {
          "label": "Sistema de electrificación",
          "tipo": "selector",
          "opciones": ["Ductobarra", "Sistema festón"],
        },
        {
          "label": "Voltaje (V)",
          "tipo": "selector",
          "opciones": ["220", "440"],
        },
        {
          "label": "Capacidad (kg)",
          "tipo": "selector",
          "opciones": ["1000 kg", "1500 kg", "2000 kg"],
        },
        {"label": "Número de contacto", "tipo": "numero"},
        {
          "label": "Observaciones / notas técnicas",
          "tipo": "texto",
          'multilinea': true,
          'maxCaracteres': 500,
        },
      ],
    },
    {
      "id": "3",
      "nombre": "Grúa Portico Manual",
      "categoria": "Proyecto de Fabricación",
      "descripcion":
          "Diseño, fabricación y ensamble de grúa portico manual conforme a especificaciones técnicas y normativas de seguridad industrial.",
      "imagen": "assets/GRUA_PORTICO_MAN.webp",
      "campos": [
        {"label": "Altura", "tipo": "numero"},
        {
          "label": "Capacidad (kg)",
          "tipo": "selector",
          "opciones": ["1000 kg", "1500 kg", "2000 kg"],
        },
        {
          "label": "Sistema de navegación",
          "tipo": "selector",
          "opciones": ["Con riel", "Con ruedas"],
        },
        {"label": "Número de contacto", "tipo": "numero"},
        {
          "label": "Observaciones / notas técnicas",
          "tipo": "texto",
          'multilinea': true,
          'maxCaracteres': 500,
        },
      ],
    },
    {
      "id": "4",
      "nombre": "Grúa Birriel",
      "categoria": "Proyecto de Fabricación",
      "descripcion":
          "Diseño, fabricación y ensamble de grúa birriel conforme a especificaciones técnicas y normativas de seguridad industrial.",
      "imagen": "assets/GRUAS_VIAJERAS.jpg",
      "campos": [
        {"label": "Altura", "tipo": "numero"},
        {"label": "Recorrido de grúa (longitud)", "tipo": "numero"},
        {"label": "Recorrido de trole (longitud)", "tipo": "numero"},
        {
          "label": "Sistema de electrificación",
          "tipo": "selector",
          "opciones": ["Ductobarra", "Sistema festón"],
        },
        {
          "label": "Voltaje (V)",
          "tipo": "selector",
          "opciones": ["220", "440"],
        },
        {
          "label": "Capacidad (kg)",
          "tipo": "selector",
          "opciones": ["1000 kg", "1500 kg", "2000 kg"],
        },
        {
          "label": "Colocación de equipo",
          "tipo": "selector",
          "opciones": ["Suspendido", "Sobre los puentes"],
        },
        {"label": "Número de contacto", "tipo": "numero"},
        {
          "label": "Observaciones / notas técnicas",
          "tipo": "texto",
          'multilinea': true,
          'maxCaracteres': 500,
        },
      ],
    },
    {
      "id": "5",
      "nombre": "Grúa Monorriel",
      "categoria": "Proyecto de Fabricación",
      "descripcion":
          "Diseño, fabricación y ensamble de grúa monorriel conforme a especificaciones técnicas industrial.",
      "imagen": "assets/GRUA_MONORRIEL.png",
      "campos": [
        {"label": "Altura", "tipo": "numero"},
        {"label": "Recorrido de grúa (longitud)", "tipo": "numero"},
        {"label": "Recorrido de trole (longitud)", "tipo": "numero"},
        {
          "label": "Sistema de electrificación",
          "tipo": "selector",
          "opciones": ["Ductobarra", "Sistema festón"],
        },
        {
          "label": "Tipo",
          "tipo": "selector",
          "opciones": ["Por columnas", "Suspendida"],
        },
        {
          "label": "Voltaje (V)",
          "tipo": "selector",
          "opciones": ["220", "440"],
        },
        {
          "label": "Capacidad (kg)",
          "tipo": "selector",
          "opciones": ["1000 kg", "1500 kg", "2000 kg"],
        },
        {"label": "Número de contacto", "tipo": "numero"},
        {
          "label": "Observaciones / notas técnicas",
          "tipo": "texto",
          'multilinea': true,
          'maxCaracteres': 500,
        },
      ],
    },
  ];

  Widget _vistaProyectos() {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 80),
      childAspectRatio: 0.70,
      children: [
        GestureDetector(
          onTap: () {
            String? proyectoSeleccionado;
            Map<String, dynamic>? proyectoActual;
            Map<String, TextEditingController> camposControllers = {};
            Map<String, Map<String, TextEditingController>>
            todos_los_controladores = {};

            void limpiarCamposProyecto(String nombreProyecto) {
              if (todos_los_controladores.containsKey(nombreProyecto)) {
                for (var controller in todos_los_controladores[nombreProyecto]!.values) {
                  controller.clear();
                }
              }
            }

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    // Método interno para construir el formulario dinámico
                    Widget _formularioProyecto(Map<String, dynamic> proyecto) {
                      final campos = proyecto['campos'] as List<dynamic>;


                      return Column(
                        children: [
                          ...campos.map((campo) {
                            final label = campo['label'] as String;
                            final tipo = campo['tipo'] as String;
                            final opciones =
                                campo['opciones'] as List<dynamic>?;

                            final controller = camposControllers[label]!;

                            if (tipo == 'selector' && opciones != null) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: label,
                                    border: const OutlineInputBorder(),
                                  ),
                                  items: opciones.map<DropdownMenuItem<String>>(
                                    (op) {
                                      return DropdownMenuItem(
                                        value: op.toString(),
                                        child: Text(op.toString()),
                                      );
                                    },
                                  ).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      controller.text = value ?? '';
                                    });
                                  },
                                  value: controller.text.isNotEmpty
                                      ? controller.text
                                      : null,
                                ),
                              );
                            }

                            if (tipo == 'numero') {
                              return Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: TextField(
                                  controller: controller,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    if (label == "Número de contacto")
                                      LengthLimitingTextInputFormatter(10),
                                  ],
                                  decoration: InputDecoration(
                                    labelText: label,
                                    hintText: label == "Número de contacto"
                                        ? "Ingresa un número de 10 dígitos"
                                        : null,
                                    border: const OutlineInputBorder(),
                                  ),
                                ),
                              );
                            }

                            // Por defecto: campo de texto
                            return Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: TextField(
                                controller: controller,
                                keyboardType: campo['multilinea'] == true
                                    ? TextInputType.multiline
                                    : TextInputType.text,
                                maxLines: campo['multilinea'] == true
                                    ? null
                                    : 1,
                                inputFormatters: [
                                  if (campo['multilinea'] == true)
                                    LengthLimitingTextInputFormatter(
                                      campo['maxCaracteres'] ?? 100,
                                    ),
                                ],
                                decoration: InputDecoration(
                                  labelText: label,
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            );
                          }).toList(),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () async {
                              final datos = <String, String>{};
                              camposControllers.forEach((label, controller) {
                                datos[label] = controller.text.trim();
                              });

                              // Validación de número de contacto
                              final numero = datos["Número de contacto"];
                              if (numero == null || numero.length != 10) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Ingresa un número de contacto válido (10 dígitos)",
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                              Navigator.of(context).pop();

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Row(
                                    children: [
                                      CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 16),
                                      Text("Enviando solicitud..."),
                                    ],
                                  ),
                                  backgroundColor: Colors.blue,
                                  duration: Duration(seconds: 3),
                                ),
                              );

                              try {
                                await enviarCorreoProyectos(
                                  toEmail: widget.correo,
                                  nombreCompleto: widget.nombreCompleto,
                                  empresa: widget.empresa,
                                  nombreProyecto: proyecto['nombre'],
                                  adicional: datos,
                                );

                                // Limpia los campos del proyecto actual después de enviar
                                limpiarCamposProyecto(proyecto['nombre']);
                                
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Error al enviar: $e"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            child: const Text("Enviar solicitud"),
                          ),
                        ],
                      );
                    }

                    return AlertDialog(
                      scrollable: true,
                      title: const Text(
                        "Solicitud de Proyecto",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: "Selecciona un proyecto",
                              border: OutlineInputBorder(),
                            ),
                            value: proyectoSeleccionado,
                            items: _cargarProyectos.map((proyecto) {
                              return DropdownMenuItem<String>(
                                value: proyecto['nombre'] as String,
                                child: Text(proyecto['nombre'] as String),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                proyectoSeleccionado = value;
                                proyectoActual = _cargarProyectos.firstWhere(
                                  (p) => p['nombre'] == value,
                                );

                                // Si el proyecto NO tiene controladores aún, los crea
                                if (!todos_los_controladores.containsKey(value)) {
                                  todos_los_controladores[value!] = {
                                    for (var campo in proyectoActual!['campos'])
                                      campo['label']: TextEditingController(),
                                  };
                                }

                                // Asignamos los controladores actuales según el proyecto
                                camposControllers = todos_los_controladores[value]!;
                              });
                            },

                          ),
                          const SizedBox(height: 20),

                          // Mostrar contenido del proyecto seleccionado
                          if (proyectoActual != null) ...[
                            Image.asset(
                              proyectoActual!['imagen'],
                              fit: BoxFit.cover,
                              height: 150,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              proyectoActual!['descripcion'],
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            _formularioProyecto(proyectoActual!),
                          ],
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Cerrar"),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
          child: Card(
            elevation: 5,
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.construction, size: 70, color: Colors.blueGrey),
                SizedBox(height: 10),
                Text(
                  "Solicitar Proyecto",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Selecciona un tipo de proyecto para llenar su formulario correspondiente.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> tarjetas = [
      {"titulo": "Polipastos", "imagen": "assets/Polipastos_Anim.jpeg"},
      {"titulo": "Accesorios", "imagen": "assets/ACCESORIOS.png"},
      {"titulo": "Patines Hidráulicos y más...", "imagen": "assets/P_Patines.jpeg"},
      {"titulo": "Capacitaciones", "imagen": "assets/CAP_PRINCI.png"},
      {"titulo": "Servicios", "imagen": "assets/P_SERVICIOS.png"},
      {"titulo": "Proyectos", "imagen": "assets/PROYECTOS.png"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CHM Móvil',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF192557),
        actions: [
          IconButton(
            icon: const Icon(Icons.note_add_outlined, color: Colors.white),
            onPressed: () {
              final contactoController = TextEditingController();
              final fechaController = TextEditingController();
              final puestoController = TextEditingController();
              final List<String> calificacionController = [
                'Excelente',
                'Buena',
                'Regular',
                'Mala',
                'Muy Mala',
              ];
              final List<String> conformidadController = ['SI', 'NO'];
              final notasController = TextEditingController();

              String? calificacionSeleccionada;
              String? conformidadSeleccionada;

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        scrollable: true,
                        title: Text(
                          "Encuesta de Satisfacción",
                          style: const TextStyle(fontSize: 20),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(widget.nombreCompleto),
                            Text(widget.correo),
                            Text(widget.empresa),

                            const SizedBox(height: 12),

                            TextField(
                              controller: contactoController,
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              decoration: const InputDecoration(
                                labelText: 'Contacto',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: fechaController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                labelText: 'Fecha',
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.calendar_today_outlined),
                              ),
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                  locale: const Locale('es', 'MX'),
                                );
                                if (pickedDate != null) {
                                  String formattedDate =
                                      "${pickedDate.day.toString().padLeft(2, '0')}/"
                                      "${pickedDate.month.toString().padLeft(2, '0')}/"
                                      "${pickedDate.year}";
                                  fechaController.text = formattedDate;
                                }
                              },
                            ),
                            const SizedBox(height: 12),

                            TextField(
                              controller: puestoController,
                              decoration: const InputDecoration(
                                labelText: 'Puesto',
                                border: OutlineInputBorder(),
                              ),
                            ),

                            const SizedBox(height: 12),

                            DropdownButtonFormField<String>(
                              value: calificacionSeleccionada,
                              decoration: const InputDecoration(
                                labelText: 'Calificación',
                                border: OutlineInputBorder(),
                              ),
                              items: calificacionController.map((tipo) {
                                return DropdownMenuItem(
                                  value: tipo,
                                  child: Text(tipo),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  calificacionSeleccionada = value;
                                });
                              },
                            ),

                            const SizedBox(height: 12),

                            DropdownButtonFormField<String>(
                              value: conformidadSeleccionada,
                              decoration: const InputDecoration(
                                labelText: 'Conformidad',
                                border: OutlineInputBorder(),
                              ),
                              items: conformidadController.map((tipo) {
                                return DropdownMenuItem(
                                  value: tipo,
                                  child: Text(tipo),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  conformidadSeleccionada = value;
                                });
                              },
                            ),

                            const SizedBox(height: 12),

                            TextField(
                              controller: notasController,
                              maxLines: 4,
                              maxLength: 500,
                              decoration: const InputDecoration(
                                labelText: "Notas / Comentarios",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("Cancelar"),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final contac = contactoController.text.trim();
                              final fech = fechaController.text.trim();
                              final puest = puestoController.text.trim();
                              final califi =
                                  calificacionSeleccionada?.trim() ?? '';
                              final confor =
                                  conformidadSeleccionada?.trim() ?? '';
                              final nots = notasController.text.trim();

                              if (contac.isEmpty ||
                                  fech.isEmpty ||
                                  puest.isEmpty ||
                                  califi.isEmpty ||
                                  confor.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Por favor llena todos los campos',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                              if (contac.length < 10) {
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
                                        "Porque tu opinion es importante...",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  duration: Duration(seconds: 5),
                                  backgroundColor: Colors.blue,
                                ),
                              );

                              try {
                                // Enviar al backend
                                await enviarEncuestaSatisfaccion(
                                  toEmail: widget.correo,
                                  nombreCompleto: widget.nombreCompleto,
                                  empresa: widget.empresa,
                                  contacto: contac,
                                  fecha: fech,
                                  puesto: puest,
                                  calificacion: califi,
                                  conformidad: confor,
                                  notas: nots,
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(
                                  context,
                                ).hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Error al enviar la solicitud: $e",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 4),
                                  ),
                                );
                              }
                            },
                            child: const Text("Enviar Solicitud"),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_rounded, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Información de la Cuenta"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.nombreCompleto),
                      Text(widget.correo),
                      Text(widget.empresa), // Muestra la empresa
                    ],
                  ),
                  actions: [
                    TextButton(
                      child: const Text("Cerrar"),
                      onPressed: () => Navigator.of(context).pop(),
                      //cierra el modal
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              // NO pongas Navigator.pop aquí
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirmar'),
                    content: const Text(
                      '¿Estás seguro de que deseas cerrar sesión?',
                    ),
                    actions: [
                      TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () => Navigator.of(
                          context,
                        ).pop(), // Cierra solo el diálogo
                      ),
                      TextButton(
                        child: const Text('Cerrar sesión'),
                        onPressed: () {
                          Navigator.of(context).pop(); // Cierra el diálogo
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const MyHomePage(), // Regresa al login
                            ),
                            (route) =>
                                false, // Elimina todas las rutas anteriores
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
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/FondoBlanco.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (mostrarPolipastos)
            Positioned.fill(child: _vistaPolipastos())
          else if (mostrarServicios)
            Positioned.fill(child: _vistaServicios())
          else if (mostrarAccesorios)
            Positioned.fill(child: _vistaAccesorios())
          else if (mostrarPatines)
            Positioned.fill(child: _vistaPatines())
          else if (mostrarCapacitaciones)
            Positioned.fill(child: _vistaCapacitaciones())
          else if (mostrarProyectos)
            Positioned.fill(child: _vistaProyectos())
          else
            GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              childAspectRatio: 0.8,
              children: tarjetas.map((tarjeta) {
                return GestureDetector(
                  onTap: () {
                    if (tarjeta["titulo"] == "Polipastos") {
                      setState(() {
                        mostrarPatines = false;
                        mostrarServicios = false;
                        mostrarAccesorios = false;
                        mostrarCapacitaciones = false;
                        mostrarProyectos = false;
                        mostrarPolipastos = true;
                      });
                    } else if (tarjeta["titulo"] == "Servicios") {
                      setState(() {
                        mostrarPatines = false;
                        mostrarPolipastos = false;
                        mostrarAccesorios = false;
                        mostrarCapacitaciones = false;
                        mostrarProyectos = false;
                        mostrarServicios = true;
                      });
                    } else if (tarjeta["titulo"] == "Accesorios") {
                      setState(() {
                        mostrarPatines = false;
                        mostrarPolipastos = false;
                        mostrarServicios = false;
                        mostrarCapacitaciones = false;
                        mostrarProyectos = false;
                        mostrarAccesorios = true;
                      });
                    } else if (tarjeta["titulo"] == "Patines Hidráulicos y más...") {
                      setState(() {
                        mostrarAccesorios = false;
                        mostrarServicios = false;
                        mostrarPolipastos = false;
                        mostrarCapacitaciones = false;
                        mostrarProyectos = false;
                        mostrarPatines = true;
                      });
                    } else if (tarjeta["titulo"] == "Capacitaciones") {
                      setState(() {
                        mostrarAccesorios = false;
                        mostrarServicios = false;
                        mostrarPolipastos = false;
                        mostrarPatines = false;
                        mostrarProyectos = false;
                        mostrarCapacitaciones = true;
                      });
                    } else if (tarjeta["titulo"] == "Proyectos") {
                      setState(() {
                        mostrarAccesorios = false;
                        mostrarServicios = false;
                        mostrarPolipastos = false;
                        mostrarPatines = false;
                        mostrarCapacitaciones = false;
                        mostrarProyectos = true;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Funcionalidad no implementada para ${tarjeta["titulo"]}",
                          ),
                        ),
                      );
                    }
                  },
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Image.asset(
                              tarjeta["imagen"]!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            tarjeta["titulo"]!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Volver al inicio',
        backgroundColor: const Color(0xFF192557),
        onPressed: () {
          setState(() {
            mostrarPolipastos = false;
            mostrarServicios = false;
            mostrarAccesorios = false;
            mostrarPatines = false;
            mostrarCapacitaciones = false;
            mostrarProyectos = false;
          });
        },
        child: const Icon(Icons.home, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
