import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  final String email;
  final String firstName;
  final String lastName;
  // final DateTime dateOfBirth;
  final bool isHouseOwner;

  UserModel({
    this.id = '',
    required this.email,
    required this.firstName,
    required this.lastName,
    // required this.dateOfBirth,
    this.isHouseOwner = false
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