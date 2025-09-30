import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'main.dart';
import 'FormularioEquipo.dart';

class Admin extends StatelessWidget {
  final String nombreCompleto;
  final String correo;

  const Admin({super.key, required this.nombreCompleto, required this.correo});

  @override
  Widget build(BuildContext context) {
    return CuerpoAdmin(nombreCompleto: nombreCompleto, correo: correo);
  }
}

class CuerpoAdmin extends StatefulWidget {
  final String nombreCompleto;
  final String correo;

  const CuerpoAdmin({
    super.key,
    required this.nombreCompleto,
    required this.correo,
  });

  @override
  State<CuerpoAdmin> createState() => _CuerpoAdminState();
}

class _CuerpoAdminState extends State<CuerpoAdmin> {
  int _paginaActual = 0;

  Future<List<Map<String, dynamic>>> _cargarProductos() async {
    final response = await http.get(
      Uri.parse("http://10.7.234.137:5035/api/productos/obtener-productos"),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      return data.map((producto) {
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

  Widget _vistaProductos() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _cargarProductos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No hay productos disponibles"));
        }

        final productos = snapshot.data!;
        return GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(10),
          childAspectRatio: 0.70,
          children: productos.map((producto) {
            print(producto); // Para verificar qué se está recibiendo

            final id = producto['id']?.toString() ?? '';
            final nombre = producto['nombre']?.toString() ?? '';
            final categoria = producto['categoria']?.toString() ?? '';
            final descripcion = producto['descripcion']?.toString() ?? '';

            final imagenUrl = "http://10.7.234.137:5035/api/productos/imagen/$id";

            return Card(
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
                        errorBuilder: (context, error, stackTrace) => const Center(
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
                        Text(nombre,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Text("Categoría: $categoria",
                            style: const TextStyle(fontSize: 14)),
                        Text("Descripción: $descripcion",
                            style:
                                const TextStyle(fontSize: 13, color: Colors.grey),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget contenido;

    switch (_paginaActual) {
      case 1:
        contenido = const FormularioEquipo();
        break;
      case 0:
      default:
        contenido = _vistaProductos();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Panel de Administración',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF192557),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF192557)),
              accountName: Text(widget.nombreCompleto),
              accountEmail: Text(widget.correo),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage("assets/logoCHM.png"),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _paginaActual = 0;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Equipos'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _paginaActual = 1;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () {
                Navigator.pop(context);
                // Espacio reservado para futuras configuraciones
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirmar'),
                      content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
                      actions: [
                        TextButton(
                          child: const Text('Cancelar'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        TextButton(
                          child: const Text('Cerrar sesión'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const MyHomePage()),
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
      ),
      body: Stack(
        children: [
          // Fondo de pantalla
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/FondoBlanco.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenido encima del fondo
          contenido,
        ],
      ),
    );
  }
}