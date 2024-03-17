import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:its_urgent_poc/services/notification_services.dart';
import 'package:its_urgent_poc/utils/snackbar.dart';

class FirebaseMethods {
  final FirebaseAuth _auth;
  FirebaseMethods(this._auth);

  User get user => _auth.currentUser!;

  // STATE PERSISTENCE STREAM
  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();
  // OTHER WAYS (depends on use case):
  // Stream get authState => FirebaseAuth.instance.userChanges();
  // Stream get authState => FirebaseAuth.instance.idTokenChanges();
  // KNOW MORE ABOUT THEM HERE: https://firebase.flutter.dev/docs/auth/start#auth-state

  // ANONYMOUS SIGN IN
  Future<void> signInAnonymously(BuildContext context,
      {required String mobileNumber, required String displayName}) async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();

      // Retrieve user's UID from Firebase Authentication
      String uid = userCredential.user!.uid;

      // Store user data in Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'phoneNumber': mobileNumber,
        'displayName': displayName,
        // You can add more fields here like 'name', 'email', etc.
      });
    } catch (e) {
      showSnackBar(context, e.toString()); // Displaying the error message
    }
  }

  // SIGN OUT
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }

  // DELETE ACCOUNT & DELETE the corresponding data in cloud firestore
  Future<void> deleteAccount(BuildContext context) async {
    try {
      // Get the current user
      User? user = _auth.currentUser;

      // Check if the user is signed in
      // Check if the user is signed in
      if (user != null) {
        // Delete the corresponding Firestore data in a transaction
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          // Assuming 'users' is the Firestore collection containing user data
          DocumentReference userDocRef =
              FirebaseFirestore.instance.collection('users').doc(user.uid);

          // Delete the user document
          await transaction.delete(userDocRef);
        });

        // Delete the user account after deleting Firestore data
        await user.delete();

        // Show success message or navigate to a different screen
      } else {
        // User is not signed in, handle the error
        showSnackBar(context, 'User is not signed in.');
      }
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException
      showSnackBar(context, e.message!);
      if (e.code == 'requires-recent-login') {
        // If an error of 'requires-recent-login' is thrown, make sure to log in the user again
        // and then delete the account.
        // Implement reauthentication logic here
      }
    } catch (error) {
      // Handle other errors
      print('An error occurred: $error');
    }
  }

  Future<bool> uploadDeviceToken() async {
    try {
      User? user = _auth.currentUser;

      if (user == null) {
        return false;
      }
      final deviceId = await NotificationServices.deviceToken();
      if (deviceId == null) {
        return false;
      }
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'device_token': deviceId});
      return true;
    } catch (error) {
      // Handle other errors
      print(error);
    }
    return false;
  }
}
