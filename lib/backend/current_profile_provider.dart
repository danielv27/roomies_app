import 'package:flutter/material.dart';
import 'package:roomies_app/backend/database.dart';
import 'package:roomies_app/models/user_profile_model.dart';

class CurrentUserProvider extends ChangeNotifier {
  UserProfileModel? currentUser;
  
  Future<void> initialize() async {
    currentUser = await FireStoreDataBase().getCurrentUserProfile();
    notifyListeners();
  }
}