import 'package:flutter/material.dart';
import 'package:roomies_app/backend/users_api.dart';
import 'package:roomies_app/models/user_profile_model.dart';

class UserProfileProvider extends ChangeNotifier {
  List<UserProfileModel>? userProfileModels;
  int pagesSwiped = 0;
  
  void trimList(){
    //remove elements from beggining of array depending on how many page were swiped
  }

  Future<void> incrementIndex() async {
    pagesSwiped++;
    print('pagesSwiped: $pagesSwiped');
    await loadUsers(20);
  }

  Future<void> loadUsers(int limit) async {
    userProfileModels == null ? {
      userProfileModels = await UsersAPI().getNewUserProfileModels(limit),
    }:
    {
      await UsersAPI().getNewUserProfileModels(limit).then((newUsers) {
        if(newUsers != null){
          for(var user in newUsers){
            if(!userProfileModels!.contains(user)){
              userProfileModels?.add(user);
            }
          }
        }
      })
    };
    notifyListeners();
  }
}