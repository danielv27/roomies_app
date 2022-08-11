import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:roomies_app/models/user_profile_model.dart';

import 'house_profile_model.dart';

class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final bool isHouseOwner;
  final UserSignupProfileModel userSignupProfileModel;
  final CachedNetworkImageProvider firstImageProvider;
  final String location;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.isHouseOwner,
    required this.userSignupProfileModel,
    required this.location,
    required this.firstImageProvider,
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
  final String? location;

  HouseOwner({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.isHouseOwner = true,
    required this.houseSignupProfileModel,
    this.location,
  });
}