import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class PinVerificationDialog extends StatelessWidget {
  final Function(bool) onVerified;
  const PinVerificationDialog({super.key, required this.onVerified});

  Future<void> _verifyPin(BuildContext context, String input) async {
    final hashedInput = sha256.convert(utf8.encode(input)).toString();
    final prefs = await SharedPreferences.getInstance();
    final savedHash = prefs.getString('owner_pin_hash');

    if (hashedInput == savedHash) {
      if (context.mounted) Navigator.of(context).pop();
      onVerified(true);
    } else {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PIN Salah!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    String input = "";
    return AlertDialog(
      title: const Text('Otorisasi Owner'),
      content: TextField(
        keyboardType: TextInputType.number,
        obscureText: true,
        maxLength: 6,
        onChanged: (val) => input = val,
        decoration: const InputDecoration(labelText: 'Masukkan 6 Digit PIN'),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
        ElevatedButton(onPressed: () => _verifyPin(context, input), child: const Text('Verifikasi')),
      ],
    );
  }
}
