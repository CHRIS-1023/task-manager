import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/models/tasks.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

//reference for our collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  //saving the user data
  Future savingUserData(String name, String email) async {
    return await userCollection
        .doc(uid)
        .set({"name": name, "email": email, "uid": uid, "assigned tasks": []});
  }

  //getting user data
  Future gettingUserData(String uid) async {
    QuerySnapshot snapshot =
        await userCollection.where('uid', isEqualTo: uid).get();
    return snapshot;
  }

  saveTask(Tasks newTask) {}

  deleteTask(int taskKey) {}
}
