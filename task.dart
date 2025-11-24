class Task {
  final String id;
  final String title;
  final String? description;
  final DateTime date;
  bool completed;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.date,
    this.completed = false,
  });
}
