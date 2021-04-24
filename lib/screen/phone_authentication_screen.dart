import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:moor_sample/firebase/firebase.dart';
import 'package:moor_sample/screen/home_screen.dart';

/// 面倒だったのでStateNotifierで管理していない
class PhoneAuthenticationScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();

  String _verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      body: Consumer(
      builder: (context, watch, child) {
        return Padding(padding: const EdgeInsets.all(8),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(labelText: 'Phone number (+xx xxx-xxx-xxxx)'),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  alignment: Alignment.center,
                  child: RaisedButton(
                    color: Colors.greenAccent[400],
                    child: Text("認証コード要求"),
                    onPressed: () async {
                      _verificationId = await watch(authenticationProvider).getSMSCode(showSnackbar, _phoneNumberController.text);
                    },
                  ),
                ),
                TextFormField(
                  controller: _smsController,
                  decoration: const InputDecoration(labelText: 'Verification code'),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 16.0),
                  alignment: Alignment.center,
                  child: RaisedButton(
                    color: Colors.greenAccent[200],
                    onPressed: () async {
                      await watch(authenticationProvider).signInWithPhoneNumber(showSnackbar, _verificationId, _smsController.text);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
                    },
                    child: Text("Sign in")),
                ),
              ],
            )
          ),
        );
      })
    );
  }

  void showSnackbar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

}