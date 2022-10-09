import 'package:flutter/material.dart';
import 'package:roomies_app/backend/users_api.dart';
import 'package:roomies_app/models/user_profile_model.dart';

class CurrentUserProvider extends ChangeNotifier {
  UserProfileModel? currentUser;
  List<dynamic> userImages = [];
  
  Future<void> initialize() async {
    currentUser = await UsersAPI().getCurrentUserProfile();
    initializeUserImages();
    notifyListeners();
  }

  Future<void> initializeUserImages() async {
    if(userImages.isEmpty){
      for(var url in currentUser!.imageURLS){
        userImages.add(url);
        
      }
      notifyListeners();
    }
  }
}