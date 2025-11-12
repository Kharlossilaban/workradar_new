import 'dart:math';
import 'package:flutter/material.dart';

const Color kPrimaryTeal = Color(0xFF3ECFC7);
const Color kPrimaryTealDark = Color(0xFF1E8E86);
const double _kHorizontalPadding = 16.0;

/// FilterChipsRow — sekarang scrollable horizontal dan aman untuk banyak chip.
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
          // area chip bisa discroll horizontal — ambil ruang sisa dengan Expanded
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
                  // tambahan chip contoh:
                  // _buildChip('Proyek', selectedIndex == 4, () => onSelected(4)),
                ],
              ),
            ),
          ),

          // icon menu tetap di ujung kanan
          IconButton(
            onPressed: () {
              // implement kalau perlu
            },
            icon: const Icon(Icons.more_vert, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

/// Bubble pesan dengan tail kecil
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

/// Bottom navigation simplified
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
    int index,
    IconData icon, {
    String? assetName,
  }) {
    final color = index == currentIndex
        ? kPrimaryTealDark
        : Colors.grey.shade400;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: SizedBox(
          height: 56,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              assetName == null
                  ? Icon(icon, color: color)
                  : Image.asset(assetName, width: 22, height: 22, color: color),
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
          _navItem(context, 0, Icons.home_rounded),
          _navItem(context, 1, Icons.calendar_today_outlined),
          _navItem(context, 2, Icons.emoji_events_outlined),
          _navItem(context, 3, Icons.person_outline),
        ],
      ),
    );
  }
}
