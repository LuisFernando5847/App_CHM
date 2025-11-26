import 'package:flutter/material.dart';
import '../models/documento.dart';
import '../services/api_docs_client.dart';
import 'documento_form.dart';
import '../../pdf_viewer_page.dart';

class DocumentosPage extends StatefulWidget {
  const DocumentosPage({super.key});

  @override
  State<DocumentosPage> createState() => _DocumentosPageState();
}

class _DocumentosPageState extends State<DocumentosPage> {
  late Future<List<Documento>> future;

  static const kPrimary = Color.fromARGB(255, 29, 40, 96);
  static const kBgDark  = Color.fromARGB(255, 0, 0, 0);

  final _search = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    future = ApiDocsClient.listarDocumentos();
    _search.addListener(() {
      setState(() {
        _query = _search.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _reload() {
    setState(() {
      future = ApiDocsClient.listarDocumentos();
    });
  }

  Future<void> _delete(int id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black87,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        contentTextStyle: const TextStyle(color: Colors.white70),
        title: const Text('Eliminar documento'),
        content: const Text('¿Seguro que deseas eliminar este documento?'),
        actions: [
          TextButton(
            onPressed: ()=> Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimary,
              foregroundColor: Colors.white,
            ),
            onPressed: ()=> Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ApiDocsClient.eliminarDocumento(id);
      _reload();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  String _normalizeDriveUrl(String url) {
    if (url.contains('drive.google.com')) {
      final exp = RegExp(r'/d/([^/]+)/');
      final m = exp.firstMatch(url);
      if (m != null && m.groupCount >= 1) {
        final fileId = m.group(1);
        return 'https://drive.google.com/uc?export=download&id=$fileId';
      }
    }
    return url;
  }

  Future<void> _openDoc(Documento d) async {
    try {
      final nuevo = await ApiDocsClient.registrarVisita(d.id);
      setState(() {
        d.visitas = nuevo;
      });
    } catch (_) {}

    final normalized = _normalizeDriveUrl(d.link.trim());
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PdfViewerPage(url: normalized, title: d.titulo)),
    );

    _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Documentos', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fondodocumentos.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: kBgDark.withOpacity(0.50)),

          FutureBuilder<List<Documento>>(
            future: future,
            builder: (_, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              }
              if (snap.hasError) {
                return const _StateMessage(
                  icon: Icons.error_outline,
                  title: 'Ocurrió un error',
                  message: 'No fue posible cargar los documentos.',
                );
              }

              final docs = snap.data ?? [];
              final filtered = docs.where((d) {
                if (_query.isEmpty) return true;
                final t = d.titulo.toLowerCase();
                final link = d.link.toLowerCase();
                final areas = (d.areas.isNotEmpty
                        ? d.areas.join(', ')
                        : (d.areaIDs.isNotEmpty ? d.areaIDs.join(', ') : ''))
                    .toLowerCase();
                return t.contains(_query) || link.contains(_query) || areas.contains(_query);
              }).toList();

              if (docs.isEmpty) {
                return const _StateMessage(
                  icon: Icons.insert_drive_file_outlined,
                  title: 'Sin documentos',
                  message: 'Agrega tu primer documento con el botón “Agregar”.',
                );
              }

              return SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: TextField(
                        controller: _search,
                        style: const TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: 'Buscar',
                          hintStyle: const TextStyle(color: Colors.white70),
                          prefixIcon: const Icon(Icons.search, color: Colors.white70),
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.35),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Colors.white24),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: kPrimary, width: 2),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        color: Colors.white,
                        backgroundColor: kPrimary,
                        onRefresh: () async { _reload(); },
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                          itemCount: filtered.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 10),
                          itemBuilder: (_, i) {
                            final d = filtered[i];
                            final areasText = (d.areas.isNotEmpty)
                                ? d.areas.join(', ')
                                : (d.areaIDs.isNotEmpty ? 'Áreas: ${d.areaIDs.join(', ')}' : 'Sin áreas');

                            return _DocItem(
                              documento: d,
                              areasText: areasText,
                              onOpen: () { _openDoc(d); },
                              onEdit: () async {
                                final updated = await Navigator.of(context).push<bool>(
                                  MaterialPageRoute(builder: (_) => DocumentoForm.editar(documento: d)),
                                );
                                if (updated == true) _reload();
                              },
                              onDelete: () { _delete(d.id); },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
        onPressed: () async {
          final created = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const DocumentoForm.crear()),
          );
          if (created == true) _reload();
        },
      ),
    );
  }
}

class _DocItem extends StatelessWidget {
  const _DocItem({
    required this.documento,
    required this.areasText,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
  });

  final Documento documento;
  final String areasText;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  static const kPrimary = Color.fromARGB(255, 29, 40, 96);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onOpen,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 8),
            )
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: kPrimary,
                  child: Icon(Icons.description, color: Colors.white),
                ),
                Positioned(
                  right: -6,
                  top: -6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      border: Border.all(color: Colors.white24),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.visibility, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          '${documento.visitas}',
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    documento.titulo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    areasText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    documento.link,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Abrir',
                  onPressed: onOpen,
                  icon: const Icon(Icons.open_in_new),
                  color: Colors.white,
                ),
                IconButton(
                  tooltip: 'Editar',
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit),
                  color: Colors.white,
                ),
                IconButton(
                  tooltip: 'Eliminar',
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete),
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class _StateMessage extends StatelessWidget {
  const _StateMessage({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.35),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                message,
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}