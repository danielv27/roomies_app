import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roomies_app/backend/houses_api.dart';
import 'package:roomies_app/backend/users_api.dart';
import 'package:roomies_app/models/house_profile_model.dart';
import 'package:roomies_app/models/user_model.dart';

class MatchesProvider extends ChangeNotifier {
  List<UserModel> matches = [];
  List<HouseProfileModel> likedHouses = [];
  
  Future<void> initialize() async {
    final currentUserID = FirebaseAuth.instance.currentUser?.uid;
    if(currentUserID != null){
      matches = await UsersAPI().getMatches(currentUserID);
      likedHouses = await HousesAPI().getLikedHouses(currentUserID);
    }

    notifyListeners();
  }

  Future<HouseProfileModel?> getHouseProfileModelByID(houseID) async {
    for(var house in likedHouses){
      if(houseID == house.houseID){
        return house;
      }
    }
    return null;
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
      List<String> newUserIDs = [];
      currentUser != null? newUserIDs = await UsersAPI().getLikedEncountersIDs(currentUser):null;
      final List<UserModel> newUserModels = await loadMatches(newUserIDs);
      if(newUserModels.length != matches.length){
        for(var user in newUserModels){
          if(!matches.contains(user)){
            yield user;
          }
        }
        matches = newUserModels;
      }
      await Future.delayed(const Duration(seconds: 2));
    }
  }


}