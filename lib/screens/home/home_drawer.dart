import 'package:flutter/material.dart';
import 'package:its_urgent_poc/models/user.dart';

class HomeDrawerWidget extends StatelessWidget {
  const HomeDrawerWidget({
    super.key,
    required this.user,
    required this.phoneNumber,
  });

  final UserContact? user;
  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              user != null ? user!.displayName : "(null)",
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
          ListTile(
            leading: Text("Your Number:  $phoneNumber"),
          ),
        ],
      ),
    );
  }
}