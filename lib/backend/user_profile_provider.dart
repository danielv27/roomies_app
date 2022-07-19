import 'package:flutter/material.dart';
import 'package:roomies_app/models/user_profile_model.dart';
import 'database.dart';

class UserProfileProvider extends ChangeNotifier {
  List<UserProfileModel>? userProfileModels;
  int pagesSwiped = 0;
  
  void trimList(){
    //remove elements from beggining of array depending on how many page were swiped
  }

  void incrementIndex(){
    print('original PagesSwiped $pagesSwiped');
    pagesSwiped++;
    print('new pagesSwiped: $pagesSwiped');
    loadUsers(1);
  }

  void loadUsers(int limit) async {
    userProfileModels == null ? {
      userProfileModels = await FireStoreDataBase().getUsersImages(limit),
      
    }:
    {
      FireStoreDataBase().getUsersImages(limit).then((newUsers) => newUsers !=null ?userProfileModels?.addAll(newUsers):null),
    };
    notifyListeners();
  }
}