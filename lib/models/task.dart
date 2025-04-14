import 'package:isar/isar.dart';

part 'task.g.dart';

@collection
class Task {
  Id id = Isar.autoIncrement;
  
  late String title;
  String? description;
  late DateTime createdAt;
  @Index()
  late bool isCompleted;
  
  Task({
    required this.title,
    this.description,
    bool isCompleted = false,
  }) {
    this.createdAt = DateTime.now();
    this.isCompleted = isCompleted;
  }
}