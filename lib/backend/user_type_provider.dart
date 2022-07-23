import 'dart:ffi';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:roomies_app/backend/database.dart';
import 'package:roomies_app/models/user_profile_model.dart';

class UserTypeProvider extends ChangeNotifier {
  String? isHouseOwner;
  bool profileSetUp = false;
  
  
  Future<void> getCurrentUserType() async {
    isHouseOwner = await FireStoreDataBase().getCurrentUserType();
    notifyListeners();
  }

  Stream<void> checkIfUserSetUpProfile() async* {
    profileSetUp = await FireStoreDataBase().checkIfCurrentUserProfileComplete();
    while(!profileSetUp){
      await Future.delayed(const Duration(seconds: 1));
      print('event');
      bool newStatus = await FireStoreDataBase().checkIfCurrentUserProfileComplete();
      if(profileSetUp != newStatus){
        profileSetUp = newStatus;
        notifyListeners();
      }
    }
    
  }
}