// lib/features/tasks/pages/calendar_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import 'package:workradar/features/tasks/widgets/calendar_widget.dart';
import 'package:workradar/features/tasks/providers/calendar_provider.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with TickerProviderStateMixin {
  // internal state: apakah dalam mode Month (true) atau Week (false)
  bool _isMonth = true;
  CalendarFormat get _calendarFormat =>
      _isMonth ? CalendarFormat.month : CalendarFormat.week;

  // tinggi calendar (di-animate) — sesuaikan jika ingin lebih besar/kecil
  double get _monthHeight => 300;
  double get _weekHeight => 120;

  final Color _accent = const Color(0xFF6EA8FF);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CalendarProvider>(context);
    String monthLabel = DateFormat.yMMMM('id_ID').format(provider.focusedDay);

    // Hitung jarak agar panah tepat di bawah status bar (ikon baterai/wifi)
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final double arrowTop = statusBarHeight + 8;
    final double arrowHeight = 20;
    final double contentTopPadding = arrowTop + arrowHeight + 6;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const SizedBox.shrink(),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Konten utama: digeser ke bawah agar tidak tertutup panah
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(top: contentTopPadding),
                child: Column(
                  children: [
                    // Row: chevrons left / monthLabel / chevron right
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 6,
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: () {
                              setState(() {
                                if (_isMonth) {
                                  final prev = DateTime(
                                    provider.focusedDay.year,
                                    provider.focusedDay.month - 1,
                                    1,
                                  );
                                  provider.focusedDay = prev;
                                  provider.selectDay(
                                    provider.selectedDay,
                                    newFocused: prev,
                                  );
                                } else {
                                  final prevWeek = provider.focusedDay.subtract(
                                    const Duration(days: 7),
                                  );
                                  provider.focusedDay = prevWeek;
                                  provider.selectDay(
                                    provider.selectedDay,
                                    newFocused: prevWeek,
                                  );
                                }
                              });
                            },
                          ),

                          // month label centered
                          Expanded(
                            child: Center(
                              child: Text(
                                monthLabel,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(221, 12, 12, 12),
                                ),
                              ),
                            ),
                          ),

                          // right chevron
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () {
                              setState(() {
                                if (_isMonth) {
                                  final next = DateTime(
                                    provider.focusedDay.year,
                                    provider.focusedDay.month + 1,
                                    1,
                                  );
                                  provider.focusedDay = next;
                                  provider.selectDay(
                                    provider.selectedDay,
                                    newFocused: next,
                                  );
                                } else {
                                  final nextWeek = provider.focusedDay.add(
                                    const Duration(days: 7),
                                  );
                                  provider.focusedDay = nextWeek;
                                  provider.selectDay(
                                    provider.selectedDay,
                                    newFocused: nextWeek,
                                  );
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    // Animated calendar area: height changes when toggled
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: SizedBox(
                          height: _isMonth ? _monthHeight : _weekHeight,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: const DecorationImage(
                                image: AssetImage('assets/calendar.png'),
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                colorFilter: ColorFilter.mode(
                                  Color.fromRGBO(0, 0, 0, 0.54),
                                  BlendMode.darken,
                                ),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      color: const Color.fromRGBO(
                                        255,
                                        255,
                                        255,
                                        0.18,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TableCalendar<Event>(
                                      firstDay: DateTime.utc(2010, 1, 1),
                                      lastDay: DateTime.utc(2035, 12, 31),
                                      focusedDay: provider.focusedDay,
                                      calendarFormat: _calendarFormat,
                                      headerVisible: false,
                                      eventLoader: (day) =>
                                          provider.eventsOf(day),
                                      startingDayOfWeek:
                                          StartingDayOfWeek.sunday,
                                      selectedDayPredicate: (day) =>
                                          isSameDay(provider.selectedDay, day),
                                      onDaySelected: (selectedDay, focusedDay) {
                                        provider.selectDay(
                                          selectedDay,
                                          newFocused: focusedDay,
                                        );
                                      },
                                      onPageChanged: (focusedDay) {
                                        provider.focusedDay = focusedDay;
                                      },
                                      onFormatChanged: (format) {
                                        // Jika user mengubah format internal (swipe), sinkronkan _isMonth
                                        setState(() {
                                          _isMonth =
                                              format == CalendarFormat.month;
                                        });
                                      },
                                      calendarStyle: CalendarStyle(
                                        todayDecoration: BoxDecoration(
                                          color: _accent,
                                          shape: BoxShape.circle,
                                        ),
                                        selectedDecoration: BoxDecoration(
                                          color: _accent,
                                          shape: BoxShape.circle,
                                        ),
                                        markerDecoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        markersMaxCount: 3,
                                        defaultTextStyle: const TextStyle(
                                          color: Colors.black87,
                                        ),
                                      ),
                                      calendarBuilders: CalendarBuilders<Event>(
                                        markerBuilder: (context, date, events) {
                                          if (events.isEmpty)
                                            return const SizedBox();
                                          return Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: List.generate(
                                                events.length > 3
                                                    ? 3
                                                    : events.length,
                                                (i) => Container(
                                                  margin:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 1,
                                                      ),
                                                  width: 6,
                                                  height: 6,
                                                  decoration: BoxDecoration(
                                                    color: i == 0
                                                        ? Colors.white
                                                        : Colors.white70,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Events header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: const [
                          Text(
                            'Tugas Hari ini',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(child: Divider()),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Event list
                    Expanded(
                      child: provider.selectedEvents.isEmpty
                          ? Center(
                              child: Text(
                                'Tidak ada event di tanggal ${DateFormat.yMMMd().format(provider.selectedDay)}',
                                style: const TextStyle(color: Colors.black54),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 8,
                              ),
                              itemCount: provider.selectedEvents.length,
                              itemBuilder: (context, index) {
                                final ev = provider.selectedEvents[index];
                                return EventCard(
                                  event: ev,
                                  day: provider.selectedDay,
                                  index: index,
                                  onToggle: (i) => provider.toggleDone(
                                    provider.selectedDay,
                                    i,
                                  ),
                                  onDelete: (i) => provider.removeEvent(
                                    provider.selectedDay,
                                    i,
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),

            // Panah vertikal: tepat di bawah status bar, pojok kanan
            Positioned(
              top: arrowTop,
              right: 12,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () {
                    setState(() {
                      _isMonth = !_isMonth;
                    });
                  },
                  child: Container(
                    width: 36,
                    height: arrowHeight,
                    alignment: Alignment.center,
                    child: Icon(
                      _isMonth
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 28,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // FAB & bubble (unchanged)
      floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Positioned(
            right: 12,
            bottom: 100,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF3C253),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Add your first task',
                style: TextStyle(
                  color: Color(0xFF5B4F3F),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              provider.addEvent(title: 'New event', time: TimeOfDay.now());
            },
            backgroundColor: _accent,
            child: const Icon(Icons.add),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
