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
  bool mostrarPolipastos = false;//
  bool mostrarServicios = false;//
  bool mostrarAccesorios = false;//
  bool mostrarPatines = false;
  bool mostrarCapacitaciones = false;
  bool mostrarProyectos = false;

  // METODOS PARA ENVIAR CORREOS ELECTRONICOS
  Future<void> enviarCorreoSolicitud({
    required String toEmail,
    required String nombreCompleto,
    required String empresa,
    required String nombreServicio,
    required String dia,
    required String hora,
    Map<String, dynamic>? extras,
  }) async {
    final url = Uri.parse(
      'http://10.7.234.136:5035/api/email/solicitud-servicios',
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
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      throw Exception('Error al enviar el correo: ${response.body}');
    }
  }

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
      'http://10.7.234.136:5035/api/email/encuesta-satisfaccion', // endpoint dedicado
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
      print("✅ Encuesta enviada correctamente");
    } else {
      print("❌ Error al enviar la encuesta: ${response.body}");
      throw Exception("Error al enviar encuesta: ${response.body}");
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
      'http://10.7.234.136:5035/api/email/solicitud-polipastos',
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
      print('Correo enviado correctamente con los datos: $body');
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
      'http://10.7.234.136:5035/api/email/solicitud-accesorios',
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
      print('Correo enviado correctamente con los datos: $body');
    } else {
      throw Exception('Error al enviar el correo: ${respuesta.body}');
    }
  }

  Future<void> enviarCorreoPatinHidraulico({
    required String toEmail,
    required String nombreCompleto,
    required String empresa,
    required String marcaH,
    required String capacidadH,
  }) async {
    final url = Uri.parse(
      'http://10.7.234.136:5035/api/email/solicitud-patines',
    );
    final respuesta = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'toEmail': toEmail,
        'nombreCompleto': nombreCompleto,
        'empresa': empresa,
        'marcaH': marcaH,
        'capacidadH': capacidadH,
      }),
    );
    if (respuesta.statusCode == 200) {
      print('Correo enviado correctamente');
    } else {
      throw Exception('Error al enviar el correo: ${respuesta.body}');
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
          'opciones': [
            '250 kg',
            '500 kg',
            '1000 kg',
            '2000 kg',
            '3000 kg',
          ],
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
          'opciones': [
            '1000 kg',
            '2000 kg',
            '3000 kg',
            '5000 kg',
            '10000 kg',
          ],
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
          'opciones': [
            '750 kg',
            '1500 kg',
            '3000 kg',
            '6000 kg',
          ],
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

                // Enviar correo con los datos
                try {
                  await enviarCorreoPolipastos(
                    toEmail: widget.correo,
                    nombreCompleto: widget.nombreCompleto,
                    empresa: widget.empresa,
                    nombrePolipasto: polipast['nombre'],
                    datosFormulario: datosFormulario,
                  );

                  // Usar el contexto del widget padre (evitar contextos cerrados)
                  //if (!mounted) return;
                  ScaffoldMessenger.of(scaffoldContext).hideCurrentSnackBar();
                  ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                    const SnackBar(
                      content: Text("Solicitud enviada correctamente"),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
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
      'descripcion': 'Revisión y mantenimiento programado para evitar fallas.',
      'imagen': 'assets/Serv_MantePrev.jpeg',
    },
    {
      'id': '2',
      'nombre': 'Mantenimiento Correctivo',
      'categoria': 'Servicios',
      'descripcion': 'Reparación de fallas y reemplazo de piezas defectuosas.',
      'imagen': 'assets/Serv_Rep_E.jpeg',
    },
    {
      'id': '3',
      'nombre': 'Instalación',
      'categoria': 'Servicios',
      'descripcion': 'Instalación de equipos y sistemas de carga.',
      'imagen': 'assets/Serv_Instalacion.jpeg',
    },
    {
      'id': '4',
      'nombre': 'Inspección',
      'categoria': 'Servicios',
      'descripcion': 'Inspección técnica para garantizar la seguridad.',
      'imagen': 'assets/Serv_Inspeccion.jpeg',
    },
  ];

  Widget _vistaServicios() {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 80),
      childAspectRatio: 0.70,
      children: _cargarServicios.map((producto) {
        //final id = producto['id']!;
        final nombre = producto['nombre']!;
        final categoria = producto['categoria']!;
        final descripcion = producto['descripcion']!;
        final imagen = producto['imagen']!; // desde tus assets locales

        return GestureDetector(
          onTap: () {
            final diaController = TextEditingController();
            final horaController = TextEditingController();

            // ⚡ Detectar campos extra según el nombre del servicio
            final Map<String, TextEditingController> extraControllers = {};
            List<String> extrasRequeridos = [];

            if (nombre.toLowerCase().contains("mantenimiento")) {
              extrasRequeridos = ["Equipo", "Número de Serie"];
            } else if (nombre.toLowerCase().contains("reparación")) {
              extrasRequeridos = ["Descripción de la falla"];
            } else if (nombre.toLowerCase().contains("instalación")) {
              extrasRequeridos = ["Ubicación", "Modelo"];
            } else if (nombre.toLowerCase().contains("inspección")) {
              extrasRequeridos = ["Inspector asignado", "Área"];
            }

            for (var campo in extrasRequeridos) {
              extraControllers[campo] = TextEditingController();
            }

            // Mostrar el diálogo
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      scrollable: true,
                      title: Text(
                        "Solicitud de: $nombre \n $descripcion",
                        style: const TextStyle(fontSize: 20),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Fecha
                          TextField(
                            controller: diaController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Fecha del servicio',
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
                                String formattedDate =
                                    "${pickedDate.day.toString().padLeft(2, '0')}/"
                                    "${pickedDate.month.toString().padLeft(2, '0')}/"
                                    "${pickedDate.year}";
                                diaController.text = formattedDate;
                              }
                            },
                          ),
                          const SizedBox(height: 12),

                          // Hora
                          TextField(
                            controller: horaController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Hora del servicio',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.access_alarm_rounded),
                            ),
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                //initialEntryMode: TimePickerEntryMode.dial,
                                //helpText: 'Seleccione la hora de servicio',
                              );
                              if (pickedTime != null) {
                                final now = DateTime.now();
                                final formattedTime = DateFormat.jm().format(
                                  DateTime(
                                    now.year,
                                    now.month,
                                    now.day,
                                    pickedTime.hour,
                                    pickedTime.minute,
                                  ),
                                );
                                horaController.text = formattedTime;
                              }
                            },
                          ),
                          const SizedBox(height: 12),

                          // Campos adicionales dinámicos
                          ...extraControllers.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: TextField(
                                controller: entry.value,
                                decoration: InputDecoration(
                                  labelText: entry.key,
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
                            final dia = diaController.text.trim();
                            final hora = horaController.text.trim();

                            if (dia.isEmpty || hora.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Por favor completa fecha y hora del servicio",
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            // Capturar extras
                            final extras = <String, String>{};
                            extraControllers.forEach((campo, controller) {
                              if (controller.text.isNotEmpty) {
                                extras[campo] = controller.text.trim();
                              }
                            });

                            Navigator.of(context).pop();

                            // Mostrar indicador
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

                            // Enviar al backend
                            await enviarCorreoSolicitud(
                              toEmail: widget.correo,
                              nombreCompleto: widget.nombreCompleto,
                              empresa: widget.empresa,
                              nombreServicio: nombre,
                              dia: dia,
                              hora: hora,
                              extras: extras, // Campos dinámicos
                            );

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
      'nombre': 'Cable de Acero',
      'categoria': 'Accesorios',
      'descripcion': 'Cable de acero de carga.',
      'imagen': 'assets/cableAcero.jpeg',
      'campos': [
        {'label': 'Metros', 'tipo': 'numero'},
        {'label': 'Capacidad de carga', 'tipo': 'numero'},
        {'label': 'Grosor', 'tipo': 'texto'},
        {'label': 'Tipo de Estructura', 'tipo': 'texto'},
      ],
    },
    {
      'id': '3',
      'nombre': 'Gancho de Carga para polipasto',
      'categoria': 'Accesorios',
      'descripcion': 'Gancho de seguridad para polipastos y grúas.',
      'imagen': 'assets/GanchoSeguridad.jpeg',
      'campos': [
        {'label': 'Tipo de polipasto', 'tipo': 'selector', 'opciones': ['De Cable', 'De Cadena']},
        {'label': 'Marca', 'tipo': 'texto'},
        {'label': 'Número de Serie', 'tipo': 'texto'},
        {'label': 'Capacidad', 'tipo': 'numero'}
      ],
    },
    {
      'id': '4',
      'nombre': 'Grillete de Carga',
      'categoria': 'Accesorios',
      'descripcion': 'Grillete de acero para conexión de elementos de carga.',
      'imagen': 'assets/GRILLETE_DE_CARGA.webp',
      'campos': [
        {'label': 'Capacidad', 'tipo': 'numero'},
        {'label': 'Tamaño', 'tipo': 'selector', 'opciones': ['1/2"', '5/8"', '3/4"', '1"']},
      ],
    },
    {
      'id': '5',
      'nombre': 'Estrobo de Carga',
      'categoria': 'Accesorios',
      'descripcion': 'Estrobo para levantamiento de cargas pesadas.',
      'imagen': 'assets/ESTROBO_DE_CARGA.jpg',
      'campos': [
        {'label': 'Tipo', 'tipo': 'selector', 'opciones': ['Cable de acero', 'Cadena', 'Poliester']},
        {'label': 'Longitud', 'tipo': 'numero'},
        {'label': 'Número de ramales', 'tipo': 'selector', 'opciones': ['1', '2', '3', '4']},
        {'label': 'Capacidad de carga', 'tipo': 'numero'},
        {'label': 'Acessorios', 'tipo': 'texto',},
      ],
    },
    {
      'id': '6',
      'nombre': 'Polea de carga',
      'categoria': 'Accesorios',
      'descripcion': 'Polea de carga para redireccionamiento.',
      'imagen': 'assets/POLEA.webp',
      'campos': [
        {'label': 'Capacidad de carga', 'tipo': 'numero'},
        {'label': 'Marca', 'tipo': 'texto'},
        {'label': 'Modelo', 'tipo': 'texto'},
      ],
    },
    {
      'id': '7',
      'nombre': 'Tirfor',
      'categoria': 'Accesorios',
      'descripcion': 'Tirfor para tracción manual de cargas.',
      'imagen': 'assets/TIRFOR.webp',
      'campos': [
        {'label': 'Tipo', 'tipo': 'selector', 'opciones': ['Acero', 'Aluminio']},
        {'label': 'Modelo', 'tipo': 'texto'},
        {'label': 'Capacidad de carga', 'tipo': 'numero'},
        {'label': 'Cable incluido', 'tipo': 'selector', 'opciones': ['Sí', 'No']},
        {'label': 'Longitud', 'tipo': 'numero'},
        {'label': 'Accesorios de cable', 'tipo': 'texto'},
      ],
    },
    {
      'id': '8',
      'nombre': 'Mosquetón de Seguridad',
      'categoria': 'Accesorios',
      'descripcion': 'Mosquetón con cierre de seguridad.',
      'imagen': 'assets/MOSQUETON.jpg',
      'campos': [
        {'label': 'Capacidad de carga', 'tipo': 'numero'},
        {'label': 'Modelo', 'tipo': 'texto'},
        {'label': 'Marca', 'tipo': 'texto'},
        {'label': 'Dimensiones', 'tipo': 'texto'},
      ],
    },
    {
      'id': '9',
      'nombre': 'Cadena para estrobo',
      'categoria': 'Accesorios',
      'descripcion': 'Cadena resistente para elevación de objetos pesados.',
      'imagen': 'assets/CADENAS_DE_ELEVACION.avif',
      'campos': [
        {'label': 'Capacidad de carga', 'tipo': 'selector', 'opciones': ['Grado 80', 'Grado 100']},
        {'label': 'Longitud (m)', 'tipo': 'numero'},
        {'label': 'Medida de la cadena', 'tipo': 'numero'},
      ],
    },
    {
      'id': '10',
      'nombre': 'Cadena para polipasto',
      'categoria': 'Accesorios',
      'descripcion': 'Cadena resistente para elevación de objetos pesados.',
      'imagen': 'assets/CADENAS_DE_ELEVACION.avif',
      'campos': [
        {'label': 'Marca', 'tipo': 'numero'},
        {'label': 'Modelo', 'tipo': 'texto'},
        {'label': 'No. de serie', 'tipo': 'numero'},
        {'label': 'Capacidad de carga', 'tipo': 'numero'},
        {'label': 'Longitud (m)', 'tipo': 'numero'},
      ],
    },
    {
      'id': '11',
      'nombre': 'Eslinga de poliester',
      'categoria': 'Accesorios',
      'descripcion': 'Eslinga plana textil para manipulación de cargas.',
      'imagen': 'assets/ESLINGA_DE_POLIESTER.jpg',
      'campos': [
        {'label': 'Longitud (m)', 'tipo': 'numero'},
        {'label': 'Grosor', 'tipo': 'numero'},
        {'label': 'Posicion de Carga', 'tipo': 'texto'},
        {'label': 'Capacidad de carga', 'tipo': 'numero'},
        {'label': 'Notas', 'tipo': 'texto'},
      ],
    },
    {
      'id': '12',
      'nombre': 'Tensor',
      'categoria': 'Accesorios',
      'descripcion': 'Tensor para ajuste de cables o estrobos.',
      'imagen': 'assets/TENSOR.webp',
      'campos': [
        {'label': 'Tipo', 'tipo': 'selector', 'opciones': ['Gancho-Gancho', 'Ojo-Ojo', 'Gancho-Ojo']},
        {'label': 'Capacidad', 'tipo': 'numero'},
        {'label': 'Longitud', 'tipo': 'numero'},
      ],
    },
    {
      'id': '12',
      'nombre': 'Trole',
      'categoria': 'Accesorios',
      'descripcion': 'Trole y trole para vigas curvas',
      'imagen': 'assets/TROLE.webp',
      'campos': [
        {'label': 'Tipo', 'tipo': 'selector', 'opciones': ['Manual', 'Neumático', 'Eléctrico']},
        {'label': 'Capacidad de carga', 'tipo': 'numero'},
        {'label': 'Dimensiones de la viga', 'tipo': 'texto'},
        {'label': 'Nota', 'tipo': 'texto'},
      ],
    },
    {
      'id': '13',
      'nombre': 'Polea con Gancho',
      'categoria': 'Accesorios',
      'descripcion': 'Polea giratoria con gancho de seguridad.',
      'imagen': 'assets/POLEA_CON_GANCHO.jpg',
      'campos': [
        {'label': 'Capacidad de carga', 'tipo': 'numero'},
      ],
    },
    {
      'id': '14',
      'nombre': 'Topes de Seguridad',
      'categoria': 'Accesorios',
      'descripcion': 'Topes para limitar el recorrido en rieles de polipasto',
      'imagen': 'assets/GUIAS_DE_CABLE.webp',
      'campos': [
        {'label': 'Tipo', 'tipo': 'selector', 'opciones': ['Acero', 'Goma', 'Eléctrico']},
        {'label': 'Lugar de montaje', 'tipo': 'selector', 'opciones': ['Cabezal', 'Rieles de la grua']}, 
      ],
    },
    {
      'id': '15',
      'nombre': 'Limitador de carga para elevadores',
      'categoria': 'Accesorios',
      'descripcion': 'Dispositivo de seguridad para evitar sobrecarga.',
      'imagen': 'assets/LIMITADOR.png',
      'campos': [
        {'label': 'Marca', 'tipo': 'texto'},
        {'label': 'Modelo', 'tipo': 'texto'},
        {'label': 'Capacidad máxima', 'tipo': 'numero'},
        {'label': 'Instalacion', 'tipo': 'selector', 'opciones': ['Con instalación', 'Sin instalación']},
        {'label': 'Voltaje de conexión', 'tipo': 'selector', 'opciones': ['24 V','48 V','110 V','220 V','440 V']},
      ],
    },
    {
      'id': '16',
      'nombre': 'Cable para polipasto electrico',
      'categoria': 'Accesorios',
      'descripcion': 'Cables para alimentación de polipastos.',
      'imagen': 'assets/CABLE_ALIMENTACION.webp',
      'campos': [
        {'label': 'Tipo', 'tipo': 'selector', 'opciones': ['Plano', 'Redondo']},
        {'label': 'Calibre', 'tipo': 'texto'},
        {'label': 'Numero de hilos', 'tipo': 'numero'},
        {'label': 'Metros', 'tipo': 'numero'},
        {'label': 'Notas', 'tipo': 'texto'},
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
                  ScaffoldMessenger.of(scaffoldContext).hideCurrentSnackBar();
                  ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                    const SnackBar(
                      content: Text("Solicitud enviada correctamente"),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
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
  Future<List<Map<String, dynamic>>> _cargarPatines() async {
    final response = await http.get(
      Uri.parse("http://10.7.234.136:5035/api/productos/obtener-productos"),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final polipastos = data.where((producto) {
        final nombre = producto['nombre']?.toString().toLowerCase() ?? '';
        return nombre.contains("patin") || nombre.contains("patines");
      }).toList();

      return polipastos.map((producto) {
        return {
          'id': producto['id']?.toString() ?? '',
          'nombre': producto['nombre']?.toString() ?? '',
          'categoria': producto['categoria']?.toString() ?? '',
          'descripcion': producto['descripcion']?.toString() ?? '',
        };
      }).toList();
    } else {
      throw Exception("Error al cargar productos");
    }
  }

  Widget _vistaPatines() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _cargarPatines(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No hay Patines disponibles"));
        }

        final productos = snapshot.data!;
        return GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 80),
          childAspectRatio: 0.70,
          children: productos.map((producto) {
            final id = producto['id']!;
            final nombre = producto['nombre']!;
            final categoria = producto['categoria']!;
            final descripcion = producto['descripcion']!;
            final imagenUrl =
                "http://10.7.234.136:5035/api/productos/imagen/$id";

            return GestureDetector(
              onTap: () {
                final capacidadController = TextEditingController();
                final marcaController = TextEditingController();
                // Mostrar el diálogo
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          scrollable: true,
                          title: Text(
                            "Solicitud para: $nombre \n $categoria",
                            style: const TextStyle(fontSize: 20),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: capacidadController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Capacidad deseada (kg)',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: marcaController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Alguna Marca',
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
                                final capacidadH = capacidadController.text
                                    .trim();
                                final marcaH = marcaController.text.trim();

                                if (capacidadH.isEmpty || marcaH.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Por favor completa todos los campos',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                } else {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Solicitud enviada:\n$nombre\nDía: $capacidadH\nHora: $marcaH",
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  // Aquí puedes enviar los datos al backend
                                  await enviarCorreoPatinHidraulico(
                                    toEmail: widget.correo,
                                    nombreCompleto: widget.nombreCompleto,
                                    empresa: widget.empresa,
                                    capacidadH: capacidadH,
                                    marcaH: marcaH,
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
                        child: Image.network(
                          imagenUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                              ),
                        ),
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> tarjetas = [
      {"titulo": "Polipastos", "imagen": "assets/Polipastos_Anim.jpeg"},
      {"titulo": "Accesorios", "imagen": "assets/Accesorios_Anim.png"},
      {"titulo": "Patines Hidráulicos", "imagen": "assets/P_Patines.jpeg"},
      {"titulo": "Capacitaciones", "imagen": "assets/M_C_Portada.png"},
      {"titulo": "Servicios", "imagen": "assets/Monito_Servicios.png"},
      {"titulo": "Proyectos", "imagen": "assets/P_Proyectos.jpeg"},
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
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9/]'),
                                ),
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
                              } else {
                                Navigator.of(context).pop();

                                // Mostrar indicador
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
                                        ),
                                      ],
                                    ),
                                    duration: Duration(seconds: 3),
                                    backgroundColor: Colors.blue,
                                  ),
                                );
                                
                                //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
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
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Gracias por confiar en nosotros",
                                    ),
                                    backgroundColor: Colors.green,
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
                        mostrarPolipastos = true;
                      });
                    } else if (tarjeta["titulo"] == "Servicios") {
                      setState(() {
                        mostrarPatines = false;
                        mostrarPolipastos = false;
                        mostrarAccesorios = false;
                        mostrarServicios = true;
                      });
                    } else if (tarjeta["titulo"] == "Accesorios") {
                      setState(() {
                        mostrarPatines = false;
                        mostrarPolipastos = false;
                        mostrarServicios = false;
                        mostrarAccesorios = true;
                      });
                    } else if (tarjeta["titulo"] == "Patines Hidráulicos") {
                      setState(() {
                        mostrarAccesorios = false;
                        mostrarServicios = false;
                        mostrarPolipastos = false;
                        mostrarPatines = true;
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
          });
        },
        child: const Icon(Icons.home, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
