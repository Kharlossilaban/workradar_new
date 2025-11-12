// lib/features/tasks/widgets/message_bubble.dart
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  const MessageBubble({
    required this.text,
    required this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Row(
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 220),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                height: 1.25,
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(-2, 12),
            child: CustomPaint(
              painter: _TrianglePainter(color: backgroundColor),
              child: const SizedBox(width: 20, height: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.8, size.height * 0.2)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
