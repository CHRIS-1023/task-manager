import 'package:flutter/material.dart';
import 'package:task_manager/auth_service/auth.dart';
import 'package:task_manager/auth_service/helpers.dart';
import 'package:task_manager/widgets/bottom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();
  String userName = "";
  String userEmail = "";

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
                  ),
                  IconButton(
                      onPressed: () {},
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
              Text(userEmail)
            ],
          ),
        ))),
        bottomNavigationBar: const CustomBottomNavigationBar(),
      ),
    );
  }
}
