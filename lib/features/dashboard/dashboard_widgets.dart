// dashboard_widgets.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const Color kPrimaryTeal = Color(0xFF3ECFC7);
const Color kPrimaryTealDark = Color(0xFF1E8E86);
const double _kHorizontalPadding = 16.0;

/// Enum kategori tugas
enum TaskCategory { semua, kerja, pribadi, ulangTahun }

/// Simple model mapping kategori -> asset & teks.
class CategoryInfo {
  final String assetPath;
  final String title;
  final String subtitle;
  CategoryInfo(this.assetPath, this.title, this.subtitle);
}

final Map<TaskCategory, CategoryInfo> kCategoryInfo = {
  TaskCategory.semua: CategoryInfo(
    'assets/semua.jpg',
    'Semua Tugas',
    'Klik tombol + untuk menambahkan tugas baru di kategori ini.',
  ),
  TaskCategory.kerja: CategoryInfo(
    'assets/kerja.jpg',
    'Tugas Kerja',
    'Organisasikan tugas kerja di sini.',
  ),
  TaskCategory.pribadi: CategoryInfo(
    'assets/pribadi.jpg',
    'Tugas Pribadi',
    'Catat hal-hal pribadi yang harus dilakukan.',
  ),
  TaskCategory.ulangTahun: CategoryInfo(
    'assets/ulang_tahun.jpg',
    'Ulang Tahun',
    'Pengingat acara & hadiah ulang tahun.',
  ),
};

/// FilterChipsRow — scrollable horizontal chips untuk memilih kategori.
class FilterChipsRow extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onSelected;

  const FilterChipsRow({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  Widget _buildChip(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: active ? kPrimaryTeal : Colors.white,
          border: Border.all(color: kPrimaryTeal, width: 1),
          borderRadius: BorderRadius.circular(20),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: kPrimaryTeal.withOpacity(0.14),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : kPrimaryTealDark,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _kHorizontalPadding),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildChip('Semua', selectedIndex == 0, () => onSelected(0)),
                  _buildChip('Kerja', selectedIndex == 1, () => onSelected(1)),
                  _buildChip(
                    'Pribadi',
                    selectedIndex == 2,
                    () => onSelected(2),
                  ),
                  _buildChip(
                    'Ulang Tahun',
                    selectedIndex == 3,
                    () => onSelected(3),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

/// SpeechBubble — petunjuk kecil dekat tombol tambah.
/// NOTE: not const because it uses runtime colors/shade.
class SpeechBubble extends StatelessWidget {
  final String text;
  final double maxWidth;

  const SpeechBubble({super.key, required this.text, this.maxWidth = 260});

  @override
  Widget build(BuildContext context) {
    final bubbleColor = kPrimaryTeal;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Positioned(
          right: -8,
          bottom: 6,
          child: Transform.rotate(
            angle: pi / 4,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// CenterImagePage — area tengah yang berubah sesuai kategori
class CenterImagePage extends StatelessWidget {
  final TaskCategory category;
  const CenterImagePage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final info = kCategoryInfo[category]!;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: Center(
        key: ValueKey(category),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              info.assetPath,
              width: 200,
              height: 200,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                debugPrint('GAGAL memuat asset: ${info.assetPath} -> $error');
                return Icon(
                  Icons.image_not_supported,
                  size: 84,
                  color: Colors.grey.shade400,
                );
              },
            ),
            const SizedBox(height: 18),
            Text(
              info.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                info.subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// CustomBottomNav — bottom navigation sederhana.
class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  Widget _navItem(
    BuildContext context,
    int index, {
    IconData? icon,
    String? assetName,
  }) {
    final color = index == currentIndex
        ? kPrimaryTealDark
        : Colors.grey.shade400;

    Widget iconWidget;
    if (assetName != null) {
      if (assetName.toLowerCase().endsWith('.svg')) {
        iconWidget = SvgPicture.asset(
          assetName,
          width: 22,
          height: 22,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        );
      } else {
        iconWidget = Image.asset(
          assetName,
          width: 22,
          height: 22,
          color: color,
        );
      }
    } else {
      iconWidget = Icon(icon ?? Icons.help_outline, color: color);
    }

    return Expanded(
      child: GestureDetector(
        onTap: () {
          // panggil callback asli (misalnya untuk mengganti selected index)
          onTap(index);

          // debug: cek bahwa klik terdeteksi
          debugPrint('nav item tapped: $index');

          // jika ikon kalender (index 1) -> buka halaman kalender
          // 1) Prefer: gunakan named route '/calendar' yang sudah kita daftarkan di main.dart
          if (index == 1) {
            try {
              Navigator.pushNamed(context, '/calendar');
            } catch (e) {
              debugPrint('Gagal navigasi ke /calendar via named route: $e');
              // 2) Fallback: push langsung ke CalendarPage (aktifkan import CalendarPage & CalendarProvider di atas file)
              // Jika kamu belum menambahkan route '/calendar' di main.dart, uncomment blok di bawah ini:
              /*
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider(
                  create: (_) => CalendarProvider(),
                  child: const CalendarPage(),
                ),
              ),
            );
            */
            }
          }
        },
        child: SizedBox(
          height: 56,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconWidget,
              if (index == currentIndex)
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 24,
                  height: 3,
                  decoration: BoxDecoration(
                    color: kPrimaryTeal,
                    borderRadius: BorderRadius.circular(2),
                  ),
                )
              else
                const SizedBox(height: 9),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // contoh pemakaian: pakai SVG (assetName) atau icon bawaan
          _navItem(context, 0, assetName: 'assets/icons/home.svg'),
          _navItem(context, 1, assetName: 'assets/icons/calendar.svg'),
          _navItem(context, 2, assetName: 'assets/icons/vip.svg'),
          _navItem(context, 3, assetName: 'assets/icons/profile.svg'),
        ],
      ),
    );
  }
}
