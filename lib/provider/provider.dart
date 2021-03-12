import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:moor_sample/state_notifier/state_notifier.dart';
import 'package:moor_sample/model/model.dart';

final StateNotifierProvider<TaskList> taskListProvider = StateNotifierProvider((ref) => TaskList([],ref.read));

/// TODO: 変数名を変えたい
final isNotDoneTasksCount = Provider((ref) => ref.watch(taskListProvider.state).where((task) => !task.isDone).length);

enum Filter {
  all,
  active,
  done,
}

final StateProvider<Filter> filterProvider = StateProvider((_) => Filter.all);

final Provider<List<Task>> filteredTasks = Provider((ref) {
  final filter = ref.watch(filterProvider);
  // provider本体だけではなくstateも直接読める
  final tasks = ref.watch(taskListProvider.state);

  switch (filter.state) {
    case Filter.done:
      return tasks.where((task) => task.isDone).toList();
    case Filter.active:
      return tasks.where((task) => !task.isDone).toList();
    case Filter.all:
    default:
      return tasks;
  }
});