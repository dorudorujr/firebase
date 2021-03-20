import 'package:state_notifier/state_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:moor_sample/firebase/firebase.dart';

final signInControllerProvider = StateNotifierProvider.autoDispose((ref) => SignInController(ref.read));

class SignInController extends StateNotifier<bool> {
  SignInController(this._read) : super(false);

  final Reader _read;

  Future<UserCredential> anonymousSignin() async {
    UserCredential user = await _read(anonymousAuthenticationProvider).authentication();
    if (user != null) {
      state = true;
      return user;
    } else {
      state = false;
      return null;
    }
  }
}