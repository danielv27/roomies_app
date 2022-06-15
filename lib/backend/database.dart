import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FireStoreDataBase {
  List userList = [];
  final CollectionReference collectionRef = FirebaseFirestore.instance.collection("users");

  Future getData() async {
    try {
      await collectionRef.get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          userList.add(result.data());
        }
      });
      return userList;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }

  Future signinUser(TextEditingController emailController, TextEditingController passwordController) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
  }  

  Future createUser(TextEditingController emailController, TextEditingController passwordController, TextEditingController firstNameController, TextEditingController lastNameController) async {
    UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    User? newUser = result.user;
    await FirebaseFirestore.instance.collection('users')
      .doc(newUser?.uid)
      .set({
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'email': emailController.text,
      });
    print("user created");
  }


  Future createPersonalProfile(User ?currentUser) async {
    await FirebaseFirestore.instance.collection('users')
      .doc(currentUser?.uid)
      .update({ 
        'isHouseOwner': false,
      });
      
  }

  Future createHouseProfile(User ?currentUser) async {
    await FirebaseFirestore.instance.collection('users')
      .doc(currentUser?.uid)
      .update({ 
        'isHouseOwner': true,
      });
  }
}

