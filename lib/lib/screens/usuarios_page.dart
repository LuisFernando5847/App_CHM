import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/api_admin_client.dart';
import 'usuario_form.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  late Future<List<Usuario>> future;

  // Colores del apartado Admin
  static const kPrimary = Color.fromARGB(255, 29, 40, 96);
  static const kBgDark = Color.fromARGB(255, 0, 0, 0);

  // Buscador
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    future = ApiAdminClient.listarUsuarios();
    _searchCtrl.addListener(() {
      setState(() => _query = _searchCtrl.text.trim());
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _reload() => setState(() => future = ApiAdminClient.listarUsuarios());

  List<Usuario> _filtrar(List<Usuario> list) {
    if (_query.isEmpty) return list;
    final q = _query.toLowerCase();
    return list.where((u) {
      final nombre = '${u.nombres} ${u.apellidoP} ${u.apellidoM}'.trim();
      final campos = [
        nombre,
        u.username ?? '',
        u.correo ?? '',
      ].join(' ').toLowerCase();
      return campos.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Usuarios', style: TextStyle(fontWeight: FontWeight.w600)),
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
          Container(color: kBgDark.withOpacity(0.45)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.white24, width: 1),
                    ),
                    child: TextField(
                      controller: _searchCtrl,
                      cursorColor: Colors.white70,
                      style: const TextStyle(color: Colors.white),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => FocusScope.of(context).unfocus(),
                      decoration: const InputDecoration(
                        hintText: 'Buscar',
                        hintStyle: TextStyle(color: Colors.white70),
                        prefixIcon: Icon(Icons.search, color: Colors.white70),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: FutureBuilder<List<Usuario>>(
                      future: future,
                      builder: (context, snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(color: Colors.white),
                          );
                        }
                        if (snap.hasError) {
                          return _StateMessage(
                            icon: Icons.error_outline,
                            title: 'Ocurrió un error',
                            message: '${snap.error}',
                          );
                        }
                        final list = _filtrar(snap.data ?? []);
                        if (list.isEmpty) {
                          return _StateMessage(
                            icon: Icons.people_outline,
                            title: _query.isEmpty ? 'Sin usuarios' : 'Sin coincidencias',
                            message: _query.isEmpty
                                ? 'No hay registros para mostrar.'
                                : 'No se encontraron resultados para “$_query”.',
                          );
                        }
                        return ListView.separated(
                          padding: const EdgeInsets.only(bottom: 100),
                          itemCount: list.length,
                          separatorBuilder: (_, _) => const Divider(height: 1, color: Colors.white24),
                          itemBuilder: (context, i) {
                            final u = list[i];
                            final nombre = '${u.nombres} ${u.apellidoP} ${u.apellidoM}'.trim();
                            final display = (nombre.isEmpty) ? (u.username ?? '') : nombre;
                            return _UserItem(
                              title: display,
                              subtitle: u.correo ?? '',
                              onEdit: () async {
                                final updated = await Navigator.of(context).push<bool>(
                                  MaterialPageRoute(
                                    builder: (_) => UsuarioForm.editar(usuarioId: u.id),
                                  ),
                                );
                                if (updated == true) _reload();
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add),
        label: const Text('Agregar'),
        onPressed: () async {
          final created = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const UsuarioForm.crear()),
          );
          if (created == true) _reload();
        },
      ),
    );
  }
}
class _UserItem extends StatelessWidget {
  const _UserItem({
    required this.title,
    required this.subtitle,
    required this.onEdit,
  });

  static const kPrimary = Color.fromARGB(255, 29, 40, 96);

  final String title;
  final String subtitle;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onEdit,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24, width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundColor: kPrimary,
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _TitleSubtitle(title: title, subtitle: subtitle),
            ),
            IconButton(
              tooltip: 'Editar',
              onPressed: onEdit,
              icon: const Icon(Icons.edit),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class _TitleSubtitle extends StatelessWidget {
  const _TitleSubtitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
      ],
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
                textAlign: TextAlign.center,
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