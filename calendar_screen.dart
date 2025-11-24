import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_uniube/providers/task_provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selected = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    final tasks = provider.tasksForDate(_selected);

    return Scaffold(
      appBar: AppBar(title: const Text('Calendário')),
      body: Column(
        children: [
          CalendarDatePicker(
            initialDate: _selected,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            onDateChanged: (d) => setState(() => _selected = d),
          ),
          const Divider(),
          Expanded(
            child: tasks.isEmpty
                ? const Center(child: Text('Nenhuma tarefa para esta data'))
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, i) {
                      final t = tasks[i];
                      return ListTile(
                        title: Text(t.title, style: TextStyle(decoration: t.completed ? TextDecoration.lineThrough : null)),
                        subtitle: t.description != null ? Text(t.description!) : null,
                        trailing: Checkbox(value: t.completed, onChanged: (_) => provider.toggleCompleted(t.id)),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
