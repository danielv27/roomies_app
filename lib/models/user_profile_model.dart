import 'package:flutter/material.dart';

import 'user_model.dart';

class UserProfileModel {
  final UserModel userModel;
  final List<dynamic> imageURLS;

  UserProfileModel({
    required this.userModel,
    required this.imageURLS,
  });

  @override
  bool operator ==(other) => other is UserProfileModel && userModel.id == other.userModel.id;
  
  @override
  int get hashCode => hashValues(userModel, imageURLS);  
  
}

class UserSignupProfileModel {
  String radius;
  String minBudget; 
  String maxBudget; 
  String about;
  String work;
  String study; 
  String roommate; 
  String birthdate;
  String latLng;
  String cityName;
  String streetName;

  UserSignupProfileModel({
    required this.minBudget, 
    required this.maxBudget, 
    required this.about, 
    required this.work, 
    this.study = "", 
    required this.roommate, 
    required this.birthdate,
    this.radius = "0",
    required this.latLng,
    required this.cityName,
    required this.streetName,
  });

}