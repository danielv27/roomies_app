import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
    return Scaffold(
      backgroundColor: Colors.red[200],
      appBar: AppBar(
        backgroundColor: Colors.red[700],
        title: const Text("Signup"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: firstNameController,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: inputDecoration("First Name"),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: lastNameController,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: inputDecoration("Last Name")
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                validator: (emailController) {
                  if (emailController == null || emailController.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: inputDecoration("Email")
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: ageController,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: inputDecoration("Age"),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: inputDecoration("Password"),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        color: Colors.transparent,
        child: BottomAppBar(
          color: Colors.transparent,
          child: ElevatedButton(
            onPressed: () {
              signUp();
              Navigator.of(context).pop();
            },
            child: const Text(
              "Signup",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(primary: (Colors.red[700])),
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String labelText) {
    return InputDecoration(
      focusColor: Colors.white,
      labelStyle: const TextStyle(color: Colors.white),
      labelText: labelText,
      fillColor: Colors.white,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: const BorderSide(color: Colors.white),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: const BorderSide(
          color: Colors.black,
          width: 2.0,
        ),
      ),
    );
  }

  Future signUp() async {
    try {
      UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      User? user = result.user;
      await FirebaseFirestore.instance.collection('users')
        .doc(user?.uid)
        .set({ 
          'firstName': firstNameController.text,
          'lastName': lastNameController.text,
          'age': ageController.text,
          'email': emailController.text,
        });
    } on FirebaseAuthException catch (exc) {
      setState(() {
        if (exc.toString().contains('email') ||
            exc.toString().contains('user')) {
          invalidUserName = true;
        }
        if (exc.toString().contains('password')) {
          invalidPassword = true;
        }
        if (kDebugMode) {
          print(exc.toString());
        }
      });
    }
  }

}