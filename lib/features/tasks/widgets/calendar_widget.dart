// lib/features/tasks/widgets/calendar_widgets.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workradar/features/tasks/providers/calendar_provider.dart';

// Warna & typografi global untuk widget ini
const Color kPrimary = Color(0xFF00897B);
const Color kTextPrimary = Color(0xFF0F1724);
const Color kTextSecondary = Color(0xFF6B7280);
const Color kDivider = Color(0xFFE5E7EB);

/// CalendarHeader -- kept minimal; vertical toggle is handled in page
class CalendarHeader extends StatelessWidget {
  final DateTime focused;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final VoidCallback? onToggle;

  const CalendarHeader({
    super.key,
    required this.focused,
    this.onPrev,
    this.onNext,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    // kept compact in case other pages use it; otherwise header is in page
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
      child: Row(
        children: [
          IconButton(onPressed: onPrev, icon: const Icon(Icons.chevron_left)),
          Expanded(
            child: Center(
              child: Text(
                DateFormat.yMMMM('id_ID').format(focused),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          IconButton(onPressed: onNext, icon: const Icon(Icons.chevron_right)),
        ],
      ),
    );
  }
}

/// Weekday label widget (public, const constructor so it can used in const lists)
class WeekDayLabel extends StatelessWidget {
  final String label;
  const WeekDayLabel({required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, color: kTextSecondary),
        ),
      ),
    );
  }
}

/// EventCard sesuai spesifikasi: checkbox circle (toggle), title, divider, meta row
class EventCard extends StatelessWidget {
  final Event event;
  final DateTime day;
  final int index;
  final void Function(int) onToggle;
  final void Function(int) onDelete;

  const EventCard({
    super.key,
    required this.event,
    required this.day,
    required this.index,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('EEE, d MMM yyyy', 'id_ID').format(day);
    final timeLabel = event.time.format(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                // left circle checkbox
                GestureDetector(
                  onTap: () => onToggle(index),
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: event.done ? kPrimary : Colors.transparent,
                      border: Border.all(
                        color: event.done ? kPrimary : kTextSecondary,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: event.done
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    event.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: kTextPrimary,
                    ),
                  ),
                ),
                // optional delete button
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: kTextSecondary,
                  ),
                  onPressed: () => onDelete(index),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(color: kDivider, height: 1),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: kTextSecondary),
                const SizedBox(width: 8),
                Text(
                  timeLabel,
                  style: const TextStyle(fontSize: 12, color: kTextSecondary),
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: kTextSecondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    dateLabel,
                    style: const TextStyle(fontSize: 12, color: kTextSecondary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
