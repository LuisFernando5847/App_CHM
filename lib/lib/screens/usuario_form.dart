import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/api_admin_client.dart';
import '../models/area.dart';
import '../services/api_docs_client.dart';

class UsuarioForm extends StatefulWidget {
  final int? usuarioId;
  const UsuarioForm._({this.usuarioId, Key? key}) : super(key: key);
  const UsuarioForm.crear({Key? key}) : this._(usuarioId: null, key: key);
  const UsuarioForm.editar({required int usuarioId, Key? key})
      : this._(usuarioId: usuarioId, key: key);

  @override
  State<UsuarioForm> createState() => _UsuarioFormState();
}

class _UsuarioFormState extends State<UsuarioForm> {
  final _form = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _nombres = TextEditingController();
  final _apP = TextEditingController();
  final _apM = TextEditingController();
  final _correo = TextEditingController();

  bool _showPassword = false;
  bool _esAdmin = false;
  bool _loading = false;
  bool _loadingInitial = false;

  List<Area> _areas = [];
  final Set<int> _selAreas = {};

  Usuario? _originalUser;                 
  String? _passwordOriginal;              
  static const kPrimary = Color.fromARGB(255, 29, 40, 96);
  static const kBgDark = Color.fromARGB(255, 0, 0, 0);

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    setState(() => _loadingInitial = true);
    try {
      _areas = await ApiDocsClient.listarAreas();

      if (widget.usuarioId != null) {
        final u = await ApiAdminClient.obtenerUsuario(widget.usuarioId!);
        _originalUser = u;               
        _passwordOriginal = u.password;   

        _username.text = u.username;
        _nombres.text = u.nombres;
        _apP.text = u.apellidoP;
        _apM.text = u.apellidoM;
        _correo.text = u.correo;
        _esAdmin = u.esAdmin;
        _selAreas..clear()..addAll(u.areaIDs);

        _password.clear();              
      }

      if (mounted) setState(() {});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar datos: $e')),
      );
      Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _loadingInitial = false);
    }
  }

  InputDecoration _dec(String label, {IconData? icon, Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: icon == null ? null : Icon(icon, color: Colors.white70),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.black.withOpacity(0.35),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: kPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }

  Widget _glassCard({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 8),
          )
        ],
      ),
      padding: padding ?? const EdgeInsets.all(16),
      child: child,
    );
  }

  bool _sameAreas(Set<int> a, Set<int> b) {
    if (a.length != b.length) return false;
    for (final x in a) {
      if (!b.contains(x)) return false;
    }
    return true;
  }

  bool _noChanges() {
    if (_originalUser == null) return false;

    final o = _originalUser!;
    final sameBasics =
        _username.text.trim() == o.username &&
        _nombres.text.trim() == o.nombres &&
        _apP.text.trim() == o.apellidoP &&
        _apM.text.trim() == o.apellidoM &&
        _correo.text.trim() == o.correo &&
        _esAdmin == o.esAdmin;

    final sameAreas = _sameAreas(_selAreas, o.areaIDs.toSet());

    final passwordChanged = _password.text.isNotEmpty;

    return sameBasics && sameAreas && !passwordChanged;
  }

  Future<void> _submit() async {
    final editing = widget.usuarioId != null;
    if (!_form.currentState!.validate()) return;

    if (editing && _noChanges()) {
      if (!mounted) return;
      Navigator.pop(context, false);
      return;
    }

    setState(() => _loading = true);
    try {
      final passToSend = editing
          ? (_password.text.isEmpty ? '' : _password.text)
          : _password.text;

      final u = Usuario(
        id: widget.usuarioId ?? 0,
        username: _username.text.trim(),
        password: passToSend,
        nombres: _nombres.text.trim(),
        apellidoP: _apP.text.trim(),
        apellidoM: _apM.text.trim(),
        correo: _correo.text.trim(),
        esAdmin: _esAdmin,
        areaIDs: _selAreas.toList(),
        empresa: "Cranes Hoist Mexico",
      );

      if (editing) {
        await ApiAdminClient.editarUsuario(u);
      } else {
        await ApiAdminClient.crearUsuario(u);
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.usuarioId != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          editing ? 'Editar usuario' : 'Nuevo usuario',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
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

          if (_loadingInitial)
            const Center(child: CircularProgressIndicator(color: Colors.white))
          else
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  children: [
                    _glassCard(
                      child: Form(
                        key: _form,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: const [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: kPrimary,
                                  child: Icon(Icons.person, color: Colors.white),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Datos del usuario',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            TextFormField(
                              controller: _username,
                              cursorColor: Colors.white,
                              style: const TextStyle(color: Colors.white),
                              decoration: _dec('Usuario', icon: Icons.badge),
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                            ),
                            const SizedBox(height: 12),

                            TextFormField(
                              controller: _password,
                              cursorColor: Colors.white,
                              style: const TextStyle(color: Colors.white),
                              decoration: _dec(
                                editing ? 'Contraseña (dejar en blanco para no cambiar)' : 'Contraseña',
                                icon: Icons.lock,
                                suffix: IconButton(
                                  tooltip: _showPassword ? 'Ocultar' : 'Mostrar',
                                  onPressed: () =>
                                      setState(() => _showPassword = !_showPassword),
                                  icon: Icon(
                                    _showPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                              obscureText: !_showPassword,
                              validator: (v) {
                                if (!editing && (v == null || v.isEmpty)) {
                                  return 'Requerido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),

                            TextFormField(
                              controller: _nombres,
                              cursorColor: Colors.white,
                              style: const TextStyle(color: Colors.white),
                              decoration: _dec('Nombres', icon: Icons.account_circle_outlined),
                            ),
                            const SizedBox(height: 12),

                            TextFormField(
                              controller: _apP,
                              cursorColor: Colors.white,
                              style: const TextStyle(color: Colors.white),
                              decoration: _dec('Apellido Paterno', icon: Icons.badge_outlined),
                            ),
                            const SizedBox(height: 12),

                            TextFormField(
                              controller: _apM,
                              cursorColor: Colors.white,
                              style: const TextStyle(color: Colors.white),
                              decoration: _dec('Apellido Materno', icon: Icons.badge_outlined),
                            ),
                            const SizedBox(height: 12),

                            TextFormField(
                              controller: _correo,
                              cursorColor: Colors.white,
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.emailAddress,
                              decoration: _dec('Correo', icon: Icons.email_outlined),
                              validator: (v) {
                                final value = (v ?? '').trim();
                                if (value.isEmpty) return null; // opcional
                                final emailRegex =
                                    RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                                if (!emailRegex.hasMatch(value)) {
                                  return 'Correo inválido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 8),

                            SwitchListTile(
                              title: const Text('Es administrador',
                                  style: TextStyle(color: Colors.white)),
                              value: _esAdmin,
                              onChanged: (v) => setState(() => _esAdmin = v),
                              activeColor: Colors.white,
                              activeTrackColor: kPrimary,
                              inactiveThumbColor: Colors.white70,
                              inactiveTrackColor: Colors.white24,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _glassCard(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.grid_view, color: Colors.white),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  'Áreas(Solo si no es administrador)',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: kPrimary,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white24),
                                ),
                                child: Text(
                                  '${_selAreas.length}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          if (_areas.isEmpty)
                            const Text(
                              'No hay áreas disponibles.',
                              style: TextStyle(color: Colors.white70),
                            )
                          else
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _areas.map((a) {
                                final selected = _selAreas.contains(a.id);
                                return FilterChip(
                                  selected: selected,
                                  showCheckmark: false,
                                  label: Text(
                                    a.nombre,
                                    style: TextStyle(
                                      color: selected ? Colors.white : Colors.white70,
                                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                                    ),
                                  ),
                                  selectedColor: kPrimary.withOpacity(0.85),
                                  backgroundColor: Colors.black.withOpacity(0.35),
                                  side: BorderSide(
                                    color: selected ? kPrimary : Colors.white24,
                                  ),
                                  onSelected: (_) {
                                    setState(() {
                                      if (selected) {
                                        _selAreas.remove(a.id);
                                      } else {
                                        _selAreas.add(a.id);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: _areas.isEmpty
                                      ? null
                                      : () => setState(() =>
                                          _selAreas..clear()..addAll(_areas.map((e) => e.id))),
                                  icon: const Icon(Icons.done_all),
                                  label: const Text('Seleccionar todo'),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.white54),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: _selAreas.isEmpty
                                      ? null
                                      : () => setState(() => _selAreas.clear()),
                                  icon: const Icon(Icons.clear_all),
                                  label: const Text('Limpiar'),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.white54),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _loading ? null : () => Navigator.pop(context, false),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white54),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: const Text('Cancelar'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _loading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: _loading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(editing ? 'Guardar cambios' : 'Guardar'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}