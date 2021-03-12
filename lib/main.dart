import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:moor_sample/screen/firebase_launch_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      child: FirebaseLaunchScreen(),
    ),
  );
}
