// lib/features/tasks/widgets/task_input_wigdet.dart
import 'package:flutter/material.dart';
import 'package:workradar/utils/theme.dart';

typedef DatePickerFn = Future<DateTime?> Function(BuildContext context);

class TaskInputWidget extends StatefulWidget {
  final List<String> categories;
  final DatePickerFn? onPickDate;
  final VoidCallback? onSubmit;

  const TaskInputWidget({
    required this.categories,
    this.onPickDate,
    this.onSubmit,
    super.key,
  });

  @override
  State<TaskInputWidget> createState() => _TaskInputWidgetState();
}

class _TaskInputWidgetState extends State<TaskInputWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _selectedCategory = '';
  DateTime? _selectedDate;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.categories.isNotEmpty
        ? widget.categories[0]
        : 'Tidak Ada';

    _focusNode.addListener(() {
      if (mounted) setState(() => _focused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(() {});
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _openCategorySheet() async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) {
        return SizedBox(
          height: 200,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Pilih kategori',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, i) {
                    final c = widget.categories[i];
                    final selected = c == _selectedCategory;
                    return SizedBox(
                      width: 140,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(c),
                        child: Container(
                          height: 44,
                          margin: const EdgeInsets.only(top: 6, bottom: 6),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: selected
                                ? AppTheme.primaryTeal
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            c,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: selected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );

    if (picked != null && picked.isNotEmpty) {
      setState(() => _selectedCategory = picked);
    }
  }

  Future<void> _openDatePicker() async {
    DateTime now = DateTime.now();
    final pick = widget.onPickDate != null
        ? await widget.onPickDate!(context)
        : await showDatePicker(
            context: context,
            initialDate: now,
            firstDate: DateTime(now.year - 2),
            lastDate: DateTime(now.year + 2),
          );

    if (pick != null) setState(() => _selectedDate = pick);
  }

  void _submitTask() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Isi tugas dulu')));
      return;
    }

    final dateLabel = _selectedDate != null
        ? ' | ${_selectedDate!.toLocal().toString().split(' ')[0]}'
        : '';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Task: "$text" • $_selectedCategory$dateLabel')),
    );

    _controller.clear();
    _focusNode.unfocus();
    widget.onSubmit?.call();
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppTheme.primaryTeal;

    // AnimatedPadding agar widget otomatis naik ketika keyboard muncul
    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: Material(
          color: Colors.white,
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Row pertama: textfield compact + tombol kirim bundar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      // Tap area atau TextField (lihat komentar)
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // jika belum fokus, fokuskan field agar keyboard muncul
                            if (!_focused) {
                              FocusScope.of(context).requestFocus(_focusNode);
                            }
                          },
                          child: AbsorbPointer(
                            absorbing: false,
                            child: TextField(
                              focusNode: _focusNode,
                              controller: _controller,
                              decoration: const InputDecoration(
                                hintText: 'Masukkan tugas baru di sini',
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // tombol kirim bundar (ikon panah)
                      Material(
                        elevation: 2,
                        shape: const CircleBorder(),
                        color: primary,
                        child: InkWell(
                          onTap: _submitTask,
                          customBorder: const CircleBorder(),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.navigation,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Row kedua: kategori kecil + ikon aksi (selalu terlihat, compact)
                Row(
                  children: [
                    GestureDetector(
                      onTap: _openCategorySheet,
                      child: Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.label_outline,
                              size: 18,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _selectedCategory,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.keyboard_arrow_up,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    IconButton(
                      onPressed: _openDatePicker,
                      icon: Icon(Icons.calendar_today, color: primary),
                    ),
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Fungsi share belum diimplementasikan',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.share),
                    ),
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Fungsi checklist belum diimplementasikan',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.check_box_outlined),
                    ),

                    const Spacer(),

                    if (_selectedDate != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_selectedDate!.toLocal().toString().split(' ')[0]}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
