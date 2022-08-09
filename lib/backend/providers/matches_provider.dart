import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roomies_app/backend/chat_api.dart';
import 'package:roomies_app/backend/users_api.dart';
import 'package:roomies_app/models/user_model.dart';

class MatchesProvider extends ChangeNotifier {
  List<UserModel> userModels = [];
  
  Future<void> initialize() async {
    final currentUserID = FirebaseAuth.instance.currentUser?.uid;
    currentUserID != null? userModels = await UsersAPI().getMatches(currentUserID):null;
    notifyListeners();
    for(var userModel in userModels){
      final DateTime? timeStamp = await ChatAPI().getLastPrivateMessageTimeStamp(currentUserID, userModel.id);
      final String message = await ChatAPI().getLastPrivateMessage(currentUserID, userModel.id);
      userModel.setTimeStamp(timeStamp);
      userModel.setLastMessage(message);
      sortByTimeStamp();
      notifyListeners();
    }
  }

  // Stream<List<UserModel>> checkForChanges() async* {
  //   List<UserModel> initialUserModels = List.from(userModels);
  //   while(true){
  //     await Future.delayed(const Duration(seconds: 3));
  //     if(userModels.isNotEmpty && userModels[0] != initialUserModels[0]){
  //       yield userModels;
  //       initialUserModels = userModels;
  //     }
  //   }
  // }

  void sortByTimeStamp(){
    userModels.sort((a, b) {
    if(a.timeStamp == null && b.timeStamp == null){
      return 0;
    }
    if(a.timeStamp == null){
      return 1;
    }
    if(b.timeStamp == null){
      return -1;
    }
    return b.timeStamp.toString().compareTo(a.timeStamp.toString());
    });
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

  //while loop should listen to a stream controller to avoid data leaks
  Stream<UserModel> listenToMatches(StreamController? streamController) async* {
    final currentUser = FirebaseAuth.instance.currentUser?.uid;
    while(streamController != null && !streamController.isClosed){
      print('listening..');
      List<String> newUserIDs = [];
      currentUser != null? newUserIDs = await UsersAPI().getLikedEncountersIDs(currentUser):null;
      final List<UserModel> newUserModels = await loadMatches(newUserIDs);
      if(newUserModels.length != userModels.length){
        for(var user in newUserModels){
          if(!userModels.contains(user)){
            yield user;
          }
        }
        userModels = newUserModels;
      }
      await Future.delayed(const Duration(seconds: 2));
    }
  }


}