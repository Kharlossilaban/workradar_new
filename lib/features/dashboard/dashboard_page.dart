// dashboard_page.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// hanya impor widgets & constants dari file widgets
import 'dashboard_widgets.dart';

// halaman tugas (pastikan path sesuai proyekmu)
import 'package:workradar/features/tasks/pages/tasks_page.dart';
import 'dashboard_provider.dart';

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
    // ambil provider
    final provider = Provider.of<DashboardProvider>(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    // konversi selectedFilter ke enum dengan aman
    final int idx = provider.selectedFilter;
    final int safeIdx = (idx < 0 || idx >= TaskCategory.values.length)
        ? 0
        : idx;
    final TaskCategory category = TaskCategory.values[safeIdx];

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                Expanded(child: CenterImagePage(category: category)),
                const SizedBox(height: 72),
              ],
            ),

            // FAB + bubble: fixed pojok kanan bawah
            Builder(
              builder: (ctx) {
                final w = MediaQuery.of(ctx).size.width;
                final fabSize = max(48.0, min(w * 0.14, 64.0));
                final bottomPosition = 72.0 + 12.0 + bottomInset;
                return Positioned(
                  right: 16,
                  bottom: bottomPosition,
                  child: FloatingHintWidget(fabSize: fabSize),
                );
              },
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

/// A small wrapper widget defined here to avoid duplicating big class in widgets file.
/// It uses constants from dashboard_widgets.dart.
class FloatingHintWidget extends StatefulWidget {
  final double fabSize;
  const FloatingHintWidget({super.key, required this.fabSize});

  @override
  State<FloatingHintWidget> createState() => _FloatingHintWidgetState();
}

class _FloatingHintWidgetState extends State<FloatingHintWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fabScale;
  late final Animation<double> _haloScale;
  late final Animation<double> _haloOpacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _fabScale = Tween<double>(
      begin: 0.96,
      end: 1.08,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _haloScale = Tween<double>(
      begin: 0.9,
      end: 1.35,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _haloOpacity = Tween<double>(
      begin: 0.28,
      end: 0.02,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _openTasks() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => TasksPage()));
  }

  @override
  Widget build(BuildContext context) {
    // Warna disesuaikan ke palet gambar (kuning bubble dan biru FAB)
    final bubbleColor = const Color(0xFFF3C253); // kuning/orange
    final bubbleTextColor = const Color(0xFF5B4F3F); // cokelat gelap untuk teks
    final tailSize = 14.0;
    final fabSize = widget.fabSize;
    final haloOuter = fabSize * 1.9;

    // warna FAB biru mirip gambar
    const innerFabColor = Color(0xFF6EA8FF);
    const haloColor = Color(0xFF6EA8FF);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Bubble: gunakan Stack agar tail (CustomPaint) bisa diposisikan presisi
        ConstrainedBox(
          // ukuran bubble diperkecil: maxWidth lebih kecil, minWidth juga dipadatkan
          constraints: const BoxConstraints(maxWidth: 320, minWidth: 160),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                // padding dikurangi agar keseluruhan kotak lebih compact
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(30, 0, 0, 0),
                      blurRadius: 8,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Text(
                  'Klik di sini untuk membuat tugas pertamamu.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: bubbleTextColor,
                    fontSize: 16, // dikurangi dari 20 jadi 16
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
              ),

              // tail segitiga di pojok kanan bawah bubble (ukurannya disesuaikan)
              Positioned(
                right: 14,
                bottom: -10, // disesuaikan agar tail menempel rapi ke bubble
                child: CustomPaint(
                  size: const Size(28, 22), // ukuran tail diperkecil
                  painter: _TrianglePainter(color: bubbleColor),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // FAB + halo
        AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // halo luar
                Transform.scale(
                  scale: _haloScale.value,
                  child: Opacity(
                    opacity: _haloOpacity.value,
                    child: Container(
                      width: haloOuter,
                      height: haloOuter,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: haloColor.withOpacity(0.28),
                      ),
                    ),
                  ),
                ),

                // tombol utama
                Transform.scale(
                  scale: _fabScale.value,
                  child: GestureDetector(
                    onTap: _openTasks,
                    child: Container(
                      width: fabSize,
                      height: fabSize,
                      decoration: BoxDecoration(
                        color: innerFabColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: fabSize * 0.14,
                            offset: Offset(0, fabSize * 0.07),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: fabSize * 0.52,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// Painter untuk ekor bubble (segitiga yang rapi)
class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    // bentuk segitiga mirip tail di gambar: menunjuk ke kanan bawah
    path.moveTo(0, 0);
    path.lineTo(size.width, size.height * 0.45);
    path.lineTo(size.width * 0.28, size.height);
    path.close();
    canvas.drawPath(path, paint);

    // shadow halus di bawah tail supaya depth konsisten
    final shadow = Paint()
      ..color = Colors.black.withOpacity(0.06)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    final shadowPath = Path.from(path)..shift(const Offset(0, 4));
    canvas.drawPath(shadowPath, shadow);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
