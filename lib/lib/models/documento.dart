class Documento {
  final int id;
  String titulo;
  String link;
  List<int> areaIDs;
  List<String> areas;
  int visitas; 

  Documento({
    required this.id,
    required this.titulo,
    required this.link,
    required this.areaIDs,
    required this.areas,
    required this.visitas,
  });

  factory Documento.fromJson(Map<String, dynamic> j) => Documento(
        id: j['id'] is int ? j['id'] : int.tryParse(j['id'].toString()) ?? 0,
        titulo: (j['titulo'] ?? j['Titulo'] ?? '').toString(),
        link: (j['link'] ?? '').toString(),
        areaIDs: (j['areaIDs'] ?? j['AreaIDs'] ?? [])
            .map<int>((e) => e is int ? e : int.tryParse(e.toString()) ?? 0)
            .toList(),
        areas: (j['areas'] ?? j['Areas'] ?? []).map<String>((e) => e.toString()).toList(),
        visitas: (j['visitas'] ?? j['Visitas'] ?? 0) is int
            ? (j['visitas'] ?? j['Visitas'] ?? 0)
            : int.tryParse((j['visitas'] ?? j['Visitas'] ?? '0').toString()) ?? 0,
      );

  Map<String, dynamic> toCreateUpdateJson() => {
        "titulo": titulo,
        "link": link,
        "areaIDs": areaIDs,
      };
}