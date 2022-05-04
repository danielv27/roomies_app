import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpWidget extends StatefulWidget {
  final VoidCallback onClickedSignIn; 
  
  const SignUpWidget({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);

  @override
  SignUpWidgetState createState() => SignUpWidgetState();
}

class SignUpWidgetState extends State<SignUpWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
      padding: const EdgeInsets.all(15),
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
          style: TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          textInputAction: TextInputAction.done,
          obscureText: true,
          decoration: InputDecoration(
            //the lines below change the color of the underline of the text field
            // enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            icon: const Icon(Icons.lock,size: 20, color: Colors.white,),
            labelText: "Password",
            labelStyle: const TextStyle(color: Colors.white),
            errorText: invalidPassword ? "Invalid Password" : null
            
            ),
        ),
        
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
            label: const Text("Sign Up", style: TextStyle(fontSize: 20, color: Colors.red)), 
            onPressed: signUp,
            ),
        ),
        RichText(
          text: TextSpan(
            text: 'Already have an account? ',
            children: [
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = widget.onClickedSignIn, 
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                  backgroundColor: Colors.white
                ),
                text: 'Sign In'
              )
            ],
          )
        ),
      ]),
    );
  }

  
  Future signUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
}


