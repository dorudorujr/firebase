import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final anonymousAuthenticationProvider = Provider((_) => AnonymousAuthentication());

class AnonymousAuthentication {
  AnonymousAuthentication() : super();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential> authentication() async {
    return firebaseAuth.signInAnonymously();
  }
}