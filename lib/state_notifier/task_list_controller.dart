import 'package:moor_sample/model/model.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:moor_sample/firestore/firestore.dart';

class TaskList extends StateNotifier<List<Task>> {
  // 引数に初期リストを入れる、なければ空のリスト
  TaskList(List<Task> initialTask,this._read) : super(initialTask ?? []) {
    final fireStoreDao = _read(fireStoreDaoProvider);
    final snapshots = fireStoreDao.getTasksSnapshot();

    snapshots.listen((snapshot) {
      final newTasks = snapshot.docs.map((doc) {
        return Task.fromJson(doc.data());
      }).toList();

      state = newTasks;
    });
  }

  final Reader _read;

  void addTask(String title) {
    _read(fireStoreDaoProvider).addTask(Task(title: title));
  }

  void toggleDone(String id) {
    state = [
      for (final task in state)
        if (task.id == id)
          Task(id: task.id, title: task.title, isDone: !task.isDone)
        else
          task
    ];
  }

  void deleteTask(Task target) {
    state = state.where((task) => task.id != target.id).toList();
  }

  void deleteAllTasks() {
    state = [];
  }

  void deleteDoneTasks() {
    state = state.where((task) => !task.isDone).toList();
  }

  void updateTasks(List<Task> newTasks) {
    state = [for (final task in newTasks) task];
  }
}