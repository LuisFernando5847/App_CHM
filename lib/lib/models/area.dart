class Area {
  final int id;
  final String nombre;
  final String descripcion;

  Area({required this.id, required this.nombre, this.descripcion = ''});

  factory Area.fromJson(Map<String, dynamic> j) => Area(
        id: j['id'] is int ? j['id'] : int.tryParse(j['id'].toString()) ?? 0,
        nombre: (j['nombre'] ?? '').toString(),
        descripcion: (j['descripcion'] ?? '').toString(),
      );
}