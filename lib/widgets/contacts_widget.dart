import 'package:flutter/material.dart';
import 'package:its_urgent_poc/screens/contacts/contact_screen.dart';
import 'package:its_urgent_poc/services/fetch_contact.dart';
import 'package:its_urgent_poc/widgets/button_permissions.dart';
import 'package:provider/provider.dart';

class ContactsWidget extends StatelessWidget {
  const ContactsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final contactsProvider = Provider.of<ContactsProvider>(context);

    return _buildBody(contactsProvider, context);
  }

  Widget _buildBody(ContactsProvider contactsProvider, BuildContext context) {
    if (contactsProvider.permissionDenied) {
      return ButtonPermissions(
        title: "Contacts Permissions Denied",
        subtitle: "Go to Settings to grant permissions",
        iconData: Icons.contacts,
        onPressed: () {},
      );
    }
    if (contactsProvider.contacts == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (contactsProvider.contacts!.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
              "None of your contacts is currently on It's Urgent.\nAsk them to download the app & sign in using their phone number."),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  Text(
                    "Your contacts on It's Urgent",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  const Expanded(
                      child: Divider(
                    thickness: 1,
                    color: Colors.black,
                  ))
                ],
              )),
          const SizedBox(
            height: 4,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: contactsProvider.contacts!.length,
              itemBuilder: (context, i) {
                final contact = contactsProvider.contacts![i];
                return Container(
                  decoration:  BoxDecoration(
                    border: Border(bottom: BorderSide(
                      color: Theme.of(context).colorScheme.primaryContainer
                    )),
                  ),
                  child: TextButton(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        contact.displayName,
                        textAlign: TextAlign.left,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    onPressed: () async {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => ContactPage(contact),
                      ));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
