// lib/features/tasks/pages/tasks_page.dart
import 'package:flutter/material.dart';
import 'package:workradar/features/tasks/widgets/task_input_wigdet.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  static const List<String> exampleCategories = [
    'Semua',
    'Kerja',
    'Pribadi',
    'Ulang tahun',
    'Latihan',
    'Belanja',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hari ini'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: Stack(
        children: [
          // main content
          Padding(
            padding: const EdgeInsets.only(bottom: 220),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: const [
                SizedBox(height: 8),
                Text(
                  'Platform terbaik untuk membuat daftar tugas',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 300),
              ],
            ),
          ),

          // bottom aligned input
          Align(
            alignment: Alignment.bottomCenter,
            child: TaskInputWidget(
              categories: exampleCategories,
              onPickDate: (ctx) async {
                final now = DateTime.now();
                return await showDatePicker(
                  context: ctx,
                  initialDate: now,
                  firstDate: DateTime(now.year - 2),
                  lastDate: DateTime(now.year + 2),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
