import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'database.dart';

class MatchesProvider extends ChangeNotifier {
  List<String> userIDs = [];
  List<UserModel> userModels = [];
  UserModel? lastMatch;
  

  //probably not the way to do it but we do need to check wether the user matched with anyone in the background
  Stream<UserModel> listenToMatches() async* {
    while(true){
      List<String> newUserIDs = await FireStoreDataBase().getLikedEncountersIDs(FirebaseAuth.instance.currentUser!.uid);
      final List<UserModel> newUserModels = await loadMatches(newUserIDs);
      notifyListeners();
      if(newUserModels.length != userModels.length){
        for(var user in newUserModels){
          if(!userModels.contains(user)){
            yield user;
          }
        }
        userModels = newUserModels;
         // should in the future be replace to the currently added user
        notifyListeners();
      }
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  Future<List<UserModel>> loadMatches(List<String> newUserIDs) async {
    final List<UserModel> newUserModels = [];
    for(var userID in newUserIDs){
      var otherUserMatchesIDs = await FireStoreDataBase().getLikedEncountersIDs(userID);
      if(otherUserMatchesIDs.contains(FirebaseAuth.instance.currentUser?.uid)){
        UserModel? currentUser = await FireStoreDataBase().getUserModelByID(userID);
        if(currentUser != null && !(newUserModels.contains(currentUser))){
          newUserModels.add(currentUser);
        }
      }
    }
    return newUserModels;
  }
}