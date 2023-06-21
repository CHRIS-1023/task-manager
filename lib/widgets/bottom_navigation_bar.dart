import 'package:flutter/material.dart';
import 'package:task_manager/pages/assign.dart';
import 'package:task_manager/pages/home.dart';
import 'package:task_manager/pages/message.dart';
import 'package:task_manager/pages/settings.dart';
import 'package:task_manager/widgets/screen_navigation.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                nextScreenReplace(context, const HomePage());
              },
              icon: const Icon(Icons.home)),
          IconButton(
            onPressed: () {
              showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2030));
            },
            icon: const Icon(Icons.calendar_month),
          ),
          FloatingActionButton(
            onPressed: () {
              nextScreenReplace(context, const AssignPage());
            },
            child: const Icon(Icons.add),
          ),
          IconButton(
              onPressed: () {
                nextScreen(context, const MessagePage());
              },
              icon: const Icon(Icons.message)),
          IconButton(
              onPressed: () {
                nextScreen(context, const SettingsPage());
              },
              icon: const Icon(Icons.settings))
        ],
      ),
    );
  }
}
