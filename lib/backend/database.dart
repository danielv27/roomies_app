import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../models/user_model.dart';


class FireStoreDataBase {


  Future<List<UserModel>?> getUsers() async {
    try {
      List<UserModel> userList = [];
      await FirebaseFirestore.instance.collection("users").get().then((querySnapshot) {
        for (var userDoc in querySnapshot.docs) {
          if(userDoc.id != FirebaseAuth.instance.currentUser?.uid){
            UserModel newUser = UserModel(
              id: userDoc.id,
              email: userDoc['email'],
              firstName: userDoc['firstName'],
              lastName: userDoc['lastName'],
              isHouseOwner: userDoc['isHouseOwner']
              );
            userList.add(newUser);
          }
        }
      });
      return userList;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
    
  }
  Future<UserModel?> getUserByID(String? userID) async {
    try {
      UserModel? newUser;
      await FirebaseFirestore.instance.collection("users")
      .doc(userID)
      .get()
      .then((userDoc) {
        newUser = UserModel(
          id: userDoc.id,
          email: userDoc['email'],
          firstName: userDoc['firstName'],
          lastName: userDoc['lastName'],
          isHouseOwner: userDoc['isHouseOwner']
          );
      });
      return newUser;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      UserModel? newUser;
      await FirebaseFirestore.instance.collection("users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .get()
      .then((userDoc) {
        newUser = UserModel(
          id: userDoc.id,
          email: userDoc['email'],
          firstName: userDoc['firstName'],
          lastName: userDoc['lastName'],
          isHouseOwner: userDoc['isHouseOwner']
          );
      });
      return newUser;
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

