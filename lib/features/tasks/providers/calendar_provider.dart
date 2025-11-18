// provider.dart
// Provider untuk mengelola state kalender: focused/selected day, events, dan operasi CRUD sederhana.
// Taruh file ini di: lib/features/tasks/providers/calendar_provider.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

// Model Event sederhana
class Event {
  String title;
  TimeOfDay time;
  bool done;

  Event({required this.title, required this.time, this.done = false});

  @override
  String toString() => title;
}

class CalendarProvider extends ChangeNotifier {
  // State kalender
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  // Map tanggal (tanpa waktu) -> list event
  final Map<DateTime, List<Event>> _events = {};

  // Konstruktor: inisialisasi locale & contoh event
  CalendarProvider() {
    _initLocale();
    _initSampleEvents();
  }

  // Inisialisasi lokal untuk formatting tanggal (id_ID)
  Future<void> _initLocale() async {
    await initializeDateFormatting('id_ID', null);
    Intl.defaultLocale = 'id_ID';
    notifyListeners();
  }

  // Helper: strip jam/menit/detik agar konsisten sebagai key
  DateTime _strip(DateTime d) => DateTime(d.year, d.month, d.day);

  // Ambil events untuk hari tertentu
  List<Event> eventsOf(DateTime day) => _events[_strip(day)] ?? [];

  // Getter untuk events hari yang dipilih
  List<Event> get selectedEvents => eventsOf(selectedDay);

  // Pilih hari
  void selectDay(DateTime day, {DateTime? newFocused}) {
    selectedDay = _strip(day);
    focusedDay = newFocused ?? focusedDay;
    notifyListeners();
  }

  // Tambah event pada hari yang dipilih (atau day param jika disediakan)
  void addEvent({
    required String title,
    required TimeOfDay time,
    DateTime? day,
  }) {
    final key = _strip(day ?? selectedDay);
    final list = _events[key] ?? [];
    list.add(Event(title: title, time: time));
    _events[key] = list;
    notifyListeners();
  }

  // Toggle done untuk event di hari tertentu (index)
  void toggleDone(DateTime day, int index) {
    final key = _strip(day);
    final list = _events[key];
    if (list == null || index < 0 || index >= list.length) return;
    list[index].done = !list[index].done;
    notifyListeners();
  }

  // Hapus event
  void removeEvent(DateTime day, int index) {
    final key = _strip(day);
    final list = _events[key];
    if (list == null || index < 0 || index >= list.length) return;
    list.removeAt(index);
    if (list.isEmpty) _events.remove(key);
    notifyListeners();
  }

  // Contoh data awal supaya UI tidak kosong
  void _initSampleEvents() {
    final today = _strip(DateTime.now());
    _events[today] = [
      Event(
        title: 'Mengajar TRPL 3C Malam',
        time: const TimeOfDay(hour: 20, minute: 30),
      ),
    ];

    final plusTwo = _strip(DateTime.now().add(const Duration(days: 2)));
    _events[plusTwo] = [
      Event(
        title: 'Review Tugas Database',
        time: const TimeOfDay(hour: 13, minute: 0),
      ),
      Event(
        title: 'Meeting Tim PBL',
        time: const TimeOfDay(hour: 16, minute: 0),
      ),
    ];

    notifyListeners();
  }
}
