import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:roomies_app/backend/houses_api.dart';
import 'package:roomies_app/models/user_model.dart';

class CurrentHouseProvider extends ChangeNotifier {
  HouseOwner? currentUser;
  Stream<QuerySnapshot<Object?>>? houses;

  Future<void> initialize() async {
    currentUser = await HousesAPI().getCurrentHouseModel();
    notifyListeners();
  }

  Future<void> getAllHouses() async {
    houses = await HousesAPI().getHouses();
    notifyListeners();
  }
}