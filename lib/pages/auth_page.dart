import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:roomies_app/widgets/login_widget.dart';
import 'package:roomies_app/widgets/signup_widget.dart';

class AuthPage extends StatefulWidget{
  @override
  AuthPageState createState() => AuthPageState();
}

// ignore: use_key_in_widget_constructors
class AuthPageState extends State<AuthPage> {
  bool isLogin = false;
  
  @override
  Widget build(BuildContext context) {
    void toggle() => setState(() => isLogin = !isLogin);
    return Scaffold(
      backgroundColor: Colors.red,
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(239, 85, 100, 1),
              Color.fromRGBO(195, 46, 66, 1),
              Color.fromRGBO(190, 40, 62, 1),
              Color.fromRGBO(210, 66, 78, 1),
              Color.fromRGBO(244, 130, 114, 1),
            ],
          )
        ),
        child: Column(
          children:[
            const Spacer(),
            const Image(image: AssetImage('assets/images/app-icon.png'),height: 75,),
            const Text(
              'Roomies',
              style: TextStyle(fontFamily: 'Shink', fontSize: 50,color: Colors.white)
            ),
            isLogin ? LoginWidget(onClickedSignUp: toggle) : SignUpWidget(onClickedSignIn: toggle),
            const Spacer()
          ],
        ),
      )
    );
  }
}

