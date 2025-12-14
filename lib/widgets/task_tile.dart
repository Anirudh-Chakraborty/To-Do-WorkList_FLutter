import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskTile extends ConsumerWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: (value) {
          ref.read(taskProvider.notifier).toggleTask(task.id);
        },
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (task.description.isNotEmpty) Text(task.description),
          if (task.dueDate != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                'Due: ${DateFormat.yMMMd().format(task.dueDate!)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          ref.read(taskProvider.notifier).deleteTask(task.id);
        },
      ),
    );
  }
}
