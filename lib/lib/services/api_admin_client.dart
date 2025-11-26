import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';

class ApiAdminClient {
  static const String _base = 'https://apichm-gjabejbmdza5gefe.mexicocentral-01.azurewebsites.net';
  static Uri _u(String p) => Uri.parse('$_base$p');

  static T? _pick<T>(Map<String, dynamic> m, List<String> keys) {
    for (final k in keys) {
      if (m.containsKey(k) && m[k] != null) return m[k] as T?;
    }
    return null;
  }

  static Map<String, dynamic> _normalize(Map<String, dynamic> raw) {
    String str(List<String> ks, [String d = '']) {
      final v = _pick(raw, ks);
      return v == null ? d : v.toString();
    }
    int toInt(v, [int d = 0]) {
      if (v == null) return d;
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse('$v') ?? d;
    }
    bool toBool(v, [bool d = false]) {
      if (v == null) return d;
      if (v is bool) return v;
      if (v is num) return v != 0;
      final s = v.toString().toLowerCase();
      if (s == 'true') return true;
      if (s == 'false') return false;
      final n = int.tryParse(s);
      return n == null ? d : n != 0;
    }

    final areas = _pick(raw, ['areaIDs', 'AreaIDs']);
    final areaIDs = (areas is List)
        ? areas.map((e) => toInt(e)).where((x) => x != 0).toList()
        : <int>[];

    final norm = <String, dynamic>{
      'id'        : toInt(_pick(raw, ['id', 'ID'])),
      'username'  : str(['username','Usuario','Username']),
      'password'  : str(['password','Password'], ''),
      'nombres'   : str(['nombres','Nombres']),
      'apellidoP' : str(['apellidoP','Apellido_P','apellido_p','apellido_P','ApellidoP']),
      'apellidoM' : str(['apellidoM','Apellido_M','apellido_m','apellido_M','ApellidoM']),
      'correo'    : str(['correo','Correo']),
      'esAdmin'   : toBool(_pick(raw, ['esAdmin','EsAdmin'])),
      'areaIDs'   : areaIDs,
    };

    if (kDebugMode) {
      debugPrint('normalize in:  ${jsonEncode(raw)}');
      debugPrint('normalize out: ${jsonEncode(norm)}');
    }
    return norm;
  }

  static Future<List<Usuario>> listarUsuarios() async {
    final r = await http.get(_u('/api/admin/usuarios'));
    if (r.statusCode != 200) {
      throw Exception('Error listando usuarios: ${r.statusCode}\n${r.body}');
    }
    final data = jsonDecode(r.body);
    if (data is! List) throw Exception('Respuesta inesperada en listarUsuarios');

    return data.map<Usuario>((e) {
      final raw = (e as Map).cast<String, dynamic>();
      final norm = _normalize(raw);
      return Usuario.fromJson(norm);
    }).toList();
  }

  static Future<Usuario> obtenerUsuario(int id) async {
    final r = await http.get(_u('/api/admin/usuarios/$id'));
    if (r.statusCode != 200) {
      throw Exception('Error obteniendo usuario: ${r.statusCode}\n${r.body}');
    }
    final raw = (jsonDecode(r.body) as Map).cast<String, dynamic>();
    final norm = _normalize(raw);
    return Usuario.fromJson(norm);
  }

  static Future<void> crearUsuario(Usuario u) async {
    final Map<String, dynamic> map = u.toCreateJson();
    map['Empresa'] = 'Cranes Hoist Mexico';

    final body = jsonEncode(map);
    if (kDebugMode) debugPrint('POST /agregar body: $body');

    final r = await http.post(
      _u('/api/admin/agregar'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (r.statusCode != 200 && r.statusCode != 201) {
      throw Exception('No se pudo crear: ${r.statusCode}\n${r.body}\nBody enviado: $body');
    }
  }

  static Future<void> editarUsuario(Usuario u) async {
    final Map<String, dynamic> map = u.toUpdateJson();
    for (final k in ['password', 'Password']) {
      if (map.containsKey(k)) {
        final v = map[k];
        if (v == null || (v is String && v.trim().isEmpty)) {
          map.remove(k);
        }
      }
    }

    if (map.containsKey('areaIDs') && map['areaIDs'] is List) {
      map['areaIDs'] = (map['areaIDs'] as List)
          .map((e) => e is int ? e : (e is num ? e.toInt() : int.tryParse('$e') ?? 0))
          .where((x) => x != 0)
          .toList();
    }

    final body = jsonEncode(map);
    if (kDebugMode) debugPrint('PUT /editar/${u.id} body: $body');

    final r = await http.put(
      _u('/api/admin/editar/${u.id}'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (r.statusCode != 200) {
      throw Exception('No se pudo actualizar: ${r.statusCode}\n${r.body}\nBody enviado: $body');
    }
  }
}