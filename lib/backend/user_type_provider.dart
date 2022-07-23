import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:roomies_app/backend/database.dart';
import 'package:roomies_app/models/user_profile_model.dart';

class UserTypeProvider extends ChangeNotifier {
  String? isHouseOwner;
  String? uid;
  
  Future<void> getType(uid) async {
    isHouseOwner = await FireStoreDataBase().getUserType(uid);
    notifyListeners();
  }
}