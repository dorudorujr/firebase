import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:moor_sample/screen/signin_screen.dart';
import 'package:moor_sample/screen/home_screen.dart';

class LaunchScreen extends StatelessWidget {
  final FirebaseAuth fireBaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return fireBaseAuth.currentUser != null ? HomeScreen() : SignInScreen();
  }
}