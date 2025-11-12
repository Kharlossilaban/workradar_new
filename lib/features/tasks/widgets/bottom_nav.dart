// lib/features/tasks/widgets/bottom_nav.dart
import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final Color activeColor;

  const BottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(
          top: 6,
          bottom: bottomPadding > 0 ? bottomPadding : 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _BottomItem(
              icon: Icons.home_filled,
              index: 0,
              selectedIndex: selectedIndex,
              onTap: onTap,
              activeColor: activeColor,
            ),
            _BottomItem(
              icon: Icons.calendar_today,
              index: 1,
              selectedIndex: selectedIndex,
              onTap: onTap,
              activeColor: activeColor,
            ),
            const SizedBox(width: 56), // space for FAB
            _BottomItem(
              icon: Icons.workspace_premium,
              index: 2,
              selectedIndex: selectedIndex,
              onTap: onTap,
              activeColor: activeColor,
            ),
            _BottomItem(
              icon: Icons.person_outline,
              index: 3,
              selectedIndex: selectedIndex,
              onTap: onTap,
              activeColor: activeColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  final IconData icon;
  final int index;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final Color activeColor;

  const _BottomItem({
    required this.icon,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool selected = index == selectedIndex;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 56,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 4,
              width: selected ? 26 : 0,
              decoration: BoxDecoration(
                color: selected ? activeColor : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: selected ? 38 : 36,
              height: selected ? 38 : 36,
              decoration: BoxDecoration(
                color: selected
                    ? activeColor.withAlpha((0.12 * 255).round())
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20,
                color: selected ? activeColor : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}
