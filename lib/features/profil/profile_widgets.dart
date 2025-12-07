import 'package:flutter/material.dart';

class ProfilWidgets {
  static Widget profileImage() {
    return CircleAvatar(
      radius: 28,
      backgroundImage: AssetImage('assets/mybini.png'),
      // Tambahkan errorBuilder untuk fallback jika gambar gagal
      onBackgroundImageError: (exception, stackTrace) {
        debugPrint('Error loading profile image: $exception');
      },
      // Fallback: gunakan ikon default jika error
      child: Icon(Icons.person, size: 28, color: Colors.grey),
    );
  }

  static Widget proFeatureCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.cyan[400],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Menjadi PRO',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Buka kunci semua fitur PRO',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: const [
                Icon(Icons.star_border, color: Colors.amber, size: 20),
                SizedBox(width: 4),
                Text(
                  'PRO',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget workloadChart(Map<String, int> data) {
    // Visualisasi sederhana menggunakan Bar Chart custom dengan Column
    final days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    final maxVal = data.values.reduce((a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: days.map((day) {
          final val = data[day] ?? 0;
          final barHeight = (val / maxVal) * 120;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 18,
                height: barHeight,
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 6),
              Text(day),
            ],
          );
        }).toList(),
      ),
    );
  }

  static Widget profilBottomNavigationBar(int selectedIndex) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_outlined),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.card_giftcard_outlined),
          label: 'Rewards',
        ),
      ],
      onTap: (index) {
        // Logic bottom nav (bisa dikembangkan)
      },
    );
  }
}
