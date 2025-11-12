import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dashboard_provider.dart';
import 'dashboard_widgets.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardProvider(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 14),
                FilterChipsRow(
                  selectedIndex: provider.selectedFilter,
                  onSelected: provider.setFilter,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: const SizedBox.shrink(),
                  ),
                ),
                const SizedBox(height: 72),
              ],
            ),

            Positioned(
              left: 20,
              bottom: 88,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SpeechBubble(
                    text: 'Klik di sini untuk membuat tugas pertamamu.',
                    maxWidth: 260,
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      // placeholder for FAB action
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: kPrimaryTealDark,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: CustomBottomNav(
                currentIndex: provider.bottomIndex,
                onTap: provider.setBottomIndex,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
