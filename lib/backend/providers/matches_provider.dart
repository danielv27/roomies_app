import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roomies_app/backend/users_api.dart';
import 'package:roomies_app/models/user_model.dart';

class MatchesProvider extends ChangeNotifier {
  List<UserModel> userModels = [];
  
  Future<void> initialize() async {
    final currentUser = FirebaseAuth.instance.currentUser?.uid;
    currentUser != null? userModels = await UsersAPI().getMatches(currentUser):null;
  }

  Future<List<UserModel>> loadMatches(List<String> newUserIDs) async {
    final List<UserModel> newUserModels = [];
    for(var userID in newUserIDs){
      var otherUserMatchesIDs = await UsersAPI().getLikedEncountersIDs(userID);
      if(otherUserMatchesIDs.contains(FirebaseAuth.instance.currentUser?.uid)){
        UserModel? currentUser = await UsersAPI().getUserModelByID(userID);
        if(currentUser != null && !(newUserModels.contains(currentUser))){
          newUserModels.add(currentUser);
        }
      }
    }
    return newUserModels;
  }

  //probably not the way to do it but we do need to check wether the user matched with anyone in the background
  Stream<UserModel> listenToMatches() async* {
    final currentUser = FirebaseAuth.instance.currentUser?.uid;
    while(true){
      List<String> newUserIDs = [];
      currentUser != null? newUserIDs = await UsersAPI().getLikedEncountersIDs(currentUser):null;
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


}