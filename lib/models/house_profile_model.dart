import 'package:flutter/material.dart';

import 'user_model.dart';

class HouseProfileModel {
  final HouseOwner houseOwner;
  final List<dynamic> imageURLS;
  final String houseRef;

  HouseProfileModel({
    required this.houseOwner,
    required this.imageURLS,
    required this.houseRef,
  });

  @override
  bool operator ==(other) => other is HouseProfileModel && houseOwner.id == other.houseOwner.id;
  
  @override
  int get hashCode => hashValues(houseOwner, imageURLS);  
  
}

class HouseSignupProfileModel {
  String postalCode;
  String houseNumber; 
  String constructionYear; 
  String livingSpace;
  String plotArea;
  String propertyCondition; 
  String houseDescription;
  String furnished;
  String numRoom;
  String availableRoom;
  String pricePerRoom;
  String contactName;
  String contactEmail;
  String contactPhoneNumber;
  List<dynamic> houseProfileImages;

  HouseSignupProfileModel({
    required this.postalCode, 
    required this.houseNumber, 
    required this.constructionYear, 
    required this.livingSpace, 
    required this.plotArea, 
    required this.propertyCondition, 
    required this.houseDescription, 
    required this.furnished, 
    required this.numRoom, 
    required this.availableRoom, 
    required this.pricePerRoom, 
    required this.contactName, 
    required this.contactEmail, 
    required this.contactPhoneNumber, 
    required this.houseProfileImages,
  });

}