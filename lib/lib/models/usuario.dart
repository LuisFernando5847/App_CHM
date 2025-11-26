class Usuario {
  final int id;
  String username;
  String password;
  String nombres;
  String apellidoP;
  String apellidoM;
  String correo;
  bool esAdmin;
  List<int> areaIDs;
  String empresa;

  Usuario({
    required this.id,
    required this.username,
    required this.password,
    required this.nombres,
    required this.apellidoP,
    required this.apellidoM,
    required this.correo,
    required this.esAdmin,
    this.areaIDs = const [],
    this.empresa = "Cranes Hoist Mexico", 
  });

  factory Usuario.fromJson(Map<String, dynamic> j) {
    int _toInt(dynamic x) =>
        (x is int) ? x : int.tryParse(x?.toString() ?? '') ?? 0;

    bool _toBool(dynamic x) {
      if (x is bool) return x;
      final s = x?.toString().toLowerCase() ?? '';
      return s == '1' || s == 'true' || s == 't' || s == 'yes' || s == 'si';
    }

    T? _pick<T>(Map<String, dynamic> m, List<String> keys) {
      for (final k in keys) {
        if (m.containsKey(k) && m[k] != null) return m[k] as T?;
      }
      return null;
    }

    String _pickStr(List<String> keys, [String fallback = '']) {
      final v = _pick<dynamic>(j, keys);
      if (v == null) return fallback;
      return v.toString();
    }

    List<int> _parseAreaIDs(Map<String, dynamic> m) {
      final raw = m['areaIDs'] ?? m['AreaIDs'] ?? m['areas'] ?? m['Areas'];
      if (raw is List) {
        if (raw.isNotEmpty && raw.first is Map) {
          return raw
              .map((e) => _toInt((e as Map)['id'] ?? (e as Map)['ID']))
              .where((v) => v != 0)
              .toList();
        } else {
          return raw.map((e) => _toInt(e)).where((v) => v != 0).toList();
        }
      }
      return <int>[];
    }

    return Usuario(
      id: _toInt(j['id'] ?? j['ID']),
      username: _pickStr(['username', 'usuario', 'Usuario', 'Username']),
      password: _pickStr(['password', 'Password']),
      nombres: _pickStr(['nombres', 'Nombres']),
      apellidoP: _pickStr(
          ['apellidoP', 'ApellidoP', 'apellido_p', 'Apellido_P', 'apellido_P']),
      apellidoM: _pickStr(
          ['apellidoM', 'ApellidoM', 'apellido_m', 'Apellido_M', 'apellido_M']),
      correo: _pickStr(['correo', 'Correo', 'email', 'Email']),
      esAdmin:
          _toBool(j['esAdmin'] ?? j['EsAdmin'] ?? j['isAdmin'] ?? j['IsAdmin']),
      areaIDs: _parseAreaIDs(j),
      empresa: _pickStr(['empresa', 'Empresa'], "Cranes Hoist Mexico"), 
    );
  }

  Map<String, dynamic> toCreateJson() => {
        "username": username,
        "password": password,
        "nombres": nombres,
        "apellido_P": apellidoP,
        "apellido_M": apellidoM,
        "correo": correo,
        "esAdmin": esAdmin,
        "areaIDs": areaIDs,
        "empresa": empresa, 
      };

  Map<String, dynamic> toUpdateJson() => {
        "username": username,
        "password": password,
        "nombres": nombres,
        "apellido_P": apellidoP,
        "apellido_M": apellidoM,
        "correo": correo,
        "esAdmin": esAdmin,
        "areaIDs": areaIDs,
        "empresa": empresa,
      };
}