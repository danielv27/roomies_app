import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'database.dart';

class MatchesProvider extends ChangeNotifier {
  List<String> userIDs = [];
  List<UserModel> userModels = [];
  UserModel? lastMatch;
  

  //probably not the way to do it but we do need to check wether the user matched with anyone in the background
  void listenToMatches() async {
    while(true){
      Future.delayed(const Duration(seconds: 5));
      List<String> newUserIDs = await FireStoreDataBase().getLikedEncountersIDs(FirebaseAuth.instance.currentUser!.uid);
      if(newUserIDs.length > userIDs.length){
        loadMatches();
      }
    }
  }

  Future<void> loadMatches() async {
    userIDs = await FireStoreDataBase().getLikedEncountersIDs(FirebaseAuth.instance.currentUser!.uid);
    for(var userID in userIDs){
      var otherUserMatchesIDs = await FireStoreDataBase().getLikedEncountersIDs(userID);
      
      if(otherUserMatchesIDs.contains(FirebaseAuth.instance.currentUser?.uid)){
        UserModel? currentUser = await FireStoreDataBase().getUserModelByID(userID);
        if(currentUser != null && !(userModels.contains(currentUser))){
          lastMatch = currentUser;
          userModels.add(currentUser);
        }
      }
    }
    notifyListeners();
  }
}