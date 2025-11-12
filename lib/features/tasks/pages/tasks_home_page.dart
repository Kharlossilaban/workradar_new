// lib/features/tasks/pages/tasks_home_page.dart
import 'package:flutter/material.dart';
import 'package:workradar/utils/theme.dart';
import 'package:workradar/features/tasks/widgets/message_bubble.dart';
import 'package:workradar/features/tasks/widgets/bottom_nav.dart';
import 'package:workradar/features/tasks/widgets/category_page.dart';

class TasksHomePage extends StatefulWidget {
  const TasksHomePage({super.key});

  @override
  State<TasksHomePage> createState() => _TasksHomePageState();
}

class _TasksHomePageState extends State<TasksHomePage> {
  final List<String> categories = [
    'Semua',
    'Kerja',
    'Pribadi',
    'Ulang Tahun',
    'Latihan',
    'Belanja',
    'Penting',
    'Reminder',
  ];

  int selectedCategoryIndex = 0;
  int selectedBottomIndex = 0;
  final PageController _pageController = PageController();

  void _onSelectCategory(int index) {
    setState(() => selectedCategoryIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() => selectedCategoryIndex = index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppTheme.primaryTeal;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Top chips area
                SizedBox(
                  height: 88,
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 44,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final bool selected =
                                index == selectedCategoryIndex;
                            return GestureDetector(
                              onTap: () => _onSelectCategory(index),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 220),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? primary
                                      : Colors.teal.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: selected
                                      ? [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    categories[index],
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: selected
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Page content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return CategoryPage(title: categories[index]);
                    },
                  ),
                ),
              ],
            ),

            // Message bubble above FAB
            Positioned(
              right: 96,
              bottom: 86 + (bottomPadding > 0 ? bottomPadding : 0),
              child: MessageBubble(
                text: 'Klik di sini untuk\nmembuat tugas pertamamu.',
                backgroundColor: primary,
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // aksi create new task -> nanti hubungkan ke page create task
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Create new task (simulasi)')),
          );
        },
        backgroundColor: AppTheme.primaryTeal,
        child: const Icon(Icons.add, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      bottomNavigationBar: BottomNav(
        selectedIndex: selectedBottomIndex,
        onTap: (i) => setState(() => selectedBottomIndex = i),
        activeColor: AppTheme.primaryTeal,
      ),
    );
  }
}
