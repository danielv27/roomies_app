import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthAPI {

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
      ("\nERROR: $err");
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
      print("\nERROR: $err");
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
  }

  Future createPersonalProfile(
    User ?currentUser, 
    String radius,
    TextEditingController latLng,
    TextEditingController minBudget, 
    TextEditingController maxBudget, 
    TextEditingController about, 
    TextEditingController work, 
    TextEditingController study, 
    TextEditingController roommate, 
    TextEditingController birthdate,
  ) async {
    await FirebaseFirestore.instance.collection('users')
      .doc(currentUser?.uid)
      .collection('personal_profile')
      .add({ 
        'radius': radius,
        'latLng': latLng.text,
        'minimumBudget': minBudget.text,
        'maximumBudget': maxBudget.text,
        'about': about.text,
        'work': work.text,
        'study': study.text,
        'roommate': roommate.text,
        'birthdate': birthdate.text,
      });
    await FirebaseFirestore.instance.collection('users')
      .doc(currentUser?.uid)
      .update({ 
        'isHouseOwner': false,
      });
  }

  Future createHouseProfile(
    User ?currentUser,
    TextEditingController postalCodeController, 
    TextEditingController houseNumberController, 
    
    TextEditingController propertyTypeController, 

    TextEditingController constructionYearController, 
    TextEditingController livingSpaceController, 
    TextEditingController plotAreaContoller, 

    TextEditingController propertyConditionController,

    TextEditingController houseDescriptionController,
    TextEditingController furnishedController,
    TextEditingController numRoomController,
    TextEditingController availableRoomController,
    TextEditingController pricePerRoomController,
    TextEditingController contactNameController,
    TextEditingController contactEmailControler,
    TextEditingController contactPhoneNumberControler,
  ) async {
    await FirebaseFirestore.instance.collection('users')
      .doc(currentUser?.uid)
      .collection('houses_profile')
      .add({ 
        'postalCode': postalCodeController.text,
        'houseNumber': houseNumberController.text,
        'propertyType': propertyTypeController.text,
        'constructionYear': constructionYearController.text,
        'livingSpace': "${livingSpaceController.text}m2",
        'plotArea': "${plotAreaContoller.text}m2",
        'propertyCondition': propertyConditionController.text,
        'houseDescription': houseDescriptionController.text,
        'isFurnished': furnishedController.text,
        'numberRooms': numRoomController.text,
        'numberAvailableRooms': availableRoomController.text,
        'pricePerRoom': pricePerRoomController.text,
        'contactName': contactNameController.text,
        'contactEmail': contactEmailControler.text,
        'contactPhoneNumber': contactPhoneNumberControler.text
      });
    await FirebaseFirestore.instance.collection('users')
      .doc(currentUser?.uid)
      .update({
        'isHouseOwner': true,
      });
  }

  Future<bool> checkIfCurrentUserProfileComplete() async{
    bool complete = false;
    final currentUserID = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance.collection('users/$currentUserID/personal_profile')
    .get()
    .then((querySnapshot) => querySnapshot.docs.isNotEmpty ? complete = true: complete = false);
    return complete;
  }

  Future<bool> checkIfCurrentUserHouseComplete() async{
    bool complete = false;
    final currentUserID = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance.collection('users/$currentUserID/houses_profile')
    .get()
    .then((querySnapshot) => querySnapshot.docs.isNotEmpty ? complete = true: complete = false);
    return complete;
  }

}