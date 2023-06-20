import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manager/pages/home.dart';
import 'package:task_manager/widgets/screen_navigation.dart';

class AssignPage extends StatefulWidget {
  const AssignPage({super.key});

  @override
  State<AssignPage> createState() => _AssignPageState();
}

class _AssignPageState extends State<AssignPage> {
  final TextEditingController _taskController = TextEditingController();
  List<Map<String, dynamic>> _tasks = [];

  final _tasksBox = Hive.box('tasksBox');

  @override
  void initState() {
    super.initState();
    _refreshTasks();
  }

  void _refreshTasks() {
    final data = _tasksBox.keys.map((key) {
      final task = _tasksBox.get(key);
      return {
        "key": key,
        "task": task["task"],
        "isChecked": task["isChecked"] ?? false
      };
    }).toList();

    setState(() {
      _tasks = data.reversed.toList();
    });
  }

  Future<void> _createTask(Map<String, dynamic> newTask) async {
    await _tasksBox.add(newTask);
    _refreshTasks();
  }

  Future<void> _deleteTask(int taskKey) async {
    await _tasksBox.delete(taskKey);
    _refreshTasks();
  }

  void _toggleTask(int taskKey) {
    final taskIndex = _tasks.indexWhere((task) => task['key'] == taskKey);
    if (taskIndex != -1) {
      setState(() {
        _tasks[taskIndex]['isChecked'] = !_tasks[taskIndex]['isChecked'];
      });
    }
  }

  void showForm(BuildContext context, int? taskKey) async {
    if (taskKey != null) {
      final existingTask =
          _tasks.firstWhere((element) => element['key'] == taskKey);
      _taskController.text = existingTask['name'];
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
                        _createTask({
                          "task": _taskController.text,
                        });

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
                        nextScreenReplace(context, const HomePage());
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
              const Text(
                'About the task',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(14)),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Assign to'),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 100,
                child: GridView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, mainAxisSpacing: 12),
                  itemBuilder: (context, index) {
                    return Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.grey[400]),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 34,
                              child: Icon(Icons.person),
                            ),
                            Text('name')
                          ],
                        ));
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Tasks'),
              const SizedBox(
                height: 10,
              ),
              Container(
                  height: 360,
                  decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(14)),
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
                                leading: Checkbox(
                                  value: currentItem['isChecked'],
                                  onChanged: (value) {
                                    _toggleTask(currentItem['key']);
                                  },
                                ),
                                onTap: () {
                                  _toggleTask(currentItem['key']);
                                },
                                title: Text(currentItem['task']),
                                trailing: IconButton(
                                    onPressed: () {
                                      _deleteTask(currentItem['key']);
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
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
