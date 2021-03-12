import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';  // TODO: firestoreのクラスをここに持ち込まないようにしたい

import 'package:moor_sample/provider/provider.dart';
import 'package:moor_sample/model/model.dart';
import 'package:moor_sample/state_notifier/state_notifier.dart';
import 'package:moor_sample/widget/task_tile.dart';
import 'package:moor_sample/firestore/firestore.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _newTaskTitle = '';
    final _textEditingController = TextEditingController();

    /// テキスト入力完了かTextFieldの×を押したら入力中の文字を消す
    void clearTextField() {
      _textEditingController.clear();
      _newTaskTitle = '';
    }

    /// タスクを消したらSnackBar表示、restoreで元に戻せる
    void showSnackBar({
      List<Task> previousTasks,
      TaskList taskList,
      String content,
      ScaffoldState scaffoldState,
    }) {
      /// SnackBar表示中にタスク削除したら、前のSnackBarを消すためにremoveを最初に入れている
      /// ScaffoldState: snackBar管理クラス？
      scaffoldState.removeCurrentSnackBar();
      final snackBar = SnackBar(
        content: Text(content),
        action: SnackBarAction(
          label: 'restore',
          onPressed: () {
            /// 消す前のタスクリストで更新して削除したタスクを復活させる
            taskList.updateTasks(previousTasks);
            scaffoldState.removeCurrentSnackBar();
          },
        ),
        duration: const Duration(seconds: 3),
      );
      scaffoldState.showSnackBar(snackBar);
    }


    return MaterialApp(
      home: Scaffold(
        body: Consumer(
          builder: (context, watch, child) {
            final taskList = watch(taskListProvider);
            final allTasks = watch(taskListProvider.state);
            final displayedTasks = watch(filteredTasks);
            final filter = watch(filterProvider);
            final firestoreDao = watch(fireStoreDaoProvider);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),  /// 縦のpaddingに16ずつ追加
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, /// 左寄せ
                      children: [
                        Center(
                          child: Text(
                            'ToDo List',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,   /// 左右に16ずつ
                          ),
                          child: TextField(
                            controller: _textEditingController,
                            decoration: InputDecoration(
                              hintText: 'Enter a todo title',
                              suffixIcon: IconButton(
                                onPressed: clearTextField,
                                icon: Icon(Icons.clear),
                              ),
                            ),
                            textAlign: TextAlign.start,
                            onChanged: (newText) {
                              _newTaskTitle = newText;
                            },
                            onSubmitted: (newText) {
                              if (_newTaskTitle.isEmpty) {
                                _newTaskTitle = 'No Title';
                              }
                              taskList.addTask(_newTaskTitle);    /// TODOを追加
                              clearTextField();
                            },
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                '${watch(isNotDoneTasksCount)} tasks left',
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,  /// 子要素の間に均等なスペースを空ける
                              children: [
                                /// InkWell: タップアクションを付加
                                InkWell(
                                  child: const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text('All'),
                                  ),
                                  onTap: () => filter.state = Filter.all,
                                ),
                                InkWell(
                                  child: const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text('Active'),
                                  ),
                                  onTap: () => filter.state = Filter.active,
                                ),
                                InkWell(
                                  onTap: () => filter.state = Filter.done,
                                  child: const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text('Done'),
                                  ),
                                ),
                                InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      'Delete Done',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    final doneTasks = allTasks
                                      .where((task) => task.isDone)
                                      .toList();
                                    if (doneTasks.isNotEmpty) {
                                      taskList.deleteDoneTasks();
                                      showSnackBar(
                                        previousTasks: allTasks,    /// rebuildされてない段階では削除前のstate
                                        taskList: taskList,
                                        content:
                                        'Done tasks have been deleted.',
                                        scaffoldState: Scaffold.of(context),
                                      );
                                    }
                                  },
                                ),
                                InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      'Delete All',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    if (allTasks.isNotEmpty) {
                                      taskList.deleteAllTasks();
                                      showSnackBar(
                                        previousTasks: allTasks,
                                        taskList: taskList,
                                        content: 'All tasks have been deleted.',
                                        scaffoldState: Scaffold.of(context),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder(
                    stream: firestoreDao.getTasksSnapshot(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading");
                      }

                      /// ExpandedというWidgetは、RowやColumnの子Widget間の隙間を目一杯埋めたいときに使います。
                      return Expanded(
                        child: ListView(
                          children: snapshot.data.docs.map((DocumentSnapshot document) {
                            return TaskTile(
                              taskTitle: document.data()['title'],
                              isChecked: document.data()['isDone'],
                              checkboxCallback: (bool value) {
                                taskList.toggleDone(document.data()['id']);
                              },
                              longPressCallback: () {
                                //TODO: 削除処理実装
                                //taskList.deleteTask(task);
                                showSnackBar(
                                  previousTasks: displayedTasks,
                                  taskList: taskList,
                                  content: '${document.data()['title']} has been deleted.',
                                  scaffoldState: Scaffold.of(context),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      );
                    }
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}