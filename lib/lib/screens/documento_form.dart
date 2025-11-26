import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import '../models/documento.dart';
import '../models/area.dart';
import '../services/api_docs_client.dart';

class DocumentoForm extends StatefulWidget {
  final Documento? documento;
  const DocumentoForm.crear({Key? key}) : documento = null, super(key: key);
  const DocumentoForm.editar({Key? key, required this.documento}) : super(key: key);

  @override
  State<DocumentoForm> createState() => _DocumentoFormState();
}

class _DocumentoFormState extends State<DocumentoForm> {
  final _form = GlobalKey<FormState>();
  final _titulo = TextEditingController();
  final _link   = TextEditingController();
  final _linkFocus = FocusNode(); 

  // Paleta del Admin
  static const kPrimary = Color.fromARGB(255, 29, 40, 96);
  static const kBgDark  = Color.fromARGB(255, 0, 0, 0);

  List<Area> _areas = [];
  final Set<int> _sel = {};
  bool _loading = false;
  bool _loadingInitial = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _titulo.dispose();
    _link.dispose();
    _linkFocus.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(()=> _loadingInitial = true);
    try {
      final areas = await ApiDocsClient.listarAreas();

      if (widget.documento != null) {
        _titulo.text = widget.documento!.titulo;
        _link.text   = widget.documento!.link;
        _sel.addAll(widget.documento!.areaIDs);
      }
      if (!mounted) return;
      setState(() => _areas = areas);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar datos: $e')),
      );
      Navigator.pop(context);
    } finally {
      if (mounted) setState(()=> _loadingInitial = false);
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

  Future<void> _pasteFromClipboard() async {
    try {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      final text = data?.text?.trim() ?? '';
      if (text.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No hay texto en el portapapeles')),
        );
        return;
      }
      _link.text = text;
      _link.selection = TextSelection.fromPosition(
        TextPosition(offset: _link.text.length),
      );
      _linkFocus.requestFocus();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo leer el portapapeles: $e')),
      );
    }
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;

    final editing = widget.documento != null;
    setState(()=> _loading = true);

    try {
      final linkBase = _link.text.trim();
      final linkFinal = linkBase.endsWith('/download')
      ? linkBase
      : '$linkBase/download';
      final d = Documento(
        id: editing ? widget.documento!.id : 0,
        titulo: _titulo.text.trim(),
        link: linkFinal,
        areaIDs: _sel.toList(),
        areas: const [],
        visitas: editing ? widget.documento!.visitas : 0,
      );


      if (editing) {
        await ApiDocsClient.editarDocumento(d);
      } else {
        await ApiDocsClient.crearDocumento(d);
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(()=> _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.documento != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          editing ? 'Editar documento' : 'Nuevo documento',
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
                                  child: Icon(Icons.description, color: Colors.white),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Datos del documento',
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
                              controller: _titulo,
                              cursorColor: Colors.white,
                              style: const TextStyle(color: Colors.white),
                              decoration: _dec('Título', icon: Icons.title),
                              validator: (v) =>
                                  (v==null || v.trim().isEmpty) ? 'Requerido' : null,
                            ),
                            const SizedBox(height: 12),

                            TextFormField(
                              controller: _link,
                              focusNode: _linkFocus,
                              cursorColor: Colors.white,
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.url,
                              decoration: _dec(
                                'Link',
                                icon: Icons.link,
                                suffix: IconButton(
                                  tooltip: 'Pegar desde portapapeles',
                                  icon: const Icon(Icons.paste, color: Colors.white70),
                                  onPressed: _pasteFromClipboard,
                                ),
                              ),
                              validator: (v) {
                                final value = (v ?? '').trim();
                                if (value.isEmpty) return 'Requerido';
                                final url = RegExp(r'^(https?:\/\/)');
                                if (!url.hasMatch(value)) {
                                  return 'Debe iniciar con http:// o https://';
                                }
                                return null;
                              },
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
                                  'Áreas',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: kPrimary,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white24),
                                ),
                                child: Text('${_sel.length}',
                                    style: const TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          if (_areas.isEmpty)
                            const Text('No hay áreas (o cargando)...',
                                style: TextStyle(color: Colors.white70))
                          else
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _areas.map((a) {
                                final selected = _sel.contains(a.id);
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
                                        _sel.remove(a.id);
                                      } else {
                                        _sel.add(a.id);
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
                                          _sel..clear()..addAll(_areas.map((e) => e.id))),
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
                                  onPressed: _sel.isEmpty ? null : () => setState(() => _sel.clear()),
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
                                    height: 20, width: 20,
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