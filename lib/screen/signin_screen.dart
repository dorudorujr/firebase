import 'package:flutter/material.dart';

import 'package:moor_sample/screen/home_screen.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RaisedButton(
              child: Text('使う'),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen(),
                  )
                );
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
      ),
    );
  }
}