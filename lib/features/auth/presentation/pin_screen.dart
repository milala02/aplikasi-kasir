import 'package:flutter/material.dart';
import '../../../core/security/auth_service.dart';

class PinScreen extends StatefulWidget {
  final AuthService authService;
  final Widget child; // Aplikasi utama yang dilindungi

  const PinScreen({super.key, required this.authService, required this.child});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  String _enteredPin = '';
  bool _isSetupMode = false;
  String _firstPinForSetup = '';
  
  @override
  void initState() {
    super.initState();
    _isSetupMode = !widget.authService.hasPin;
  }

  void _onNumPadTap(String num) {
    if (_enteredPin.length < 6) {
      setState(() {
        _enteredPin += num;
      });
      
      if (_enteredPin.length == 6) {
        _processPin();
      }
    }
  }

  void _onDeleteTap() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      });
    }
  }

  void _processPin() {
    if (_isSetupMode) {
      if (_firstPinForSetup.isEmpty) {
        // Tahap 1: Masukkan PIN Baru
        setState(() {
          _firstPinForSetup = _enteredPin;
          _enteredPin = '';
        });
      } else {
        // Tahap 2: Konfirmasi PIN Baru
        if (_firstPinForSetup == _enteredPin) {
          _showRecoverySetupDialog();
        } else {
          _showError('PIN tidak cocok. Ulangi kembali.');
          setState(() {
            _firstPinForSetup = '';
            _enteredPin = '';
          });
        }
      }
    } else {
      // Mode Login: Verifikasi PIN
      if (widget.authService.verifyPin(_enteredPin)) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => widget.child),
        );
      } else {
        _showError('PIN Salah!');
        setState(() { _enteredPin = ''; });
      }
    }
  }

  void _showRecoverySetupDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Buat Frasa Pemulihan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Jika Anda lupa PIN, frasa rahasia ini adalah satu-satunya cara untuk meresetnya. Simpan baik-baik!'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Misal: nama hewan peliharaan pertama',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                await widget.authService.setupPin(_firstPinForSetup, controller.text);
                if (mounted) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => widget.child));
                }
              }
            },
            child: const Text('Simpan & Masuk'),
          ),
        ],
      ),
    );
  }

  void _showRecoveryLoginDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pemulihan Akses'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Masukkan Frasa Pemulihan Anda',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (widget.authService.verifyRecoveryPhrase(controller.text)) {
                await widget.authService.resetSecurity();
                if (mounted) {
                  Navigator.pop(context); // Tutup dialog
                  setState(() {
                    _isSetupMode = true;
                    _firstPinForSetup = '';
                    _enteredPin = '';
                  });
                  _showError('Keamanan direset. Silakan buat PIN baru.');
                }
              } else {
                Navigator.pop(context);
                _showError('Frasa Pemulihan Salah!');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reset PIN', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    String title = _isSetupMode 
        ? (_firstPinForSetup.isEmpty ? 'BUAT PIN BARU (6 DIGIT)' : 'KONFIRMASI PIN BARU')
        : 'MASUKKAN PIN AKSES';

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Warna Dark Navy Premium
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 60, color: Colors.blueAccent),
            const SizedBox(height: 20),
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2)),
            const SizedBox(height: 30),
            
            // Indikator Titik PIN
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                bool isFilled = index < _enteredPin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFilled ? Colors.blueAccent : Colors.transparent,
                    border: Border.all(color: Colors.blueAccent, width: 2),
                  ),
                );
              }),
            ),
            const SizedBox(height: 50),
            
            // Numpad Custom
            _buildNumPad(),
            
            const SizedBox(height: 30),
            if (!_isSetupMode)
              TextButton(
                onPressed: _showRecoveryLoginDialog,
                child: const Text('Lupa PIN?', style: TextStyle(color: Colors.white54)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumPad() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: ['1', '2', '3'].map(_buildNumButton).toList()),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: ['4', '5', '6'].map(_buildNumButton).toList()),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: ['7', '8', '9'].map(_buildNumButton).toList()),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 70), // Spacer
              _buildNumButton('0'),
              SizedBox(
                width: 70,
                height: 70,
                child: IconButton(
                  onPressed: _onDeleteTap,
                  icon: const Icon(Icons.backspace_outlined, color: Colors.white, size: 30),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumButton(String num) {
    return InkWell(
      onTap: () => _onNumPadTap(num),
      customBorder: const CircleBorder(),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.1),
        ),
        child: Center(
          child: Text(num, style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
