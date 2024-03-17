import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:its_urgent_poc/models/user.dart';
import 'package:its_urgent_poc/widgets/button_permissions.dart';
import 'package:its_urgent_poc/screens/home/home_popup_menu.dart';
import 'package:its_urgent_poc/services/auth.dart';
import 'package:its_urgent_poc/services/fetch_contact.dart';
import 'package:its_urgent_poc/services/notification_services.dart';
import 'package:its_urgent_poc/widgets/contacts_widget.dart';
import 'package:its_urgent_poc/screens/home/home_drawer.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  final notificationServices = NotificationServices();
  UserContact? user;

  bool isNotificationPermission = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getUserDetails(context);
    _init(context);
    Provider.of<ContactsProvider>(context, listen: false).fetchContacts();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _checkNotificationPermissions();
    }
    print(state);
  }

  Future<void> _init(BuildContext context) async {
    await _checkNotificationPermissions();
    // notificationServices.getApnToken();
    context.read<FirebaseMethods>().uploadDeviceToken();

    notificationServices.firebaseInit();
  }

  Future<void> _checkNotificationPermissions() async {
    await notificationServices.requestNotificationPermissions();
    setState(() {
      isNotificationPermission = notificationServices.isNotificationPermission;
    });
  }

  Future<void> _getUserDetails(BuildContext context) async {
    final uid = context.read<FirebaseMethods>().user.uid;

    user = await UserContact.fetchUserDetails(uid);
  }

  @override
  Widget build(BuildContext context) {
    final contactsProvider = Provider.of<ContactsProvider>(context);

    final phoneNumber = user != null ? user!.phoneNumber : "(null)";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text("It's Urgent"),
        actions: [PopMenuWidget(contactsProvider: contactsProvider)],
      ),
      body: isNotificationPermission
          ? const ContactsWidget()
          : ButtonPermissions(
              title: "Notifications Permissions denied.",
              subtitle: 'Tap here to grant permissions',
              iconData: Icons.notification_add,
              onPressed: () {
                AppSettings.openAppSettings(type: AppSettingsType.notification);
              },
            ),
      drawer: HomeDrawerWidget(user: user, phoneNumber: phoneNumber),
    );
  }
}
