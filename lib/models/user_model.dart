import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  // final DateTime dateOfBirth;
  final bool isHouseOwner;
  /*
  this would most likely just be the first image 
  the user places in their profile and for a 
  house owner the same logic applies but with a house image
  */
  final String firstImgUrl; 

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.isHouseOwner,
    required this.firstImgUrl,
  });
}

class HouseOwner {
  String id;
  final String email;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final bool isHouseOwner;

  HouseOwner({
    this.id = '',
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    this.isHouseOwner = true
  });
}