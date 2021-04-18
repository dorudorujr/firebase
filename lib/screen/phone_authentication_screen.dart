import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      body: Padding(padding: const EdgeInsets.all(8),
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
                    //verifyPhoneNumber();
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
                    //signInWithPhoneNumber();
                  },
                  child: Text("Sign in")),
              ),
            ],
          )
        ),
      )
    );
  }

  void showSnackbar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

}