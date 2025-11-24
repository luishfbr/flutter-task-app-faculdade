import 'package:flutter/material.dart';
import 'package:task_uniube/models/task.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void removeTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void toggleCompleted(String id) {
    final t = _tasks.firstWhere((t) => t.id == id);
    t.completed = !t.completed;
    notifyListeners();
  }

  List<Task> tasksForDate(DateTime date) {
    return _tasks.where((t) {
      return t.date.year == date.year &&
          t.date.month == date.month &&
          t.date.day == date.day;
    }).toList();
  }
}
