import 'package:flutter/material.dart';
import 'main.dart'; 
import 'lib/screens/usuarios_page.dart';
import 'lib/screens/documentos_page.dart';

class Admin extends StatelessWidget {
  final String? nombreCompleto;
  final String? correo;
  final String? username;
  final bool? esAdmin;

  const Admin({
    super.key,
    this.nombreCompleto,
    this.correo,
    this.username,
    this.esAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return AdminHome(
      nombreCompleto: nombreCompleto,
      correo: correo,
      username: username,
      esAdmin: esAdmin,
    );
  }
}

class AdminHome extends StatefulWidget {
  final String? nombreCompleto;
  final String? correo;
  final String? username;
  final bool? esAdmin;

  const AdminHome({
    Key? key,
    this.nombreCompleto,
    this.correo,
    this.username,
    this.esAdmin,
  }) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  void _openDocumentos() {
    Navigator.pop(context);
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DocumentosPage()));
  }

  void _openUsuarios() {
    Navigator.pop(context);
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const UsuariosPage()));
  }

  void _logoutToMain() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MyHomePage()),
      (route) => false,
    );
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 29, 40, 96),
        title: const Text('Cerrar sesión', style: TextStyle(color: Colors.white)),
        content: const Text('¿Deseas cerrar sesión?', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('No', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Sí, cerrar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (mounted) {
        Navigator.of(context).pop();
      }
      _logoutToMain();
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 29, 40, 96),
        title: const Text('Administrador', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 29, 40, 96),
        child: SafeArea(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  widget.nombreCompleto ?? (widget.username ?? 'Administrador'),
                  style: const TextStyle(color: Colors.white),
                ),
                accountEmail: Text(
                  widget.correo ?? '',
                  style: const TextStyle(color: Colors.white70),
                ),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 0, 0, 0),
                  backgroundImage: AssetImage("assets/monito-ruega.gif"),
                ),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 29, 40, 96),
                ),
                margin: EdgeInsets.zero,
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.description, color: Colors.white),
                      title: const Text('Documentos', style: TextStyle(color: Colors.white)),
                      subtitle: const Text('Gestiona y edita documentos',
                          style: TextStyle(color: Colors.white70)),
                      onTap: _openDocumentos,
                    ),
                    ListTile(
                      leading: const Icon(Icons.people_alt, color: Colors.white),
                      title: const Text('Usuarios', style: TextStyle(color: Colors.white)),
                      subtitle: const Text('Lista, edita y agrega usuarios',
                          style: TextStyle(color: Colors.white70)),
                      onTap: _openUsuarios,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Colors.white24),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text('Cerrar sesión', style: TextStyle(color: Colors.white)),
                onTap: _confirmLogout,
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/fondousuario3.gif"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}