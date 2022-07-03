import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';


class FireStoreDataBase {


  Future getUsers() async {
    try {
      List<UserModel> userList = [];
      await FirebaseFirestore.instance.collection("users").get().then((querySnapshot) {
        for (var userDoc in querySnapshot.docs) {
          var data = userDoc.data();
          UserModel newUser = UserModel(
            id: userDoc.id,
            email: userDoc['email'],
            firstName: userDoc['firstName'],
            lastName: userDoc['lastName'],
            isHouseOwner: userDoc['isHouseOwner'] //Tell volpin to add this attribute to the different registration forms as otherwise it will break
            );
          userList.add(newUser);
        }
      });
      return userList;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }

  Future signinUser(TextEditingController emailController, TextEditingController passwordController, context) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    ).catchError((err) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: const Text(
                "The email address and password you entered don't match any Roomies account. Please try again."
              ),
              actions: [
                ElevatedButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          }
        );
    });
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

  Future createPersonalProfile(User ?currentUser, TextEditingController minBudget, TextEditingController maxBudget, TextEditingController about, TextEditingController work, TextEditingController study, TextEditingController roommate, TextEditingController birthdate) async {
    print("creating personal profile\n");
    await FirebaseFirestore.instance.collection('users')
      .doc(currentUser?.uid)
      .update({ 
        'isHouseOwner': false,
        'minimumBudget': minBudget.text,
        'maximumBudget': maxBudget.text,
        'about': about.text,
        'work': work.text,
        'roommate': roommate.text,
        'birtdate': birthdate.text,
      });
      print("created personal profile\n");
  }

  Future createHouseProfile(User ?currentUser) async {
    await FirebaseFirestore.instance.collection('users')
      .doc(currentUser?.uid)
      .update({ 
        'isHouseOwner': true,
      });
  }


}

