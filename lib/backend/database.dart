import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roomies_app/models/user_profile_images.dart';
import 'package:roomies_app/models/user_profile_model.dart';
import '../models/message.dart';
import '../models/user_model.dart';


class FireStoreDataBase {

  ///////////////////////////////////// Users ///////////////////////////////
  
  Future<UserModel?> getCurrentUserModel() async {
    try {
      UserModel? currentUser;
      await FirebaseFirestore.instance.collection("users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .get()
      .then((userDoc) async {
        UserProfileImages? usersProfileImages = await getUsersImagesById(userDoc.id);
        UserSignupProfileModel? userSignupProfileModel = await getUserProfile(userDoc.id);

        currentUser = UserModel(
          id: userDoc.id,
          email: userDoc['email'],
          firstName: userDoc['firstName'],
          lastName: userDoc['lastName'],
          isHouseOwner: userDoc['isHouseOwner'],
          firstImgUrl: usersProfileImages!.imageURLS[0], 
          userSignupProfileModel: userSignupProfileModel,
        );
      });
      return currentUser;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }

  Future<UserModel?> getUserModelByID(String? userID) async {
    try {
      UserModel? newUser;
      UserProfileImages? usersProfileImages = await getUsersImagesById(userID);
      UserSignupProfileModel? userSignupProfileModel = await getUserProfile(userID);

      await FirebaseFirestore.instance.collection("users")
      .doc(userID)
      .get()
      .then((userDoc) {
        newUser = UserModel(
          id: userDoc.id,
          email: userDoc['email'],
          firstName: userDoc['firstName'],
          lastName: userDoc['lastName'],
          isHouseOwner: userDoc['isHouseOwner'],
          firstImgUrl: usersProfileImages!.imageURLS[0], 
          userSignupProfileModel: userSignupProfileModel,
        );
      });
      return newUser;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }

  //retrieve random users that are not house owners
  Future<List<UserModel>?> getNewUsers(int limit) async {
    try {
      List<UserModel> userList = [];
      List<String?>? encounters = await getEncountersIDs(FirebaseAuth.instance.currentUser?.uid);
      encounters!.add(FirebaseAuth.instance.currentUser?.uid);
      await FirebaseFirestore.instance.collection("users")
      .limit(limit)
      .where('isHouseOwner',isEqualTo: false)
      .where(FieldPath.documentId, whereNotIn: encounters)
      .get()
      .then(
        (querySnapshot) async {
          for (var userDoc in querySnapshot.docs) {
            UserProfileImages? usersProfileImages = await getUsersImagesById(userDoc.id);
            UserSignupProfileModel userSignupProfileModel = await getUserProfile(userDoc.id);
            UserModel newUser = UserModel(
              id: userDoc.id,
              email: userDoc['email'],
              firstName: userDoc['firstName'],
              lastName: userDoc['lastName'],
              isHouseOwner: userDoc['isHouseOwner'],
              firstImgUrl: usersProfileImages!.imageURLS[0],
              userSignupProfileModel: userSignupProfileModel,
            );
            userList.add(newUser);
          }
        }
      );
      return userList;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }


  Future<List<UserProfileModel>?> getNewUserProfileModels(int limit) async {
    List<UserModel>? users = await getNewUsers(limit);
    List<UserProfileModel>? usersProfileModel = [];

    try{  
      for (var user in users!) {
        late UserProfileModel userProfileModel;
        late List<dynamic> userProfileImages = [];

        await FirebaseFirestore.instance.collection('users/${user.id}/profile_images')
          .get()
          .then((querySnapshot) {
            for (var doc in querySnapshot.docs) {
              userProfileImages = doc.data()['urls'];
            }
            userProfileModel = UserProfileModel(
              userModel: user,
              imageURLS: userProfileImages,
            );
          });
        usersProfileModel.add(userProfileModel);
      }
      return usersProfileModel;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }

    Future<UserProfileModel?> getCurrentUserProfile() async {
    try {
      UserModel? userModel = await getCurrentUserModel();  
      UserProfileModel? userProfileModel;
      late List<dynamic> userProfileImages = [];

      await FirebaseFirestore.instance.collection('users/${userModel?.id}/profile_images')
        .get()
        .then((querySnapshot) {
          for (var doc in querySnapshot.docs) {
            userProfileImages = doc.data()['urls'];
          }
          userProfileModel = UserProfileModel(
            userModel: userModel!,
            imageURLS: userProfileImages,
          );
        });
      return userProfileModel;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }


  Future<UserProfileModel?> getUserProfileByID(String uid) async {
    try {
      UserModel? userModel = await getUserModelByID(uid);  
      UserProfileModel? userProfileModel;
      late List<dynamic> userProfileImages = [];

      await FirebaseFirestore.instance.collection('users/${userModel?.id}/profile_images')
        .get()
        .then((querySnapshot) {
          for (var doc in querySnapshot.docs) {
            userProfileImages = doc.data()['urls'];
          }
          userProfileModel = UserProfileModel(
            userModel: userModel!,
            imageURLS: userProfileImages,
          );
        });
      return userProfileModel;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }

  

  Future<UserProfileImages?> getUsersImagesById(String? currentUserID) async{
    try{ 
      late UserProfileImages userProfileImagesModel;
      late List<dynamic> userProfileImages = [];

      await FirebaseFirestore.instance.collection('users/$currentUserID/profile_images')
        .get()
        .then((querySnapshot) {
          for (var doc in querySnapshot.docs) {
            userProfileImages = doc['urls'];
          }
          userProfileImagesModel = UserProfileImages(
            imageURLS: userProfileImages,
          );
        });
      return userProfileImagesModel;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }

  Future<String> getUsersFirstImage(String? currentUserID) async{
    try{ 
      late String userProfileFirstImage = "";
      await FirebaseFirestore.instance.collection('users/$currentUserID/profile_images')
        .limit(1)
        .get()
        .then((querySnapshot) {
          userProfileFirstImage = querySnapshot.docs[0]['urls'][0];
          for (var doc in querySnapshot.docs) {
            userProfileFirstImage = doc['urls'][0];
          }
        });
      return userProfileFirstImage;
    } catch (e) {
      debugPrint("Error - $e");
      return "http://www.classicaloasis.com/wp-content/uploads/2014/03/profile-square.jpg";
    }
  }



  Future<String?> getUserType(String? currentUserID) async {
    try {
      bool? isHouseOwner;
      await FirebaseFirestore.instance.collection('users').doc(currentUserID)
      .get()
      .then((value) {
        isHouseOwner = value.data()!['isHouseOwner'];  
        isHouseOwner = (isHouseOwner.toString() == "true") ? true : false;
        print(isHouseOwner);
      });
      return isHouseOwner.toString();
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }

  Future<UserSignupProfileModel> getUserProfile(String? currentUserID) async{
    late UserSignupProfileModel userSignupProfileModel;
    await FirebaseFirestore.instance.collection('users/$currentUserID/personal_profile')
      .get()
      .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          userSignupProfileModel = UserSignupProfileModel(
            about: doc['about'],
            work: doc['work'],
            study: doc['study'], 
            birthdate: doc['birthdate'], 
            maxBudget: doc['maximumBudget'], 
            minBudget: doc['minimumBudget'], 
            roommate: doc['roommate'],
            radius: doc['radius'],
          );
        }
      });
    return userSignupProfileModel;
  }

  Future<void> addEncounter(bool match, String currentUserID, String otherUserID) async {
    await FirebaseFirestore.instance.collection('users/$currentUserID/encounters')
    .doc(otherUserID)
    .set({ 
      'match': match,
    });
  }


  Future<List<String>?> getEncountersIDs(String? currentUserID) async {
    List<String> encounters = [];
    await FirebaseFirestore.instance.collection('users/$currentUserID/encounters')
    .get()
    .then((querySnapshot) {
      for(var doc in querySnapshot.docs){
        encounters.add(doc.id);
      }
    });
    return encounters;
  }

  Future<List<String>> getMatchesIDs(String currentUserID) async {
    List<String> matches = [];
    await FirebaseFirestore.instance.collection('users/$currentUserID/encounters')
    .where('match', isEqualTo: true)
    .get()
    .then((querySnapshot) {
      for(var doc in querySnapshot.docs){
        matches.add(doc.id);
      }
    });
    return matches;
  }  


  ////////////////////// sign-in sign-up //////////////////////
  
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
    await FirebaseFirestore.instance.collection('users')
      .doc(currentUser?.uid)
      .collection('house_profile')
      .add({ 
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
    await FirebaseFirestore.instance.collection('users')
      .doc(currentUser?.uid)
      .update({
        'isHouseOwner': true,
      });
  }



  //////////////////////////////////////////////Online Offline///////////////////////////////////////////////

  void goOffline(String? uid) async{
    await FirebaseFirestore.instance.collection('users')
    .doc(uid)
    .update({ 
      'online': false,
    });
  }

  void goOnline() async{
    await FirebaseFirestore.instance.collection('users')
    .doc(FirebaseAuth.instance.currentUser?.uid)
    .update({ 
      'online': true,
    });
  }

  Future<bool?> getOnlineStatus(String? uid) async {
    bool? onlineStatus;
    await FirebaseFirestore.instance.collection('users')
    .doc(uid)
    .get()
    .then((doc) {
      if(doc.data()!.containsKey('online') && doc['online']){
        onlineStatus = true;
      }
      else{
        onlineStatus = false;
      }
    });
    return onlineStatus;
  }

  Stream<bool> checkIfOnline(String? uid) async* {
    try {
      while(true) {
        bool? isOnline = await getOnlineStatus(uid);
        if(isOnline != null){
          yield (isOnline) ? true : false;
        }
        await Future.delayed(const Duration(seconds: 2));
      }
    } catch (e) {
      debugPrint("Error - $e");
    }
  }


  ////////////////////////////////////////////////////Messaging///////////////////////////////////////////////////////

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
