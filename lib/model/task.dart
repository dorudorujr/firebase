import 'package:uuid/uuid.dart';

var _uuid = Uuid();

class Task {
  Task({
    this.title,
    this.isDone = false,
    String id,
  }) : id = id ?? _uuid.v4(); // idはnullならuuidがされる

  final String id;
  final String title;
  final bool isDone;

  factory Task.fromJson(Map<String, dynamic> json, String id) {
    return Task(
      title: json['title'] as String,
      isDone: json['isDone'] as bool,
      id: id,
    );
  }
}