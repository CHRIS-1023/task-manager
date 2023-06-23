import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manager/models/tasks.dart';
import 'package:task_manager/pages/home.dart';
import 'package:task_manager/services/task_database.dart';
import 'package:task_manager/widgets/screen_navigation.dart';

class AssignPage extends StatefulWidget {
  const AssignPage({super.key});

  @override
  State<AssignPage> createState() => _AssignPageState();
}

class _AssignPageState extends State<AssignPage> {
  final TextEditingController _taskController = TextEditingController();
  List<Tasks> _tasks = [];

  final _tasksBox = Hive.box('tasksBox');

  @override
  void initState() {
    super.initState();
    _refreshTasks();
  }

  void _refreshTasks() {
    final data = _tasksBox.keys.map((key) {
      final task = _tasksBox.get(key) as Tasks;
      return Tasks(
          id: key, name: task.name, isChecked: task.isChecked, assignedTo: "");
    }).toList();

    setState(() {
      _tasks = data;
    });
  }

  Future<void> _createTask(Tasks newTask) async {
    final taskId = await _tasksBox.add(newTask);
    newTask.id = taskId;
    await DatabaseService().saveTask(newTask);
    _refreshTasks();
  }

  Future<void> _deleteTask(int taskKey) async {
    await _tasksBox.delete(taskKey);
    await DatabaseService().deleteTask(taskKey);
    _refreshTasks();
  }

  void showForm(BuildContext context, int? taskKey) async {
    if (taskKey != null) {
      final existingTask =
          _tasks.firstWhere((element) => element.key == taskKey);
      _taskController.text = existingTask.name;
    }
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        elevation: 5,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  top: 15,
                  left: 15,
                  right: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(hintText: 'Task'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final newTask = Tasks(
                          id: DateTime.now().millisecondsSinceEpoch,
                          name: _taskController.text,
                          isChecked: false,
                          assignedTo: "",
                        );
                        _createTask(newTask);

                        _taskController.text = '';

                        Navigator.of(context).pop();
                      },
                      child: const Text('Create')),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ));
  }

  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<List<DocumentSnapshot>> _fetchUsers() async {
    final QuerySnapshot snapshot = await _userCollection.get();
    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        nextScreenReplace(
                            context,
                            const HomePage(
                              uid: '',
                            ));
                      },
                      icon: const Icon(Icons.arrow_back)),
                  const Text(
                    'Task Manager App',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.edit_square))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Assign to'),
              const SizedBox(
                height: 10,
              ),
              assignTo(),
              const SizedBox(
                height: 10,
              ),
              const Text('Tasks'),
              const SizedBox(
                height: 10,
              ),
              tasks(context)
            ],
          ),
        ),
      ),
    );
  }

  Container tasks(BuildContext context) {
    return Container(
        height: 360,
        decoration: BoxDecoration(
            color: Colors.grey[400], borderRadius: BorderRadius.circular(14)),
        child: Column(
          children: [
            SizedBox(
              height: 310,
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final currentItem = _tasks[index];
                  return Card(
                    color: Colors.grey[600],
                    margin: const EdgeInsets.all(5),
                    elevation: 3,
                    child: ListTile(
                      title: Text(currentItem.name),
                      leading: Checkbox(
                        value: currentItem.isChecked,
                        onChanged: (newValue) {
                          setState(() {
                            currentItem.toggleChecked();
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          currentItem.toggleChecked();
                        });
                      },
                      trailing: IconButton(
                          onPressed: () {
                            _deleteTask(currentItem.id);
                          },
                          icon: const Icon(Icons.delete)),
                    ),
                  );
                },
              ),
            ),
            IconButton(
              onPressed: () {
                showForm(context, null);
              },
              icon: const Icon(Icons.add),
            )
          ],
        ));
  }

  FutureBuilder<List<DocumentSnapshot<Object?>>> assignTo() {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: _fetchUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          final users = snapshot.data!
              as List<QueryDocumentSnapshot<Map<String, dynamic>>>;
          return SizedBox(
            height: 100,
            child: GridView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, mainAxisSpacing: 12),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index].data();
                final userName = user['name'];
                final userId = user['uid'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      for (final task in _tasks) {
                        if (task.isChecked) {
                          task.assignedTo = userId;
                          task.isChecked = false;
                          DatabaseService().saveTask(task);
                        }
                      }
                    });
                  },
                  child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.grey[400]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 34,
                            child: Icon(Icons.person),
                          ),
                          Text(userName)
                        ],
                      )),
                );
              },
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
