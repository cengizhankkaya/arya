import 'package:arya/product/utility/storage/app_prefs.dart';
import 'package:flutter/material.dart';

class OffCredentialsView extends StatefulWidget {
  const OffCredentialsView({super.key});

  @override
  State<OffCredentialsView> createState() => _OffCredentialsViewState();
}

class _OffCredentialsViewState extends State<OffCredentialsView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final u = await AppPrefs.getOffUsername();
    final p = await AppPrefs.getOffPassword();
    if (!mounted) return;
    _usernameController.text = u ?? '';
    _passwordController.text = p ?? '';
    setState(() {});
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await AppPrefs.setOffCredentials(
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Open Food Facts bilgileri kaydedildi.')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Kaydedilemedi: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _clear() async {
    await AppPrefs.clearOffCredentials();
    if (!mounted) return;
    _usernameController.clear();
    _passwordController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Open Food Facts bilgileri temizlendi.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Open Food Facts Hesabı')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Kullanıcı Adı'),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Kullanıcı adı zorunlu'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Şifre'),
                obscureText: true,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Şifre zorunlu' : null,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _loading ? null : _save,
                    child: _loading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Kaydet'),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: _loading ? null : _clear,
                    child: const Text('Temizle'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
