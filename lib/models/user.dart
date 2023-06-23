import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String uid;

  @HiveField(1)
  final String name;

  @HiveField(2)
  List assignedTasks = [];

  User({required this.uid, required this.name, required this.assignedTasks});
}
