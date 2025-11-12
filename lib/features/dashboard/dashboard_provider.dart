import 'package:flutter/foundation.dart';

class DashboardProvider extends ChangeNotifier {
  // pilihan filter: 0 = Semua, 1 = Kerja, 2 = Pribadi, 3 = Ulang Tahun (dst.)
  int _selectedFilter = 0;
  int get selectedFilter => _selectedFilter;

  // bottom navigation index
  int _bottomIndex = 0;
  int get bottomIndex => _bottomIndex;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setFilter(int index) {
    if (_selectedFilter == index) return;
    _selectedFilter = index;
    notifyListeners();
  }

  void setBottomIndex(int idx) {
    if (_bottomIndex == idx) return;
    _bottomIndex = idx;
    notifyListeners();
  }

  void setLoading(bool v) {
    if (_isLoading == v) return;
    _isLoading = v;
    notifyListeners();
  }
}
