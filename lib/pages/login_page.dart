import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children:[
          const Spacer(),
          const Image(image: AssetImage('assets/images/demo-house.png'),height: 100,),
          const Text(
            'Roomies',
            style: TextStyle(fontFamily: 'Shink', fontSize: 50)
          ),
          LoginWidget(),
          const Spacer()
        ],
      )
    );
  }
}

class LoginWidget extends StatefulWidget {
  @override
  LoginWidgetState createState() => LoginWidgetState();
}


class LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool invalidUserName = false;
  bool invalidPassword = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(children: [
        TextField(
          controller: emailController,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            icon: const Icon(Icons.email,size: 20),
            
            labelText: "Email",
            errorText: invalidUserName ? "Invalid Email" : null
            ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: passwordController,
          textInputAction: TextInputAction.done,
          obscureText: true,
          decoration: InputDecoration(
            icon: const Icon(Icons.lock,size: 20),
            labelText: "Password",
            errorText: invalidPassword ? "Invalid Password" : null
            ),
        ),
        
        const SizedBox(height: 20),
        
        SizedBox(
          width: 200,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
              shadowColor: Colors.red,
              elevation: 5,
              primary: Color.fromARGB(234, 209, 76, 67),
              minimumSize: const Size.fromHeight(42)
              
              
            ),
            icon: const Icon(Icons.lock_open, size: 24),
            label: const Text("Log In", style: TextStyle(fontSize: 20)), 
            onPressed: signIn,
            ),
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
}