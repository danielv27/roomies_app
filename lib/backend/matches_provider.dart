import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roomies_app/models/user_profile_model.dart';
import 'database.dart';

class MatchesProvider extends ChangeNotifier {
  List<String> userIDs = [];
  List<UserProfileModel> userProfileModels = [];

  //probably not the way to do it but we do need to check wether the user matched with anyone in the background
  void listenToMatches() async {
    while(true){
      Future.delayed(const Duration(seconds: 5));
      List<String> newUserIDs = await FireStoreDataBase().getMatchesIDs(FirebaseAuth.instance.currentUser!.uid);
      if(newUserIDs.length > userIDs.length){
        loadMatches();
      }
    }
  }

  Future<void> loadMatches() async {
    userIDs = await FireStoreDataBase().getMatchesIDs(FirebaseAuth.instance.currentUser!.uid);
    for(var userID in userIDs){
      var currentUserMatchesIDs = await FireStoreDataBase().getMatchesIDs(userID);
      if(currentUserMatchesIDs.contains(FirebaseAuth.instance.currentUser!.uid)){
        UserProfileModel? currentUser = await FireStoreDataBase().getUserProfileByID(userID);
        userProfileModels.add(currentUser!);
      }
    }
    notifyListeners();
  }
}