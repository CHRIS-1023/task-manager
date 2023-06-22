import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/models/tasks.dart';

class DatabaseService {
  final CollectionReference taskCollection =
      FirebaseFirestore.instance.collection("tasks");
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  Future<void> saveTask(Tasks newTask) async {
    await taskCollection.doc(newTask.id.toString()).set({
      'name': newTask.name,
      'assignTo': newTask.assignTo,
    });
  }

  Future<void> deleteTask(int taskId) async {
    await taskCollection.doc(taskId.toString()).delete();
  }
}
