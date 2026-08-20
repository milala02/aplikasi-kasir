import 'package:flutter/material.dart';
import '../../../core/security/auth_service.dart';

class PinScreen extends StatefulWidget {
  final AuthService authService;
  final Widget child;

  const PinScreen({super.key, required this.authService, required this.child});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  String _enteredPin = '';
  late bool _isSetupMode;
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

  void _processPin() async {
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
          // Langsung simpan PIN ke SharedPreferences agar hasPin bernilai true
          await widget.authService.setupPin(_enteredPin, 'default_recovery');
          setState(() {
            _isSetupMode = false;
            _enteredPin = '';
            _firstPinForSetup = '';
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('PIN Berhasil Disimpan & Dikonfigurasi!')),
            );
          }
        } else {
          _showError('PIN tidak cocok. Ulangi kembali.');
          setState(() {
            _firstPinForSetup = '';
            _enteredPin = '';
          });
        }
      }
    } else {
      // Mode Verifikasi (Membuka Kunci Sesi)
      if (widget.authService.verifyPin(_enteredPin)) {
        setState(() {
          _enteredPin = '';
        });
        if (Navigator.canPop(context)) {
          Navigator.pop(context); // Kembali ke aplikasi yang terkunci
        }
      } else {
        _showError('PIN Salah!');
        setState(() {
          _enteredPin = '';
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isSetupMode && !Navigator.canPop(context)) {
      return widget.child;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(_isSetupMode 
            ? (_firstPinForSetup.isEmpty ? 'Buat PIN Baru' : 'Konfirmasi PIN Baru') 
            : 'Masukkan PIN Anda'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isSetupMode
                  ? (_firstPinForSetup.isEmpty ? 'Masukkan 6 Digit PIN' : 'Ulangi 6 Digit PIN')
                  : 'Sesi Terkunci - Masukkan PIN',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index < _enteredPin.length ? Colors.blueAccent : Colors.grey[800],
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.2,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  if (index == 9) return const SizedBox.shrink();
                  if (index == 10) return _buildNumButton('0');
                  if (index == 11) {
                    return IconButton(
                      icon: const Icon(Icons.backspace, color: Colors.white),
                      onPressed: _onDeleteTap,
                    );
                  }
                  return _buildNumButton('${index + 1}');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumButton(String num) {
    return InkWell(
      onTap: () => _onNumPadTap(num),
      borderRadius: BorderRadius.circular(40),
      child: Center(
        child: Text(
          num,
          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
