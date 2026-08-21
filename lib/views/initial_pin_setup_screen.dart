import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'pos_dashboard_screen.dart';

class InitialPinSetupScreen extends StatefulWidget {
  const InitialPinSetupScreen({super.key});

  @override
  State<InitialPinSetupScreen> createState() => _InitialPinSetupScreenState();
}

class _InitialPinSetupScreenState extends State<InitialPinSetupScreen> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _saveOwnerPin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final rawPin = _pinController.text.trim();
    // Hashing SHA-256 untuk keamanan PIN
    final hashedPin = sha256.convert(utf8.encode(rawPin)).toString();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('owner_pin_hash', hashedPin);
    await prefs.setBool('is_initial_setup_done', true);

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const PosDashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.storefront_rounded, size: 80, color: Colors.blue),
                  const SizedBox(height: 16),
                  const Text(
                    'Selamat Datang di POS Kasir',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Atur PIN Supervisor / Owner (6 Digit) untuk mengamankan otorisasi pembatalan dan diskon khusus.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _pinController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 6,
                    decoration: const InputDecoration(
                      labelText: 'Buat PIN Owner (6 Digit)',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) {
                      if (val == null || val.length != 6 || int.tryParse(val) == null) {
                        return 'PIN harus berupa 6 angka';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPinController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 6,
                    decoration: const InputDecoration(
                      labelText: 'Konfirmasi PIN Owner',
                      prefixIcon: Icon(Icons.lock_reset_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) {
                      if (val != _pinController.text) {
                        return 'Konfirmasi PIN tidak cocok';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveOwnerPin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: _isLoading
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('Simpan & Lanjutkan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
