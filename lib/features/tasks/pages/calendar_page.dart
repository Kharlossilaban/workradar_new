// lib/features/tasks/pages/tasks_page.dart
// Calendar page (diperbaiki) — gunakan bersama calendar_widget.dart & calendar_provider.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:workradar/features/tasks/providers/calendar_provider.dart';
import 'package:workradar/features/tasks/widgets/calendar_widget.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  void initState() {
    super.initState();
    // provider inisialisasi sample data sendiri di konstruktor
  }

  // Dialog sederhana untuk menambah event
  Future<void> _showAddDialog(
    BuildContext context,
    CalendarProvider prov,
  ) async {
    final titleCtrl = TextEditingController();
    TimeOfDay chosen = const TimeOfDay(hour: 12, minute: 0);
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Buat Tugas Baru',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Judul'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Masukkan judul' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 18,
                    color: kTextSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final t = await showTimePicker(
                          context: context,
                          initialTime: chosen,
                        );
                        if (t != null) {
                          chosen = t;
                          // rebuild dialog content
                          (context as Element).markNeedsBuild();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(chosen.format(context)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                prov.addEvent(title: titleCtrl.text.trim(), time: chosen);
                Navigator.pop(context);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<CalendarProvider>(context, listen: true);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimary,
        onPressed: () => _showAddDialog(context, prov),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final available = constraints.maxHeight;
            // adjust proportion if needed (0.56 -> smaller to avoid overflow)
            final topMax = available * 0.56;

            return Column(
              children: [
                // Top area: background + header + calendar (bounded height)
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: topMax),
                  child: Stack(
                    children: [
                      // background image — pastikan path sesuai pubspec.yaml
                      // ganti dengan Image.asset agar bisa menampilkan errorBuilder kalau asset hilang
                      Positioned.fill(
                        child: Image.asset(
                          'assets/calendar.png', // pastikan path ini sama dengan pubspec.yaml
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          errorBuilder: (context, error, stackTrace) {
                            // tampilkan placeholder agar kita tahu asset tidak ditemukan
                            debugPrint(
                              'Gagal memuat asset calendar.png: $error',
                            );
                            return Container(color: Colors.grey.shade200);
                          },
                        ),
                      ),

                      // overlay header + calendar
                      Positioned.fill(
                        child: Column(
                          children: [
                            const SizedBox(height: 28),
                            CalendarHeader(
                              focused: prov.focusedDay,
                              onPrev: () {
                                final prev = DateTime(
                                  prov.focusedDay.year,
                                  prov.focusedDay.month - 1,
                                  1,
                                );
                                prov.focusedDay = prev;
                                prov.selectDay(
                                  prov.selectedDay,
                                  newFocused: prev,
                                );
                              },
                              onNext: () {
                                final next = DateTime(
                                  prov.focusedDay.year,
                                  prov.focusedDay.month + 1,
                                  1,
                                );
                                prov.focusedDay = next;
                                prov.selectDay(
                                  prov.selectedDay,
                                  newFocused: next,
                                );
                              },
                              onToggle: () =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Toggle calendar view'),
                                    ),
                                  ),
                            ),

                            // Calendar card area — expands to remaining of topMax
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: TableCalendar<Event>(
                                    firstDay: DateTime.utc(2000, 1, 1),
                                    lastDay: DateTime.utc(2100, 12, 31),
                                    focusedDay: prov.focusedDay,
                                    locale: 'id_ID',
                                    startingDayOfWeek: StartingDayOfWeek.monday,
                                    selectedDayPredicate: (day) =>
                                        day.year == prov.selectedDay.year &&
                                        day.month == prov.selectedDay.month &&
                                        day.day == prov.selectedDay.day,
                                    headerVisible: false,
                                    eventLoader: (day) => prov.eventsOf(day),
                                    daysOfWeekStyle: const DaysOfWeekStyle(
                                      weekdayStyle: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: kTextSecondary,
                                      ),
                                      weekendStyle: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: kTextSecondary,
                                      ),
                                    ),
                                    calendarBuilders: CalendarBuilders(
                                      defaultBuilder:
                                          (context, day, focusedDay) =>
                                              calendarBuilderFallback(
                                                context,
                                                day,
                                                prov,
                                              ),
                                      todayBuilder:
                                          (context, day, focusedDay) =>
                                              calendarBuilderFallback(
                                                context,
                                                day,
                                                prov,
                                              ),
                                      selectedBuilder:
                                          (context, day, focusedDay) =>
                                              calendarBuilderFallback(
                                                context,
                                                day,
                                                prov,
                                              ),
                                      markerBuilder: (context, date, events) {
                                        if (events.isNotEmpty) {
                                          return Positioned(
                                            bottom: 6,
                                            left: 0,
                                            right: 0,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 6,
                                                  height: 6,
                                                  decoration:
                                                      const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: kPrimary,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                    onDaySelected: (selectedDay, focusedDay) {
                                      prov.selectDay(
                                        selectedDay,
                                        newFocused: focusedDay,
                                      );
                                    },
                                    onPageChanged: (focusedDay) {
                                      prov.focusedDay = focusedDay;
                                      prov.selectDay(
                                        prov.selectedDay,
                                        newFocused: focusedDay,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom area: events list
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: prov.selectedEvents.isEmpty
                        ? Center(
                            child: Text(
                              'Tidak ada acara untuk hari ini',
                              style: const TextStyle(
                                fontSize: 14,
                                color: kTextSecondary,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(top: 12, bottom: 80),
                            itemCount: prov.selectedEvents.length,
                            itemBuilder: (context, index) {
                              final ev = prov.selectedEvents[index];
                              return EventCard(
                                event: ev,
                                day: prov.selectedDay,
                                index: index,
                                onToggle: (i) =>
                                    prov.toggleDone(prov.selectedDay, i),
                                onDelete: (i) =>
                                    prov.removeEvent(prov.selectedDay, i),
                              );
                            },
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // helper untuk merender sel kalender (dipanggil oleh CalendarBuilders)
  Widget calendarBuilderFallback(
    BuildContext context,
    DateTime day,
    CalendarProvider prov,
  ) {
    final now = DateTime.now();
    final isSelected =
        (day.year == prov.selectedDay.year &&
        day.month == prov.selectedDay.month &&
        day.day == prov.selectedDay.day);
    final isToday =
        (day.year == now.year && day.month == now.month && day.day == now.day);
    final hasEvents = prov.eventsOf(day).isNotEmpty;

    return Stack(
      children: [
        Center(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? kPrimary : Colors.transparent,
              border: isToday && !isSelected
                  ? Border.all(color: kPrimary, width: 1.5)
                  : null,
            ),
            padding: const EdgeInsets.all(6),
            child: Text(
              '${day.day}',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : kTextPrimary,
              ),
            ),
          ),
        ),
        if (hasEvents)
          Positioned(
            bottom: 6,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: kPrimary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
