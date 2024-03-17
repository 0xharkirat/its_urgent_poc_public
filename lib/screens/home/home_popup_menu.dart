import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:its_urgent_poc/services/auth.dart';
import 'package:its_urgent_poc/services/fetch_contact.dart';
import 'package:provider/provider.dart';

class PopMenuWidget extends StatelessWidget {
  const PopMenuWidget({
    super.key,
    required this.contactsProvider,
  });

  final ContactsProvider contactsProvider;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        switch (value) {
          case 1:
            contactsProvider.fetchContacts();

            break;
          
          case 2:
            AppSettings.openAppSettings();
            break;
          case 3:
            context.read<FirebaseMethods>().deleteAccount(context);
            break;
          default:
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem<int>(
          value: 1,
          // row has two child icon and text.
          child: Row(
            children: [
              Icon(Icons.refresh_outlined),
              SizedBox(
                // sized box with width 10
                width: 10,
              ),
              Text("Refresh Contacts")
            ],
          ),
        ),
        PopupMenuItem(
          value: 3,
          // row has two child icon and text.
          child: Row(
            children: [
              Icon(
                Icons.delete_forever_outlined,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(
                // sized box with width 10
                width: 10,
              ),
              Text(
                "Delete Account",
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              )
            ],
          ),
        ),
        const PopupMenuItem(
          value: 2,
          // row has two child icon and text.
          child: Row(
            children: [
              Icon(Icons.settings_outlined),
              SizedBox(
                // sized box with width 10
                width: 10,
              ),
              Text(" Manage Permissions")
            ],
          ),
        ),
      ],
    );
  }
}
