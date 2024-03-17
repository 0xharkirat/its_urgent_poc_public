import 'package:cloud_firestore/cloud_firestore.dart';

class UserContact {
  final String uid; // Unique identifier for the user
  final String displayName; // Display name of the use
  final String phoneNumber;
  final String deviceToken;

  UserContact(
      {required this.uid,
      required this.displayName,
      required this.phoneNumber,
      required this.deviceToken}); //

  // Convert User object to a Map for storing in Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
    };
  }

// Create User object from Firestore document snapshot
  factory UserContact.fromMap(Map<String, dynamic> map) {
    return UserContact(
      uid: map['uid'],
      displayName: map['displayName'],
      phoneNumber: map['phoneNumber'],
      deviceToken: map['device_token']
    );
  }

  // Fetch user details from Firestore based on UID
  static Future<UserContact?> fetchUserDetails(String uid) async {
    try {
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userSnapshot.exists) {
        return UserContact.fromMap(userSnapshot.data() as Map<String, dynamic>);
      } else {
        // User document does not exist
        return null;
      }
    } catch (error) {
      print("Error fetching user details: $error");
      return null;
    }
  }


    @override
  String toString() {
    // TODO: implement toString
    return "uid: $uid, displayName: $displayName, phoneNumber: $phoneNumber, device_token: $deviceToken";
  }

}
