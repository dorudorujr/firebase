import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:moor_sample/screen/home_screen.dart';
import 'package:moor_sample/screen/launch_screen.dart';
import 'package:moor_sample/screen/signin_screen.dart';

class FirebaseLaunchScreen extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SignInScreen();
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return LaunchScreen();
        },
      ),
    );
  }
}