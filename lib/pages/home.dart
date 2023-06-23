import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/pages/message.dart';
import 'package:task_manager/services/auth.dart';
import 'package:task_manager/services/helpers.dart';
import 'package:task_manager/widgets/bottom_navigation_bar.dart';
import 'package:task_manager/widgets/screen_navigation.dart';

class HomePage extends StatefulWidget {
  final String uid;

  const HomePage({super.key, required this.uid});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();
  String userName = "";
  String userEmail = "";
  String userUid = "";

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });

    await HelperFunctions.getUserEmailFromSF().then((val) {
      setState(() {
        userEmail = val!;
      });
    });

    String uid = await authService.getCurrentUserUid();
    setState(() {
      userUid = uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
            child: Form(
                child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CircleAvatar(
                    radius: 28,
                    child: Icon(Icons.person),
                  ),
                  IconButton(
                      onPressed: () {
                        nextScreen(context, const MessagePage());
                      },
                      icon: const Icon(
                        Icons.notifications_none_outlined,
                        size: 30,
                      ))
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                userName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(userEmail),
              const Divider(
                height: 30,
                color: Colors.amber,
              ),
              const Text('Recent tasks'),
              const SizedBox(
                height: 6,
              ),
              SizedBox(
                height: 540,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('tasks')
                      .where('assignedTo', isEqualTo: userUid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final tasks = snapshot.data!.docs;

                    return GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 12,
                        mainAxisExtent: 100,
                      ),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index].data() as Map;
                        final taskName = task['name'] as String;

                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.grey[400],
                          ),
                          child: Center(child: Text(taskName)),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ))),
        bottomNavigationBar: const CustomBottomNavigationBar(),
      ),
    );
  }
}
