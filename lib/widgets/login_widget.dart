import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/signup_page.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  const LoginWidget({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  @override
  LoginWidgetState createState() => LoginWidgetState();
}


class LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isChecked = false;

  @override
  void initState() {
    _loadUserEmailPassword();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  bool invalidUserName = false;
  bool invalidPassword = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(children: [
        const Align(
            alignment: Alignment.centerLeft,
            child: Text(
                "Welcome!",
                style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 26),
            ),
          ),
        TextField(
          controller: emailController,
          style: TextStyle(color: Colors.grey),
          cursorColor: Colors.grey,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            icon: const Icon(Icons.email,size: 20,color: Colors.grey,),
            iconColor: Colors.grey,
            fillColor: Colors.grey,
            labelText: "Email",
            labelStyle: const TextStyle(color: Colors.grey),
            errorText: invalidUserName ? "Invalid Email" : null
            ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: passwordController,
          style: TextStyle(color: Colors.grey),
          cursorColor: Colors.red,
          textInputAction: TextInputAction.done,
          obscureText: true,
          decoration: InputDecoration(
            //the lines below change the color of the underline of the text field
            // enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            icon: const Icon(Icons.lock,size: 20, color: Colors.grey,),
            labelText: "Password",
            labelStyle: const TextStyle(color: Colors.grey),
            errorText: invalidPassword ? "Invalid Password" : null
            
            ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          SizedBox(
              height: 24.0,
              width: 24.0,
              child: Theme(
                data: ThemeData(
                    unselectedWidgetColor: Color(0xff00C8E8) // Your color
                ),
                child: Checkbox(
                    activeColor: Color(0xff00C8E8),
                    value: _isChecked,
                    onChanged: _handleRemember),
              )),
          const SizedBox(width: 10.0),
          const Text("Remember Me",
              style: TextStyle(
                  color: Color(0xff646464),
                  fontSize: 12,
                  fontFamily: 'Rubic'))
        ]),
        const SizedBox(height: 20),
        Container(
          width: 200,
          margin: EdgeInsets.only(bottom: 10),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
              shadowColor: Colors.red[900],
              elevation: 5,
              primary: Colors.white,
              minimumSize: const Size.fromHeight(42)
            ),
            icon: const Icon(Icons.lock_open, size: 24,color: Colors.red,),
            label: const Text("Log In", style: TextStyle(fontSize: 20, color: Colors.red)), 
            onPressed: signIn,
            ),
        ),
        RichText(
          text: TextSpan(
            text: 'Don\'t have account? ', style: const TextStyle(
              color: Colors.grey,
            ),
            children: [
              TextSpan(
              recognizer: TapGestureRecognizer()..onTap = () =>
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  ),
              style: const TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                  backgroundColor: Colors.white
                ),
                text: 'Sign Up'
              )
            ],
          )
        ),
      ]),
    );
  }

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

    } on FirebaseAuthException catch (exc) {
      setState(() {
        if (exc.toString().contains('email') || exc.toString().contains('user')){
          invalidUserName = true;
        }
        if (exc.toString().contains('password')){
          invalidPassword = true;
        }
        // ignore: avoid_print
        print(exc.toString());
      });
    }
  }

  void _handleRemember(bool? checkboxState) {
    print("Handle Remember Me");
    _isChecked = checkboxState!;
    SharedPreferences.getInstance().then(
          (prefs) {
        prefs.setBool("remember_me", checkboxState);
        prefs.setString('email', emailController.text);
        prefs.setString('password', passwordController.text);
      },
    );
    setState(() {
      _isChecked = checkboxState;
    });
  }

  void _loadUserEmailPassword() async {
    print("Load Email");
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _email = _prefs.getString("email") ?? "";
      var _password = _prefs.getString("password") ?? "";
      var _rememberMe = _prefs.getBool("remember_me") ?? false;

      print(_rememberMe);
      print(_email);
      print(_password);
      if (_rememberMe) {
        setState(() {
          _isChecked = true;
        });
        emailController.text = _email;
        passwordController.text = _password;
      }
    } catch (e) {
      print(e);
    }
  }
}

