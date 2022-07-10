import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/message.dart';
import '../models/user_model.dart';


class FireStoreDataBase {

  final db = FirebaseFirestore;

  Future<List<UserModel>?> getUsers() async {
    try {
      List<UserModel> userList = [];
      await FirebaseFirestore.instance.collection("users")
      .get()
      .then(
        (querySnapshot) {
          for (var userDoc in querySnapshot.docs) {
            if(userDoc.id != FirebaseAuth.instance.currentUser?.uid && userDoc.data().containsKey('isHouseOwner')){
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
        }
      );
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


  Future isNodeExists(User ?currentUser, String nodeKey) async {
    var snapshot = FirebaseFirestore.instance.collection("users").doc(currentUser?.uid);
    await snapshot
      .get()
      .then((doc) {
        var documentData = doc.data();
        if (documentData!.containsKey(nodeKey)) {
          print("\n---------------------");
          print("\nNODE EXSITS");
          print("\n---------------------");
          return true;
        } else {
          print("\n---------------------");
          print("\nNODE DOES NOT EXSIT");
          print("\n---------------------");
          return false;
        }
      });
  }

  Future signinUser(TextEditingController emailController, TextEditingController passwordController, context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (err) {
      switch (err.code.toString()) {
        case "invalid-email":
          print("\nemail address is not valid\n");
          break;
        case "user-disabled":
          print("if the user corresponding to the given email has been disabled");
          break;
        case "user-not-found":
          print("there is no user corresponding to the given email");
          break;
        case "wrong-password":
          print(" the password is invalid for the given email, or the account corresponding to the email does not have a password set");
          break;
        default:
          print("\nunhandeled error\n");
      }
      return throw err.code.toString();
    } catch (err) {
      print("\n-------------------------");
      print("\nERROR: $err");
      print("\n-------------------------");
    }
  }

  Future createUser(
    TextEditingController emailController, 
    TextEditingController passwordController, 
    TextEditingController firstNameController, 
    TextEditingController lastNameController,
  ) async {
    late UserCredential result;
    try {
      result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (err) {
      switch (err.code.toString()) {
        case "email-already-in-use":
          print("there already exists an account with the given email address");
          break;
        case "invalid-email":
          print("the email address is not valid");
          break;
        case "operation-not-allowed":
          print("email/password accounts are not enabled");
          break;
        case "weak-password":
          print("the password is not strong enough");
          break;
        default:
          print("\nunhandeled error\n");
      }
      rethrow;
    } catch (err) {
      print("\n-------------------------");
      print("\nERROR: $err");
      print("\n-------------------------");
      rethrow;
    }

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

  Future createPersonalProfile(
    User ?currentUser, 
    TextEditingController minBudget, 
    TextEditingController maxBudget, 
    TextEditingController about, 
    TextEditingController work, 
    TextEditingController study, 
    TextEditingController roommate, 
    TextEditingController birthdate,
  ) async {
    print("creating personal profile\n");
    await FirebaseFirestore.instance.collection('users/${currentUser?.uid}/personal_profile')
      .add({ 
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

  Future createHouseProfile(
    User ?currentUser,
    TextEditingController postalCodeController, 
    TextEditingController houseNumberController, 
    String propertyTypeChosen, 
    TextEditingController constructionYearController, 
    TextEditingController livingSpaceController, 
    TextEditingController plotAreaContoller, 
    String propertyConditionChosen,
    TextEditingController houseDescriptionController,
    TextEditingController pricePerRoomController,
    TextEditingController contactNameController,
    TextEditingController contactEmailControler,
    TextEditingController contactPhoneNumberControler,
  ) async {
    print("creating house profile\n");
    await FirebaseFirestore.instance.collection('users/${currentUser?.uid}/house_profile"')
      .add({ 
        'isHouseOwner': true,
        'postlCode': postalCodeController.text,
        'houseNumber': houseNumberController.text,
        'propertyType': propertyTypeChosen,
        'constructionYear': constructionYearController.text,
        'livingSpace': livingSpaceController.text+"m2",
        'plotArea': plotAreaContoller.text+"m2",
        'propertyCondition': propertyConditionChosen,
        'houseDescription': houseDescriptionController.text,
        'pricePerRoom': pricePerRoomController.text,
        'contactName': contactNameController.text,
        'contactEmail': contactEmailControler.text,
        'contactPhoneNumber': contactPhoneNumberControler.text
      });
    print("created house profile\n");
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

  Stream<List<Message>?> listenToMessages(String? currentUserID, String? otherUserID) async* {
    try {
      List<Message>? messages = await getMessages(currentUserID, otherUserID);
      //yield messages;
      while(true){
        await Future.delayed(const Duration(seconds: 2));
        List<Message>? newMessages = await getMessages(currentUserID, otherUserID);
        if(newMessages!.length > messages!.length){
          messages = newMessages;
          yield newMessages;
        } 
      }
    } catch (e) {
      debugPrint("Error - $e");
    }
  }


}