import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authenticationProvider = Provider((_) => Authentication());

class Authentication {
  Authentication() : super();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential> authentication() async {
    return firebaseAuth.signInAnonymously();
  }

  Future<void> signout() async {
    await firebaseAuth.signOut();
  }
}