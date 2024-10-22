
import 'package:flutter/material.dart';
import 'package:roomies_app/backend/database.dart';

class SetUpCompletionProvider extends ChangeNotifier {
  bool profileSetUp = false;
  bool houseSetUp = false;
  
  Stream<void> checkIfSetUpComplete() async* {
    while(!profileSetUp && !houseSetUp){
      await Future.delayed(const Duration(milliseconds: 200));
      print('checking if setup complete');
      notifyListeners();
      bool newProfileStatus = await FireStoreDataBase().checkIfCurrentUserProfileComplete();
      if(profileSetUp != newProfileStatus){
        profileSetUp = newProfileStatus;
        notifyListeners();
      }
      bool newHouseStatus = await FireStoreDataBase().checkIfCurrentUserHouseComplete();
      if(houseSetUp != newHouseStatus){
        houseSetUp = newHouseStatus;
        notifyListeners();
      }
      await Future.delayed(const Duration(seconds: 1));
    }
    
  }
}