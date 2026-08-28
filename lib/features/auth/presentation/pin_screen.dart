import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/security/auth_service.dart';

class PinScreen extends StatefulWidget {
  final AuthService authService;
  final Widget child;

  const PinScreen({super.key, required this.authService, required this.child});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> with WidgetsBindingObserver {
  String _enteredPin = '';
  late bool _isSetupMode;
  String _firstPinForSetup = '';
  bool _isUnlocked = false;

  /// Timer untuk lockout countdown
  Timer? _lockoutTimer;
  int _lockoutSecondsLeft = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _isSetupMode = !widget.authService.hasPin;
    if (!_isSetupMode) {
      _refreshLockoutState();
    }
  }

  @override
  void dispose() {
    _lockoutTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Kunci sesi saat aplikasi masuk ke latar belakang
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      if (_isUnlocked && widget.authService.isSessionExpired) {
        setState(() => _isUnlocked = false);
      }
    }
  }

  void _refreshLockoutState() {
    _lockoutTimer?.cancel();
    if (widget.authService.isLockedOut) {
      setState(() {
        _lockoutSecondsLeft = widget.authService.lockoutSecondsRemaining;
      });
      _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        final remaining = widget.authService.lockoutSecondsRemaining;
        if (remaining <= 0) {
          _lockoutTimer?.cancel();
          setState(() => _lockoutSecondsLeft = 0);
        } else {
          setState(() => _lockoutSecondsLeft = remaining);
        }
      });
    }
  }

  void _onNumPadTap(String num) {
    if (widget.authService.isLockedOut) return;
    if (_enteredPin.length < 6) {
      setState(() => _enteredPin += num);
      if (_enteredPin.length == 6) _processPin();
    }
  }

  void _onDeleteTap() {
    if (_enteredPin.isNotEmpty) {
      setState(() =>
          _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1));
    }
  }

  void _processPin() async {
    if (_isSetupMode) {
      _handleSetupMode();
    } else {
      await _handleVerifyMode();
    }
  }

  void _handleSetupMode() async {
    if (_firstPinForSetup.isEmpty) {
      setState(() {
        _firstPinForSetup = _enteredPin;
        _enteredPin = '';
      });
    } else {
      if (_firstPinForSetup == _enteredPin) {
        await widget.authService.setupPin(_enteredPin, 'default_recovery');
        setState(() {
          _isSetupMode = false;
          _isUnlocked = true;
          _enteredPin = '';
          _firstPinForSetup = '';
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('PIN Berhasil Disimpan!')),
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
  }

  Future<void> _handleVerifyMode() async {
    final result = await widget.authService.verifyPinSecure(_enteredPin);
    switch (result) {
      case PinVerifyResult.success:
        setState(() {
          _isUnlocked = true;
          _enteredPin = '';
        });
        break;
      case PinVerifyResult.wrongPin:
        final remaining = widget.authService.remainingAttempts;
        _showError(
          'PIN Salah! Sisa percobaan: $remaining',
          color: Colors.red,
        );
        setState(() => _enteredPin = '');
        break;
      case PinVerifyResult.lockedOut:
        _refreshLockoutState();
        setState(() => _enteredPin = '');
        break;
    }
  }

  void _showError(String message, {Color color = Colors.red}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Cek session timeout saat widget dibangun ulang
    if (_isUnlocked && widget.authService.isSessionExpired) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => setState(() => _isUnlocked = false));
    }

    if (_isUnlocked) {
      widget.authService.updateActivity();
      return widget.child;
    }

    // Setup mode: belum ada PIN
    if (_isSetupMode) return _buildPinPad();

    // Terkunci karena terlalu banyak percobaan gagal
    if (widget.authService.isLockedOut && _lockoutSecondsLeft > 0) {
      return _buildLockedScreen();
    }

    return _buildPinPad();
  }

  Widget _buildLockedScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock, size: 80, color: Colors.red),
            const SizedBox(height: 24),
            const Text(
              'Akses Dikunci',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Terlalu banyak percobaan gagal.\nCoba lagi dalam $_lockoutSecondsLeft detik.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPinPad() {
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
                  ? (_firstPinForSetup.isEmpty
                      ? 'Masukkan 6 Digit PIN'
                      : 'Ulangi 6 Digit PIN')
                  : 'Masukkan PIN untuk melanjutkan',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            if (!_isSetupMode && widget.authService.remainingAttempts < 3)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Sisa percobaan: ${widget.authService.remainingAttempts}',
                  style: const TextStyle(color: Colors.orangeAccent),
                ),
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
                    color: index < _enteredPin.length
                        ? Colors.blueAccent
                        : Colors.grey[800],
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
          style: const TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

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
