import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class FormularioEquipo extends StatefulWidget {
  const FormularioEquipo({super.key});

  @override
  State<FormularioEquipo> createState() => _FormularioEquipoState();
}

class _FormularioEquipoState extends State<FormularioEquipo> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _categoriaController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  File? _imagen;

  Future<void> _seleccionarImagen() async {
    // Pedir permiso para fotos (Android 13+) o almacenamiento (Android <= 12)
    if (await Permission.photos.request().isGranted || await Permission.storage.request().isGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imagen = File(pickedFile.path);
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permiso para acceder a fotos denegado')),
      );
    }
  }

  Future<void> _subirProducto() async {
    if (!_formKey.currentState!.validate() || _imagen == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos e imagen')),
      );
      return;
    }

    var uri = Uri.parse("http://10.7.234.137:5035/api/productos/subir-producto");
    
    var request = http.MultipartRequest('POST', uri)
      ..fields['nombre'] = _nombreController.text
      ..fields['categoria'] = _categoriaController.text
      ..fields['descripcion'] = _descripcionController.text
      ..files.add(await http.MultipartFile.fromPath('imagen', _imagen!.path));

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto subido correctamente')),
      );
      _nombreController.clear();
      _categoriaController.clear();
      _descripcionController.clear();
      setState(() => _imagen = null);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al subir producto: $responseBody')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const SizedBox(height: 30),
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: "Nombre del equipo"),
              validator: (value) => value!.isEmpty ? "Campo obligatorio" : null,
            ),
            TextFormField(
              controller: _categoriaController,
              decoration: const InputDecoration(labelText: "Categoría"),
              validator: (value) => value!.isEmpty ? "Campo obligatorio" : null,
            ),
            TextFormField(
              controller: _descripcionController,
              decoration: const InputDecoration(labelText: "Descripción"),
              maxLines: 3,
              validator: (value) => value!.isEmpty ? "Campo obligatorio" : null,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _seleccionarImagen,
              icon: const Icon(Icons.image),
              label: const Text("Seleccionar imagen"),
            ),
            if (_imagen != null) ...[
              const SizedBox(height: 10),
              Image.file(_imagen!, height: 200),
            ],
            const SizedBox(height: 20),
            ElevatedButton(              
              onPressed:(){
                _subirProducto();
              },
              child: const Text("Guardar producto"),
            ),
          ],
        ),
      ),
    );
  }
}