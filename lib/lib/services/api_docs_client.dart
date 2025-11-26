import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/documento.dart';
import '../models/area.dart';

class ApiDocsClient {
  static const String _base = 'https://apichm-gjabejbmdza5gefe.mexicocentral-01.azurewebsites.net';
  static Uri _u(String p) => Uri.parse('$_base$p');

  static Future<List<Area>> listarAreas() async {
    final r = await http.get(_u('/api/admin/documentos/areas'));
    if (r.statusCode != 200) throw Exception('Error ${r.statusCode}: ${r.body}');
    final data = jsonDecode(r.body) as List;
    return data.map((e) => Area.fromJson(e)).toList();
  }

  static Future<List<Documento>> listarDocumentos() async {
    final r = await http.get(_u('/api/admin/documentos'));
    if (r.statusCode != 200) throw Exception('Error ${r.statusCode}: ${r.body}');
    final data = jsonDecode(r.body) as List;
    return data.map((e) => Documento.fromJson(e)).toList();
  }

  static Future<Documento> obtenerDocumento(int id) async {
    final r = await http.get(_u('/api/admin/documentos/$id'));
    if (r.statusCode != 200) throw Exception('No encontrado');
    return Documento.fromJson(jsonDecode(r.body));
  }

  static Future<int> crearDocumento(Documento d) async {
    final r = await http.post(
      _u('/api/admin/documentos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(d.toCreateUpdateJson()),
    );
    if (r.statusCode != 200) throw Exception('No se pudo crear: ${r.statusCode} ${r.body}');
    final m = jsonDecode(r.body);
    return (m['id'] is int) ? m['id'] : int.tryParse(m['id'].toString()) ?? 0;
  }

  static Future<void> editarDocumento(Documento d) async {
    final r = await http.put(
      _u('/api/admin/documentos/${d.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(d.toCreateUpdateJson()),
    );
    if (r.statusCode != 200) throw Exception('No se pudo actualizar: ${r.statusCode} ${r.body}');
  }

  static Future<void> eliminarDocumento(int id) async {
    final r = await http.delete(_u('/api/admin/documentos/$id'));
    if (r.statusCode != 200) throw Exception('No se pudo eliminar: ${r.statusCode} ${r.body}');
  }

  static Future<int> registrarVisita(int id) async {
    final r = await http.post(_u('/api/admin/documentos/$id/visita'));
    if (r.statusCode != 200) throw Exception('No se pudo registrar visita: ${r.statusCode} ${r.body}');
    final m = jsonDecode(r.body);
    final v = m['visitas'];
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }
}