// lib/features/tasks/providers/tasks_provider.dart
import 'package:flutter/material.dart';

class TasksProvider extends ChangeNotifier {
  final TextEditingController taskController = TextEditingController();

  // category selection (index), example categories defined in page/widget
  int selectedCategoryIndex = 0;

  // chosen due date (nullable)
  DateTime? dueDate;

  // reminder toggle
  bool reminder = false;

  // loading / submitting state
  bool isLoading = false;

  // simple validation: return false if invalid
  bool validate() {
    final text = taskController.text.trim();
    if (text.isEmpty) return false;
    return true;
  }

  void setCategory(int index) {
    selectedCategoryIndex = index;
    notifyListeners();
  }

  void setDate(DateTime? date) {
    dueDate = date;
    notifyListeners();
  }

  void toggleReminder() {
    reminder = !reminder;
    notifyListeners();
  }

  Future<bool> submitTask() async {
    if (!validate()) return false;
    isLoading = true;
    notifyListeners();

    // simulate network / DB delay
    await Future.delayed(const Duration(seconds: 1));

    // After success, clear fields
    taskController.clear();
    selectedCategoryIndex = 0;
    dueDate = null;
    reminder = false;

    isLoading = false;
    notifyListeners();
    return true;
  }

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }
}
