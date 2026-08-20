import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/pos_provider.dart';

class SupervisorPinDialog extends StatefulWidget {
  final String title;
  const SupervisorPinDialog({super.key, this.title = 'Verifikasi PIN Supervisor'});

  @override
  State<SupervisorPinDialog> createState() => _SupervisorPinDialogState();
}

class _SupervisorPinDialogState extends State<SupervisorPinDialog> {
  String _enteredPin = '';
  String? _errorMessage;

  void _onKeyPress(String digit) {
    if (_enteredPin.length < 4) {
      setState(() {
        _enteredPin += digit;
        _errorMessage = null;
      });
      if (_enteredPin.length == 4) {
        _verifyPin();
      }
    }
  }

  void _onDelete() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        _errorMessage = null;
      });
    }
  }

  Future<void> _verifyPin() async {
    final provider = Provider.of<PosProvider>(context, listen: false);
    // Asumsi hash sederhana untuk simulasi lokal (dapat disesuaikan dengan crypto/sha256)
    bool isValid = await provider.validateSupervisorOverridePin(_enteredPin);

    if (isValid && mounted) {
      Navigator.of(context).pop(true); // Otorisasi sukses
    } else {
      setState(() {
        _enteredPin = '';
        _errorMessage = 'PIN Supervisor Salah!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Aksi ini memerlukan otorisasi Supervisor/Owner', style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 16),
          // PIN Indicator (4 Dots)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index < _enteredPin.length ? Colors.blue : Colors.grey.shade300,
                ),
              );
            }),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.bold)),
          ],
          const SizedBox(height: 20),
          // Custom Keypad 3x4
          SizedBox(
            width: 240,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                if (index == 9) {
                  return const SizedBox(); // Empty slot
                }
                if (index == 10) {
                  return ElevatedButton(
                    onPressed: () => _onKeyPress('0'),
                    style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
                    child: const Text('0', style: TextStyle(fontSize: 18)),
                  );
                }
                if (index == 11) {
                  return IconButton(
                    onPressed: _onDelete,
                    icon: const Icon(Icons.backspace, color: Colors.red),
                  );
                }
                final digit = (index + 1).toString();
                return ElevatedButton(
                  onPressed: () => _onKeyPress(digit),
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
                  child: Text(digit, style: const TextStyle(fontSize: 18)),
                );
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Batal'),
        ),
      ],
    );
  }
}
