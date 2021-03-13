import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:moor_sample/model/task.dart';

final fireStoreDaoProvider = Provider((_) => FireStoreDao());

class FireStoreDao {
  FireStoreDao() : super();

  final tasks = FirebaseFirestore.instance.collection('tasks');

  Future<void> addTask(Task task) {
    return tasks
      .add({
      'title': task.title,
      'isDone': task.isDone,
      'id': task.id
    })
      .then((value) => print("success"))
      .catchError((error) => print("Failed to add user: $error"));
  }

  Stream<QuerySnapshot> getTasksSnapshot() {
    return tasks.snapshots();
  }

  void updateDone(Task task) {
    tasks.doc(task.id).update({'isDone': !task.isDone});
  }

  void deleteTask(Task target) {
    tasks
      .doc(target.id)
      .delete()
      .then((value) => print('success'))
      .catchError((error) => print('delete error:${error}'));
  }

  void deleteAllTask() {
    final tasksCollection = tasks.get();

    tasksCollection.then((value) {
      final batch = FirebaseFirestore.instance.batch();
      if (value.size == 0) {
        return 0;
      }

      value.docs.forEach((element) {
        batch.delete(element.reference);
      });

      batch.commit();
    });
  }

  void deleteDoneTasks() {
    final doneTasksCollection = tasks.where("isDone", isEqualTo: true).get();

    doneTasksCollection.then((value) {
      final batch = FirebaseFirestore.instance.batch();
      if (value.size == 0) {
        return 0;
      }

      value.docs.forEach((element) {
        batch.delete(element.reference);
      });

      batch.commit();
    });
  }
}