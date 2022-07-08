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
    await FirebaseFirestore.instance.collection('users')
      .doc(currentUser?.uid)
      .update({ 
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


}

