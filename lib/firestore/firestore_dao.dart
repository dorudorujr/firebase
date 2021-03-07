import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:moor_sample/model/task.dart';

final fireStoreDaoProvider = Provider((_) => FireStoreDao());

class FireStoreDao {
  FireStoreDao() : super();

  final todos = FirebaseFirestore.instance.collection('todos');

  Future<void> addUser(Task task) {
    return todos
      .add({
      'title': task.title, // John Doe
      'isDone': task.isDone, // Stokes and Sons
      'id': task.id // 42
    })
      .then((value) => print("success"))
      .catchError((error) => print("Failed to add user: $error"));
  }
}