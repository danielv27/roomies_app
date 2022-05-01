import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children:[
            const SizedBox(height: 110,),
            const Image(image: AssetImage('assets/images/demo-house.png'),height: 120,),
            const Text(
              'Roomies',
              style: TextStyle(fontFamily: 'BebasNeue', fontSize: 32)
            ),
            const SizedBox(height: 22,),
            LoginWidget()
          ],
        ),
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(children: [
        const SizedBox(height: 20),
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
        
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            primary: Colors.redAccent[400],
            minimumSize: const Size.fromHeight(50)
            
          ),
          icon: const Icon(Icons.lock_open, size: 32),
          label: const Text("Log In", style: TextStyle(fontSize: 24)), 
          onPressed: signIn,
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