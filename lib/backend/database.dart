import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../models/message.dart';
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

  Future uploadMessage(String message, String? fromID, String? toID) async {
    final fromRef = FirebaseFirestore.instance.collection('users/$fromID/messages');
    final toRef = FirebaseFirestore.instance.collection('users/$toID/messages');
    try{
      await fromRef.add({
        'message': message,
        'otherUserID': toID,
        'sentByCurrent': true,
        'timeStamp': DateTime.now()
      });

      await toRef.add({
        'message': message,
        'otherUserID': fromID,
        'sentByCurrent': false,
        'timeStamp': DateTime.now()
      });
      print('message sent to firebase\n');
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }

  }

  Future<List<Message>?> getMessages(String? currentUserID, String? otherUserID) async {
    try {
      List<Message>? messages = [];
      await FirebaseFirestore.instance.collection('users/$currentUserID/messages')
      .where('otherUserID', isEqualTo: otherUserID)
      .get()
      .then((querySnapshot) {
        for (var messageDoc in querySnapshot.docs) {
          Message currentMessage = Message(
            message: messageDoc['message'],
            otherUserID: messageDoc['otherUserID'],
            sentByCurrent: messageDoc['sentByCurrent'],
            timeStamp: messageDoc['timeStamp'].toDate()
            // id: userDoc.id,
            // email: userDoc['email'],
            // firstName: userDoc['firstName'],
            // lastName: userDoc['lastName'],
            // isHouseOwner: userDoc['isHouseOwner']
            );
          messages.add(currentMessage);
        }
      });
      return messages;
    } catch (e) {
      debugPrint("Error - $e");
      return null;  
    }

  }


}

