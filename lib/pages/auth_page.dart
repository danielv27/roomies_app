import 'package:flutter/material.dart';
import 'package:roomies_app/widgets/login_widget.dart';
import 'package:roomies_app/widgets/signup_widget.dart';

class AuthPage extends StatefulWidget {
  @override
  AuthPageState createState() => AuthPageState();
}

// ignore: use_key_in_widget_constructors
class AuthPageState extends State<AuthPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
       showBottom(context);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
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
          ),
        ),
        child: Column(
          children: [
            const Spacer(),
            const Image(
              image: AssetImage('assets/images/app-icon.png'),
              height: 100,
            ),
            Container(padding: const EdgeInsets.all(30)),
            const Spacer(),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  void showBottom(BuildContext context) {
    showBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0), 
          topRight: Radius.circular(30.0)
        ),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                LoginWidget(),
              ],
            ),
          ),
        );
      },
    );
  }
}
