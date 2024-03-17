import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:its_urgent_poc/screens/authenticate/authenticate.dart';
import 'package:its_urgent_poc/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return const Home();
    }
    return const Authenticate();
  }
}
