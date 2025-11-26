import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'pdf_viewer_page.dart';
import 'lib/services/api_docs_client.dart'; 

const String apiBase =
    "https://apichm-gjabejbmdza5gefe.mexicocentral-01.azurewebsites.net";

const _adminPrimary = Color(0xFF192557);
const _adminAccent = Color.fromARGB(255, 109, 123, 124);

const _ink = Color(0xFF0D0F14);
const _cardStroke = Colors.white24;

const _drawerBg = Color(0xFFF2F4FB);
const _selectedBg = Color(0xFFE6EFFA);

class TrabajadoresPage extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String? avatarUrl;

  const TrabajadoresPage({
    super.key,
    required this.userName,
    required this.userEmail,
    this.avatarUrl,
  });

  @override
  State<TrabajadoresPage> createState() => _TrabajadoresPageState();
}

class _TrabajadoresPageState extends State<TrabajadoresPage> {
  late Future<_CargaInicial> _initFuture;
  int? _selectedAreaId;
  String _query = "";

  @override
  void initState() {
    super.initState();
    _initFuture = _cargarTodo();
  }

  Future<_UsuarioRes> _resolverUsuarioPorCorreo(String correo) async {
    final listUri = Uri.parse("$apiBase/api/admin/usuarios");
    try {
      final resp = await http.get(listUri);
      if (resp.statusCode == 200 && resp.body.isNotEmpty) {
        final list =
            (jsonDecode(resp.body) as List).cast<Map<String, dynamic>>();
        Map<String, dynamic>? encontrado;
        final correoNorm = correo.trim().toLowerCase();
        for (final u in list) {
          final c = (u["Correo"] ?? u["correo"] ?? "")
              .toString()
              .trim()
              .toLowerCase();
          if (c == correoNorm) {
            encontrado = u;
            break;
          }
        }
        if (encontrado != null) {
          final id = (encontrado["ID"] ?? encontrado["id"]) as num?;
          final detUri =
              Uri.parse("$apiBase/api/admin/usuarios/${id?.toInt()}");
          final det = await http.get(detUri);
          if (det.statusCode == 200 && det.body.isNotEmpty) {
            final data = jsonDecode(det.body) as Map<String, dynamic>;
            final ids = ((data["areaIDs"] ?? data["AreaIDs"] ?? []) as List)
                .map((e) => (e as num).toInt())
                .toSet();
            return _UsuarioRes(id: id?.toInt(), areaIds: ids, resolved: true);
          }
        }
      }
    } catch (_) {}
    return _UsuarioRes(id: null, areaIds: <int>{}, resolved: false);
  }

  Future<_CargaInicial> _cargarTodo() async {
    final resolved = await _resolverUsuarioPorCorreo(widget.userEmail);

    final aRes =
        await http.get(Uri.parse("$apiBase/api/admin/documentos/areas"));
    if (aRes.statusCode != 200) {
      throw Exception(
          "No se pudo obtener el catálogo de áreas (${aRes.statusCode})");
    }
    final allAreas =
        (jsonDecode(aRes.body) as List).map((j) => Area.fromJson(j)).toList();

    final userAreas = allAreas
        .where((a) => resolved.areaIds.contains(a.id))
        .toList()
      ..sort(
          (a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));

    final dRes =
        await http.get(Uri.parse("$apiBase/api/admin/documentos"));
    if (dRes.statusCode != 200) {
      throw Exception(
          "No se pudo obtener la lista de documentos (${dRes.statusCode})");
    }
    final allDocs = (jsonDecode(dRes.body) as List)
        .map((j) => Documento.fromJson(j))
        .toList();

    final selected = userAreas.isNotEmpty ? userAreas.first.id : null;

    final usuario = UsuarioUI(
        nombre: widget.userName,
        correo: widget.userEmail,
        avatarUrl: widget.avatarUrl);

    return _CargaInicial(
      usuarioAreaIds: resolved.areaIds,
      areas: userAreas,
      documentos: allDocs,
      selectedAreaId: selected,
      usuario: usuario,
      pudoResolver: resolved.resolved,
    );
  }

  void _selectArea(int id) {
    setState(() => _selectedAreaId = id);
    Navigator.pop(context);
  }

  Future<void> _refresh() async {
    setState(() {
      _initFuture = _cargarTodo();
    });
    await _initFuture;
  }

  // 👇👇👇 AQUI ESTA EL CONTADOR DE VISITAS 👇👇👇
  Future<void> _openDoc(Documento doc) async {
    try {
      final nuevo = await ApiDocsClient.registrarVisita(doc.id);
      setState(() => doc.visitas = nuevo);
    } catch (e) {
      print("Error al registrar visita: $e");
    }

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            PdfViewerPage(url: doc.link ?? "", title: doc.titulo),
      ),
    );
  }
  // 👆👆👆 FIN DEL CONTADOR 👆👆👆

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_CargaInicial>(
      future: _initFuture,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: _ink,
            body: Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }
        if (snap.hasError) {
          return Scaffold(
            backgroundColor: _ink,
            appBar: AppBar(
              title: const Text("Documentos"),
              backgroundColor: _adminPrimary,
              foregroundColor: Colors.white,
            ),
            body: Center(
                child: Text("Error: ${snap.error}",
                    style: const TextStyle(color: Colors.white))),
          );
        }

        final data = snap.data!;
        _selectedAreaId ??= data.selectedAreaId;

        final selectedArea = data.areas.firstWhere(
          (a) => a.id == _selectedAreaId,
          orElse: () => data.areas.isNotEmpty
              ? data.areas.first
              : Area(id: 0, nombre: "Sin áreas"),
        );

        final docsEnArea = data.documentos
            .where((d) => d.areaIDs.contains(selectedArea.id))
            .where((d) => _query.isEmpty ||
                d.titulo.toLowerCase().contains(_query.toLowerCase()))
            .toList()
          ..sort(
              (a, b) => a.titulo.toLowerCase().compareTo(b.titulo.toLowerCase()));

        return Scaffold(
          backgroundColor: _ink,
          appBar: AppBar(
            backgroundColor: _adminPrimary,
            foregroundColor: Colors.white,
            title: const Text("Documentos",
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
          drawer: _AdminStyledDrawer(
            usuario: data.usuario,
            areas: data.areas,
            selectedAreaId: _selectedAreaId,
            onTapArea: _selectArea,
            pudoResolverAreas: data.pudoResolver,
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset("assets/fondodocumentos.jpg", fit: BoxFit.cover),
              Container(color: Colors.black.withOpacity(0.55)),
              RefreshIndicator(
                color: Colors.white,
                onRefresh: _refresh,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  children: [
                    _SearchBox(
                      hint: "Buscar",
                      onChanged: (t) => setState(() => _query = t),
                    ),
                    const SizedBox(height: 12),
                    if (docsEnArea.isEmpty)
                      const _EmptyState()
                    else
                      ...docsEnArea.map((doc) => _DocItem(
                            doc: doc,
                            areaNames: doc.areas.join(", "),
                            onOpen: () => _openDoc(doc), // 👈 USO DEL CONTADOR
                          )),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AdminStyledDrawer extends StatelessWidget {
  final UsuarioUI usuario;
  final List<Area> areas;
  final int? selectedAreaId;
  final ValueChanged<int> onTapArea;
  final bool pudoResolverAreas;

  const _AdminStyledDrawer({
    required this.usuario,
    required this.areas,
    required this.selectedAreaId,
    required this.onTapArea,
    required this.pudoResolverAreas,
  });

  @override
  Widget build(BuildContext context) {
    final Widget avatar = CircleAvatar(
      backgroundColor: Colors.white,
      foregroundImage: const AssetImage('assets/animacion6.gif'),
      child: Text(
        usuario.iniciales,
        style:
            const TextStyle(color: _adminPrimary, fontWeight: FontWeight.bold),
      ),
    );

    final theme = Theme.of(context).copyWith(
      drawerTheme: const DrawerThemeData(backgroundColor: _drawerBg),
      canvasColor: _drawerBg,
      scaffoldBackgroundColor: _drawerBg,
      listTileTheme: const ListTileThemeData(
        iconColor: _adminPrimary,
        textColor: Colors.black87,
      ),
    );

    return Theme(
      data: theme,
      child: Drawer(
        backgroundColor: _drawerBg,
        child: Column(
          children: [
            Container(
              color: _adminPrimary,
              child: SafeArea(
                bottom: false,
                child: UserAccountsDrawerHeader(
                  currentAccountPicture: avatar,
                  margin: EdgeInsets.zero,
                  decoration: const BoxDecoration(color: Colors.transparent),
                  accountName: Text(
                    usuario.nombre.isEmpty ? "Usuario" : usuario.nombre,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  accountEmail: Text(
                    usuario.correo.isEmpty ? "sin correo" : usuario.correo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),

            if (!pudoResolverAreas)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "No se pudieron resolver tus áreas aún.\nSe buscó tu correo en /api/admin/usuarios.",
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
              ),

            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: areas.length,
                itemBuilder: (_, i) {
                  final a = areas[i];
                  final sel = a.id == selectedAreaId;

                  return Container(
                    color: sel ? _selectedBg : _drawerBg,
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: Icon(
                        sel ? Icons.folder_open : Icons.folder,
                        color: sel ? _adminAccent : _adminPrimary,
                        size: 28,
                      ),
                      title: Text(
                        a.nombre,
                        style: TextStyle(
                          fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                          color: Colors.black87,
                          fontSize: 18,
                          letterSpacing: 0.2,
                        ),
                      ),
                      onTap: () => onTapArea(a.id),
                    ),
                  );
                },
              ),
            ),

            const Divider(height: 1),

            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text("Cerrar sesión"),
                    style: FilledButton.styleFrom(
                      backgroundColor: _adminPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                    ),
                    onPressed: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          title: const Text("Cerrar sesión"),
                          content:
                              const Text("¿Seguro que deseas cerrar sesión?"),
                          actions: [
                            TextButton(
                              child: const Text("Cancelar"),
                              onPressed: () => Navigator.pop(ctx, false),
                            ),
                            FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: _adminPrimary,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text("Cerrar sesión"),
                            ),
                          ],
                        ),
                      );

                      if (ok == true) {
                        Navigator.pop(context);
                        Navigator.of(context, rootNavigator: true)
                            .pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (_) => const MyHomePage()),
                          (route) => false,
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocItem extends StatelessWidget {
  final Documento doc;
  final String areaNames;
  final VoidCallback onOpen;

  const _DocItem({
    required this.doc,
    required this.areaNames,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: ShapeDecoration(
        color: Colors.black54.withOpacity(0.35),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: _cardStroke),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: _adminPrimary,
          child: const Icon(Icons.description, color: Colors.white),
        ),
        title: Text(
          doc.titulo,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
            letterSpacing: 0.2,
          ),
        ),
        subtitle: areaNames.isEmpty
            ? null
            : Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  areaNames,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
        trailing: const Icon(Icons.open_in_new, color: Colors.white),
        onTap: onOpen,
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String hint;
  const _SearchBox({required this.onChanged, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        prefixIcon: const Icon(Icons.search, color: Colors.white70),
        filled: true,
        fillColor: Colors.black38,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: _cardStroke),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: _cardStroke),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: Colors.white70, width: 1.5),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Text(
          "No hay documentos relacionados a esta área.",
          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class UsuarioUI {
  final String nombre;
  final String correo;
  final String? avatarUrl;
  UsuarioUI({required this.nombre, required this.correo, this.avatarUrl});

  String get iniciales {
    final base = nombre.isNotEmpty ? nombre : correo;
    final partes = base.trim().split(RegExp(r'\s+'));
    final ini =
        partes.take(2).map((p) => p.isNotEmpty ? p[0].toUpperCase() : '').join();
    return ini.isEmpty ? "U" : ini;
  }
}

class Area {
  final int id;
  final String nombre;
  Area({required this.id, required this.nombre});
  factory Area.fromJson(Map<String, dynamic> j) => Area(
        id: (j["id"] ?? j["Id"] as num).toInt(),
        nombre: (j["nombre"] ?? j["Nombre"] ?? "").toString(),
      );
}

class Documento {
  final int id;
  final String titulo;
  String? link;
  int? visitas;
  final List<int> areaIDs;
  final List<String> areas;

  Documento({
    required this.id,
    required this.titulo,
    required this.link,
    required this.visitas,
    required this.areaIDs,
    required this.areas,
  });

  factory Documento.fromJson(Map<String, dynamic> j) {
    List<int> parseIds(dynamic v) =>
        (v is List) ? v.map((e) => (e as num).toInt()).toList() : <int>[];
    List<String> parseNames(dynamic v) =>
        (v is List) ? v.map((e) => e.toString()).toList() : <String>[];
    return Documento(
      id: (j["id"] ?? j["Id"] as num).toInt(),
      titulo: (j["titulo"] ?? j["Titulo"] ?? "").toString(),
      link: (j["link"] ?? j["Url"] ?? "").toString(),
      visitas: j["visitas"] == null ? null : (j["visitas"] as num).toInt(),
      areaIDs: parseIds(j["areaIDs"] ?? j["AreaIDs"]),
      areas: parseNames(j["areas"] ?? j["Areas"]),
    );
  }
}

class _UsuarioRes {
  final int? id;
  final Set<int> areaIds;
  final bool resolved;
  _UsuarioRes({required this.id, required this.areaIds, required this.resolved});
}

class _CargaInicial {
  final Set<int> usuarioAreaIds;
  final List<Area> areas;
  final List<Documento> documentos;
  final int? selectedAreaId;
  final UsuarioUI usuario;
  final bool pudoResolver;

  _CargaInicial({
    required this.usuarioAreaIds,
    required this.areas,
    required this.documentos,
    required this.selectedAreaId,
    required this.usuario,
    required this.pudoResolver,
  });
}