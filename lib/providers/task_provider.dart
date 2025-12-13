import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';
import '../services/hive_service.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return TaskNotifier(hiveService);
});

class TaskNotifier extends StateNotifier<List<Task>> {
  final HiveService _hiveService;

  TaskNotifier(this._hiveService) : super([]) {
    loadTasks();
  }

  void loadTasks() {
    state = _hiveService.getTasks();
  }

  Future<void> addTask(String title, String description) async {
    final task = Task(
      id: const Uuid().v4(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
    );
    await _hiveService.addTask(task);
    loadTasks();
  }

  Future<void> toggleTask(String id) async {
    final task = state.firstWhere((t) => t.id == id);
    task.isCompleted = !task.isCompleted;
    await _hiveService.updateTask(task);
    loadTasks();
  }

  Future<void> deleteTask(String id) async {
    await _hiveService.deleteTask(id);
    loadTasks();
  }
}
