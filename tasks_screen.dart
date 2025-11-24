import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_uniube/models/task.dart';
import 'package:task_uniube/providers/task_provider.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    final tasks = provider.tasks;

    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Tarefas')),
      body: tasks.isEmpty
          ? const Center(child: Text('Nenhuma tarefa. Adicione usando o botão +'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, i) {
                final t = tasks[i];
                return Dismissible(
                  key: ValueKey(t.id),
                  background: Container(color: Colors.red, alignment: Alignment.centerLeft, padding: const EdgeInsets.only(left: 16), child: const Icon(Icons.delete, color: Colors.white)),
                  secondaryBackground: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 16), child: const Icon(Icons.delete, color: Colors.white)),
                  onDismissed: (_) => provider.removeTask(t.id),
                  child: ListTile(
                    leading: Checkbox(value: t.completed, onChanged: (_) => provider.toggleCompleted(t.id)),
                    title: Text(t.title, style: TextStyle(decoration: t.completed ? TextDecoration.lineThrough : null)),
                    subtitle: t.description != null ? Text(t.description!) : null,
                    trailing: Text('${t.date.day}/${t.date.month}/${t.date.year}'),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final _titleCtrl = TextEditingController();
    final _descCtrl = TextEditingController();
    DateTime _selected = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Adicionar Tarefa'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Título')),
                  TextField(controller: _descCtrl, decoration: const InputDecoration(labelText: 'Descrição (opcional)')),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text('Data: ${_selected.day}/${_selected.month}/${_selected.year}'),
                      const Spacer(),
                      TextButton(
                        onPressed: () async {
                          final d = await showDatePicker(context: context, initialDate: _selected, firstDate: DateTime(2000), lastDate: DateTime(2100));
                          if (d != null) setState(() => _selected = d);
                        },
                        child: const Text('Alterar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
              ElevatedButton(
                onPressed: () {
                  final title = _titleCtrl.text.trim();
                  if (title.isEmpty) return;
                  final id = DateTime.now().millisecondsSinceEpoch.toString();
                  final task = Task(id: id, title: title, description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(), date: _selected);
                  Provider.of<TaskProvider>(context, listen: false).addTask(task);
                  Navigator.pop(context);
                },
                child: const Text('Adicionar'),
              ),
            ],
          );
        });
      },
    );
  }
}
