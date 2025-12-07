import 'package:flutter/foundation.dart';

/// DashboardProvider: mengelola state untuk bottom navigation, filter kategori,
/// dan status loading. Pastikan logika navigasi (Navigator.push/pop) TIDAK
/// ditempatkan di dalam provider ini — lakukan navigasi di layer UI.
class DashboardProvider extends ChangeNotifier {
  // pilihan filter: 0 = Semua, 1 = Kerja, 2 = Pribadi, 3 = Ulang Tahun (dst.)
  int _selectedFilter = 0;
  int get selectedFilter => _selectedFilter;

  // bottom navigation index
  int _bottomIndex = 0;
  int get bottomIndex => _bottomIndex;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Set filter category. Notifies listeners only when value changes.
  void setFilter(int index) {
    if (_selectedFilter == index) return;
    _selectedFilter = index;
    debugPrint('DashboardProvider: selectedFilter -> $_selectedFilter');
    notifyListeners();
  }

  /// Set bottom navigation index. Notifies listeners only when value changes.
  /// NOTE: jangan lakukan Navigator.push/pop di sini. Provider hanya mengubah state.
  void setBottomIndex(int idx) {
    if (idx < 0) return; // sanity check
    if (_bottomIndex == idx) return;
    _bottomIndex = idx;
    debugPrint('DashboardProvider: bottomIndex -> $_bottomIndex');
    notifyListeners();
  }

  /// Set loading flag.
  void setLoading(bool v) {
    if (_isLoading == v) return;
    _isLoading = v;
    debugPrint('DashboardProvider: isLoading -> $_isLoading');
    notifyListeners();
  }

  /// Reset semua state ke default — berguna untuk testing atau saat logout.
  void reset() {
    _selectedFilter = 0;
    _bottomIndex = 0;
    _isLoading = false;
    debugPrint('DashboardProvider: reset to defaults');
    notifyListeners();
  }
}
