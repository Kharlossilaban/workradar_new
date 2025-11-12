// lib/features/tasks/widgets/category_page.dart
import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  final String title;
  const CategoryPage({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.note_alt_rounded,
                    size: 86,
                    color: Colors.teal.shade200,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title == 'Semua' ? 'Semua Tugas' : 'Tugas: $title',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Klik tombol + untuk menambahkan tugas baru di kategori ini.',
                    style: TextStyle(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
