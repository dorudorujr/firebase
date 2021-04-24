import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authenticationProvider = Provider((_) => Authentication());

class Authentication {
  Authentication() : super();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential> authentication() async {
    return firebaseAuth.signInAnonymously();
  }

  /// 認証コード取得処理
  Future<String> getSMSCode(Function showSnackBar, String phoneNumber) async {
    try {
      String _verificationId = "";

      ///ユーザーがこの電話番号を使ってすでにサインインしている場合のコールバック
      PhoneVerificationCompleted verificationCompleted = (PhoneAuthCredential phoneAuthCredential) async {
        await firebaseAuth.signInWithCredential(phoneAuthCredential);
        showSnackBar(
          "電話番号が自動的に認証され、ユーザーがサインインする: ${firebaseAuth.currentUser.uid}");
      };

      /// エラー時
      PhoneVerificationFailed verificationFailed = (FirebaseAuthException authException) {
          showSnackBar('Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
      };

      ///コードが送られてきたときのコールバック
      PhoneCodeSent codeSent = (String verificationId, [int forceResendingToken]) async {
        showSnackBar('認証コードを携帯電話で確認してください。');
        _verificationId = verificationId;
      };

      PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (String verificationId) {
        showSnackBar("verification code: " + verificationId);
        _verificationId = verificationId;
      };

      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);

      return _verificationId;
    } catch(e) {
      showSnackBar("Failed to Verify Phone Number: ${e}");
      return "";
    }
  }

  Future<void> signInWithPhoneNumber(Function showSnackBar, String verificationId, String smsController) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsController,
      );

      final User user = (await firebaseAuth.signInWithCredential(credential)).user;

      showSnackBar("Successfully signed in UID: ${user.uid}");
      print("Successfully signed in UID: ${user.uid}");
    } catch (e) {
      showSnackBar("Failed to sign in: " + e.toString());
    }
  }

  Future<void> signout() async {
    await firebaseAuth.signOut();
  }
}