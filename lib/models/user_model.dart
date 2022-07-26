import 'package:flutter/material.dart';
import 'package:roomies_app/models/user_profile_model.dart';

import 'house_profile_model.dart';

class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final bool isHouseOwner;
  final String firstImgUrl; 
  final UserSignupProfileModel userSignupProfileModel;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.isHouseOwner,
    required this.firstImgUrl, 
    required this.userSignupProfileModel,
  });

  @override
  bool operator ==(other) => other is UserModel && id == other.id;
  
  @override
  int get hashCode => hashValues(id, email);
}

class HouseOwner {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final bool isHouseOwner;
  final HouseSignupProfileModel houseSignupProfileModel;

  HouseOwner({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.isHouseOwner = true,
    required this.houseSignupProfileModel,
  });
}