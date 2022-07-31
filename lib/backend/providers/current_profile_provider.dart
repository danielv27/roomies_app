import 'package:flutter/material.dart';
import 'package:roomies_app/backend/users_api.dart';
import 'package:roomies_app/models/user_profile_model.dart';

class CurrentUserProvider extends ChangeNotifier {
  UserProfileModel? currentUser;
  
  Future<void> initialize() async {
    currentUser = await UsersAPI().getCurrentUserProfile();
    notifyListeners();
  }
}