import 'package:flutter/material.dart';

import 'sync_login_controller.dart';

/// Layar login akun sinkronisasi (backend): input username/password
/// diteruskan ke `RemoteAuthRepository.login`, token disimpan via
/// `AuthRepository` lokal. Dipanggil dari aksi login di AppBar.
class SyncLoginScreen extends StatefulWidget {
  final SyncLoginController controller;

  const SyncLoginScreen({super.key, required this.controller});

  @override
  State<SyncLoginScreen> createState() => _SyncLoginScreenState();
}

class _SyncLoginScreenState extends State<SyncLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final ok = await widget.controller.login(
      username: _usernameController.text,
      password: _passwordController.text,
    );
    if (!mounted) {
      return;
    }
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login berhasil — token tersimpan.')),
      );
      Navigator.of(context).pop();
    }
    // Error ditampilkan oleh ListenableBuilder di bawah.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Akun Sinkronisasi')),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(Icons.cloud_sync,
                          size: 48, color: Colors.orange),
                      const SizedBox(height: 12),
                      const Text(
                        'Masuk ke Server POS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Username wajib diisi.'
                                : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        onFieldSubmitted: (_) => _submit(),
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Password wajib diisi.'
                            : null,
                      ),
                      if (widget.controller.error != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          widget.controller.error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: widget.controller.isLoading
                            ? null
                            : _submit,
                        child: widget.controller.isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2),
                              )
                            : const Text('Login'),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.controller.isLoggedIn
                            ? 'Status: sudah login (token tersimpan).'
                            : 'Status: belum login.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: widget.controller.isLoggedIn
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ),
                      if (widget.controller.isLoggedIn) ...[
                        const SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: () async {
                            await widget.controller.logout();
                          },
                          child: const Text('Logout'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
