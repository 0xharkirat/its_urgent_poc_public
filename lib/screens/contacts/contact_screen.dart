import 'package:flutter/material.dart';

import 'package:its_urgent_poc/models/user.dart';
import 'package:its_urgent_poc/services/auth.dart';
import 'package:its_urgent_poc/services/notification_services.dart';
import 'package:its_urgent_poc/utils/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class ContactPage extends StatelessWidget {
  final UserContact contact;
  const ContactPage(this.contact, {super.key});

  Future<String?> _getUserDetails(BuildContext context) async {
    final uid = context.read<FirebaseMethods>().user.uid;
    final user = await UserContact.fetchUserDetails(uid);
    if (user == null) {
      return null;
    }

    return user.displayName;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Text(contact.displayName)),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Container(width: double.infinity,),

              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(128),
                ),
                child: ClipOval(
                  child: FadeInImage.memoryNetwork(
                    width: 256,
                    placeholder: kTransparentImage,
                    image:
                        "https://ui-avatars.com/api/?name=${contact.displayName}&background=random&size=256",
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
                width: double.infinity,
              ),
              Text('Name: ${contact.displayName}'),
              Text('Phone number: ${contact.phoneNumber}'),
              ElevatedButton(
                onPressed: () async {
                  final sender = await _getUserDetails(context);
                  if (sender != null) {
                    NotificationServices.sendNotification(
                      context,
                      receiver: contact.deviceToken,
                      sender: sender,
                    );
                  } else {
                    showSnackBar(context, "Not sent");
                  }
                },
                child: const Text("Send Notification"),
              )
            ],
          ),
        ),
      );
}
