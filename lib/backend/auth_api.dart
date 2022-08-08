import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthAPI {

  Future<String> signIn(
    TextEditingController emailController, 
    TextEditingController passwordController, 
    TextEditingController errorMessage,
    BuildContext context,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (err) {
      switch (err.code) {
        case "invalid-email":
          errorMessage.text = "email address is not valid";
          break;
        case "user-disabled":
          errorMessage.text = "email has been disabled";
          break;
        case "user-not-found":
          errorMessage.text = "there is no user corresponding to the given email";
          break;
        case "wrong-password":
          errorMessage.text = "the password is invalid for the given email";
          break;
        case "too-many-requests":
          errorMessage.text = "too many signin attempts";
          break;
        default:
          errorMessage.text = "";
      }
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage.text),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (err) {
      errorMessage.text = "ERROR: $err";
    }
    return errorMessage.text;
  }

  Future<String> signUp(
    TextEditingController emailController, 
    TextEditingController passwordController, 
    TextEditingController firstNameController, 
    TextEditingController lastNameController, 
    TextEditingController errorMessage,
    BuildContext context,
  ) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      ).then((currentUser) async {
        await FirebaseFirestore.instance.collection('users')
          .doc(currentUser.user!.uid)
          .set({
            'firstName': firstNameController.text,
            'lastName': lastNameController.text,
            'email': emailController.text,
          });
      });
    } on FirebaseAuthException catch (err) {
      switch (err.code) {
        case "email-already-in-use":
          errorMessage.text = "email already in use";
          break;
        case "invalid-email":
          errorMessage.text = "the email address is not valid" ;
          break;
        case "operation-not-allowed":
          errorMessage.text = "email/password accounts are not enabled";
          break;
        case "weak-password":
          errorMessage.text = "the password is not strong enough";
          break;
        default:
          errorMessage.text = "Unknown Error";
      }
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage.text),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (err) {
      errorMessage.text = "ERROR: $err";
    }
    return errorMessage.text;
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
    TextEditingController apartNumberController,
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

    List<dynamic> imageURLS,
  ) async {
    var storageRef = FirebaseFirestore.instance.collection('users').doc(currentUser?.uid).collection('houses_profile').doc();
    await storageRef
      .set({ 
        'postalCode': postalCodeController.text,
        'houseNumber': houseNumberController.text,
        'apartmentNumber': apartNumberController.text,
        'propertyType': propertyTypeController.text,
        'constructionYear': constructionYearController.text,
        'livingSpace': livingSpaceController.text,
        'plotArea': plotAreaContoller.text,
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

    await storageRef
      .collection("house_images")
      .add({
        'urls': imageURLS,
      });

    final splittedStorageRed = storageRef.path.split('/');
    await FirebaseFirestore.instance.collection('houses')
      .doc(splittedStorageRed.last)
      .set({
        'userID': currentUser?.uid,
        'houseRef': storageRef.path,
        'ImagesRef': storageRef.collection("house_images").path
      });
  }

    Future<bool> checkIfCurrentUserExists() async{
    bool exists = false;
    final currentUserID = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance.doc('users/$currentUserID')
    .get()
    .then((documentSnapShot) => exists = documentSnapShot.exists? true:false);
    return exists;
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