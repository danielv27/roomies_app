import 'package:flutter/material.dart';
import 'package:roomies_app/backend/database.dart';
import 'package:roomies_app/models/user_model.dart';

class CurrentHouseProvider extends ChangeNotifier {
  HouseOwner? currentUser;
  
  Future<void> initialize() async {
    currentUser = await FireStoreDataBase().getCurrentHouseModel();
    notifyListeners();
  }
}