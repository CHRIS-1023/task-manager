import 'package:flutter/material.dart';
import 'package:task_manager/auth_service/auth.dart';
import 'package:task_manager/pages/login.dart';
import 'package:task_manager/widgets/screen_navigation.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListTile(
          onTap: () async {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Logout"),
                  content: const Text("Are you sure you want to logout?"),
                  actions: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.red,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await authService.signOut();
                        nextScreenReplace(context, const LoginPage());
                      },
                      icon: const Icon(
                        Icons.done,
                        color: Colors.green,
                      ),
                    ),
                  ],
                );
              },
            );
          },
          leading: const Icon(Icons.exit_to_app),
          title: const Text(
            "Logout",
          ),
        ),
      ),
    );
  }
}
