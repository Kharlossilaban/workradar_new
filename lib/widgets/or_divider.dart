import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(thickness: 1, color: Colors.grey)),
        const SizedBox(width: 12),
        Text(
          'atau lanjutkan dengan',
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
        const SizedBox(width: 12),
        const Expanded(child: Divider(thickness: 1, color: Colors.grey)),
      ],
    );
  }
}
