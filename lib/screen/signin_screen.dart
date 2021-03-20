import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moor_sample/state_notifier/signin_screen/signin_controller.dart';

import 'package:moor_sample/screen/home_screen.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, watch, child) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RaisedButton(
                  child: Text('使う'),
                  onPressed: (){
                    watch(signInControllerProvider).anonymousSignin().then((user) {
                      if (user != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen(),)
                        );
                      }
                    });
                  },
                ),
                RaisedButton(
                  child: Text('Singin'),
                  onPressed: (){
                    // 押したら反応するコードを書く
                    // 画面遷移のコード
                  },
                ),
              ],
            ),
          );
        },
      )
    );
  }
}