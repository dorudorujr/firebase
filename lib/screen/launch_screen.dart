import 'package:flutter/material.dart';

import 'package:moor_sample/screen/signin_screen.dart';

class LaunchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignInScreen(),
    );
  }
}