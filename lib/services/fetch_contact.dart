import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:its_urgent_poc/models/user.dart';

class ContactsProvider extends ChangeNotifier {
  List<UserContact>? _contacts;
  bool _permissionDenied = false;

  Future<void> fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      _permissionDenied = true;
      notifyListeners();
      return;
    }

    // Fetch device contacts
    List<Contact>? deviceContacts =
        await FlutterContacts.getContacts(withProperties: true);
    // for (final contact in deviceContacts) {
    //   String number =
    //       contact.phones.first.number.replaceAll(RegExp(r'[^0-9]'), '').replaceAll(" ", '');
    //   print(number);
    // }

    // Retrieve Firestore data
    List<UserContact> firestoreUserContacts = await _retrieveFirestoreData();
    // print(firestorePhoneNumbers);

    // _contacts = deviceContacts;
    // Filter device contacts based on Firestore data
    _contacts = firestoreUserContacts
        .where((userContact) => deviceContacts.any((contact) =>
            contact.phones.isNotEmpty &&
            userContact.phoneNumber ==
                contact.phones.first.number
                    .replaceAll(RegExp(r'[^0-9]'), '').replaceAll(" ", '')))
        .toList();

    // print(firebaseContacts);

    notifyListeners();
  }

  Future<List<UserContact>> _retrieveFirestoreData() async {
    List<UserContact> userContacts = [];
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        final user = UserContact(
          uid: doc.id,
          displayName: doc['displayName'],
          phoneNumber: doc['phoneNumber'],
          deviceToken: doc['device_token'],
        );
        // print(user.toString());
        userContacts.add(user);
      }
    } catch (error) {
      print("Error retrieving Firestore data: $error");
    }
    return userContacts;
  }

  List<UserContact>? get contacts => _contacts;
  bool get permissionDenied => _permissionDenied;
}
