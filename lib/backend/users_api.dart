import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roomies_app/models/user_model.dart';
import 'package:roomies_app/models/user_profile_images.dart';
import 'package:roomies_app/models/user_profile_model.dart';

class UsersAPI {

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
  Future<List<UserModel>?> getNewUsers(int limit, List<String?>? currentEncounters) async {
    try {
      List<UserModel> userList = [];
      List<String?>? encounters = await getEncountersIDs(FirebaseAuth.instance.currentUser?.uid);
      await FirebaseFirestore.instance.collection("users")
      .limit(limit)
      .where('isHouseOwner',isEqualTo: false)
      .where(FieldPath.documentId, isNotEqualTo: FirebaseAuth.instance.currentUser?.uid)
      .get()
      .then(
        (querySnapshot) async {
          for (var userDoc in querySnapshot.docs) {
            if(encounters!.contains(userDoc.id)){
              continue;
            }
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
    List<UserModel>? users = await getNewUsers(limit, null);
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



  Future<String?> getCurrentUserType() async {
    try {
      bool? isHouseOwner;
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid)
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
            latLng: doc['latLng'],
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
      'timeStamp': DateTime.now() // maybe need to change to time stamp since epoch
    });
  }

    Future<void> addMatch(String currentUserID, String otherUserID) async {
    await FirebaseFirestore.instance.collection('users/$currentUserID/matches')
    .doc(otherUserID)
    .set({ 
      'timeStamp': DateTime.now() // maybe need to change to time stamp since epoch
    });
  }

    Future<List<UserModel>> getMatches(String userID) async {
    List<String> matchesIDs = [];
    List<UserModel> matches = [];
    await FirebaseFirestore.instance.collection('users/$userID/matches')
    .get().then((querySnapShot) {
      for(var doc in querySnapShot.docs){
        matchesIDs.add(doc.id);
      }
    });
    for(var id in matchesIDs){
      UserModel? userModel = await getUserModelByID(id);
      userModel != null? matches.add(userModel):null;
    }
    return matches;
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

  Future<DateTime?> getTimeStampOfEncounter(String currentUserID, String otherUserID) async {
    late DateTime? time;
    await FirebaseFirestore.instance.collection('users/$currentUserID/encounters')
    .doc(otherUserID)
    .get()
    .then((querySnapshot) => time = querySnapshot['timeStamp'].toDate());
    return time;
  }

  Future<List<String>> getLikedEncountersIDs(String currentUserID) async {
    List<String> likedEnocounters = [];
    await FirebaseFirestore.instance.collection('users/$currentUserID/encounters')
    .where('match', isEqualTo: true)
    .orderBy('timeStamp',descending: true)
    .get()
    .then((querySnapshot) {
      var sorted = querySnapshot.docs;
      for(var doc in sorted){
        likedEnocounters.add(doc.id);
      }
    });
    
    return likedEnocounters;
  }  

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

}