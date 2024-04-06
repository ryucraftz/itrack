import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:itrack/screens/start_page.dart';
import 'package:itrack/screens/login_page.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    // Return either the StartPage or LoginPage based on the user's authentication status
    if (user == null) {
      return const StartPage();
    } else {
      return const LoginPage();
    }
  }
}
