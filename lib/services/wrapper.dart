import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:itrack/screens/start_page.dart';
import 'package:itrack/screens/login_page.dart';
import 'package:itrack/screens/loading_screen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StartPage();
  }
}
