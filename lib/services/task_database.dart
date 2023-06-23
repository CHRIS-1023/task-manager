import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/models/tasks.dart';

class DatabaseService {
  final CollectionReference taskCollection =
      FirebaseFirestore.instance.collection("tasks");

  Future<void> saveTask(Tasks newTask) async {
    await taskCollection.doc(newTask.id.toString()).set({
      'name': newTask.name,
      'assignedTo': [],
    });
  }

  Future<void> deleteTask(int taskId) async {
    await taskCollection.doc(taskId.toString()).delete();
  }
}
