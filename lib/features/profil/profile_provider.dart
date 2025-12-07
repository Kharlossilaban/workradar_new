import 'package:flutter/material.dart';

class ProfilProvider extends ChangeNotifier {
  // Filter dropdown pilihan
  List<String> filters = [
    'Beban Kerja Harian',
    'Beban Kerja Mingguan',
    'Beban Kerja Bulanan',
  ];
  String selectedFilter = 'Beban Kerja Harian';

  // Data beban kerja contoh per hari
  Map<String, int> get workloadData {
    // Bisa dikembangkan dengan logika berdasarkan selectedFilter
    return {
      'Sen': 20,
      'Sel': 9,
      'Rab': 13,
      'Kam': 15,
      'Jum': 10,
      'Sab': 8,
      'Min': 10,
    };
  }

  // Tambahkan metode untuk mengubah state jika diperlukan
  void setSelectedFilter(String filter) {
    selectedFilter = filter;
    notifyListeners(); // Panggil ini untuk update UI
  }
}
