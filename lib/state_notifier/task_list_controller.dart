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
        return Task.fromJson(doc.data(),doc.id);
      }).toList();

      state = newTasks;
    });
  }

  final Reader _read;

  void addTask(String title) {
    _read(fireStoreDaoProvider).addTask(Task(title: title));
  }

  void toggleDone(Task updateTask) {
    _read(fireStoreDaoProvider).updateDone(updateTask);
  }

  void deleteTask(Task target) {
    _read(fireStoreDaoProvider).deleteTask(target);
  }

  void deleteAllTasks() {
    _read(fireStoreDaoProvider).deleteAllTask();
  }

  void deleteDoneTasks() {
    _read(fireStoreDaoProvider).deleteDoneTasks();
  }

  void updateTasks(List<Task> newTasks) {
    state = [for (final task in newTasks) task];
  }
}