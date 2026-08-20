import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class AsyncActionButton extends StatefulWidget {
  final Future<void> Function() onPressed;
  final String label;

  const AsyncActionButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  State<AsyncActionButton> createState() => _AsyncActionButtonState();
}

class _AsyncActionButtonState extends State<AsyncActionButton> {
  bool _isLoading = false;

  void _handleTap() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      await widget.onPressed();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleTap,
      child: _isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(widget.label),
    );
  }
}

void main() {
  testWidgets('Mencegah panggilan ganda saat tombol ditekan berulang kali secara brutal (Spam Click)', (WidgetTester tester) async {
    int executionCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AsyncActionButton(
            label: 'Simpan',
            onPressed: () async {
              executionCount++;
              await Future.delayed(const Duration(milliseconds: 500));
            },
          ),
        ),
      ),
    );

    final buttonFinder = find.byType(AsyncActionButton);

    await tester.tap(buttonFinder);
    await tester.tap(buttonFinder);
    await tester.tap(buttonFinder);
    await tester.tap(buttonFinder);
    await tester.tap(buttonFinder);

    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Menyelesaikan delay asinkron
    await tester.pumpAndSettle();

    expect(executionCount, equals(1));
  });
}
