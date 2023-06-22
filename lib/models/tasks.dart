import 'package:hive/hive.dart';

part 'tasks.g.dart';

@HiveType(typeId: 0)
class Tasks extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  bool isChecked;

  @HiveField(3)
  String assignTo;

  void toggleChecked() {
    isChecked = !isChecked;
  }

  Tasks(
      {required this.id,
      required this.name,
      required this.isChecked,
      required this.assignTo});
}
