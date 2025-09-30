import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'main.dart'; 

class Cliente extends StatelessWidget {
  final String nombreCompleto;
  final String correo;

  const Cliente({
    super.key,
    required this.nombreCompleto,
    required this.correo,
  });

  @override
  Widget build(BuildContext context) {
    return CuerpoCliente(nombreCompleto: nombreCompleto, correo: correo);
  }
}

class CuerpoCliente extends StatefulWidget {
  final String nombreCompleto;
  final String correo;

  const CuerpoCliente({
    super.key,
    required this.nombreCompleto,
    required this.correo,
  });

  @override
  State<CuerpoCliente> createState() => _CuerpoClienteState();
}

class _CuerpoClienteState extends State<CuerpoCliente> {
  // Variable para controlar la visibilidad de los productos y/o servicios
  bool mostrarPolipastos = false;
  bool mostrarServicios = false;

  Future<List<Map<String, dynamic>>> _cargarPolipastos() async {
    final response = await http.get(
      Uri.parse("http://10.7.234.136:5035/api/productos/obtener-productos"),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      // Filtra solo los productos con nombre que contenga "polipasto" o "polipastos"
      final polipastos =
          data.where((producto) {
            final nombre = producto['nombre']?.toString().toLowerCase() ?? '';
            return nombre.contains("polipasto") ||
                nombre.contains("polipastos");
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

  Future<List<Map<String, dynamic>>> _cargarServicios() async {
    final response = await http.get(
      Uri.parse("http://10.7.234.136:5035/api/productos/obtener-productos"),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      // Filtra solo los productos con nombre que contenga "polipasto" o "polipastos"
      final servicios =
          data.where((producto) {
            final nombre = producto['nombre']?.toString().toLowerCase() ?? '';
            return nombre.contains("servicio") || nombre.contains("servicios");
          }).toList();

      return servicios.map((producto) {
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

  Widget _vistaPolipastos() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _cargarPolipastos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No hay Polipastos disponibles"));
        }

        final productos = snapshot.data!;
        return GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(10),
          childAspectRatio: 0.70,
          children:
              productos.map((producto) {
                final id = producto['id'] ?? '';
                final nombre = producto['nombre'] ?? '';
                final categoria = producto['categoria'] ?? '';
                final descripcion = producto['descripcion'] ?? '';

                final imagenUrl =
                    "http://10.7.234.136:5035/api/productos/imagen/$id";

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
                            errorBuilder:
                                (context, error, stackTrace) => const Center(
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
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
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

  Widget _vistaServicios() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _cargarServicios(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No hay Servicios disponibles"));
        }

        final productos = snapshot.data!;
        return GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(10),
          childAspectRatio: 0.70,
          children:
              productos.map((producto) {
                final id = producto['id'] ?? '';
                final nombre = producto['nombre'] ?? '';
                final categoria = producto['categoria'] ?? '';
                final descripcion = producto['descripcion'] ?? '';

                final imagenUrl =
                    "http://10.7.234.136:5035/api/productos/imagen/$id";

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
                            errorBuilder:
                                (context, error, stackTrace) => const Center(
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
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bienvenido a CHM Movil',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
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
                  mostrarPolipastos = false;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.precision_manufacturing),
              title: const Text('Polipastos'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  mostrarServicios = false;
                  mostrarPolipastos = true;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.app_settings_alt_sharp),
              title: const Text("Servicios"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  mostrarPolipastos = false;
                  mostrarServicios = true;
                });
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
                      content: const Text(
                        '¿Estás seguro de que deseas cerrar sesión?',
                      ),
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
          if (mostrarPolipastos) Positioned.fill(child: _vistaPolipastos()),
          if (mostrarServicios) Positioned.fill(child: _vistaServicios()),
        ],
      ),
    );
  }
}