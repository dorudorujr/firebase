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
}