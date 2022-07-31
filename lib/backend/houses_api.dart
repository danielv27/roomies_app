import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roomies_app/models/house_profile_model.dart';
import 'package:roomies_app/models/user_model.dart';

class HousesAPI {

  Future<HouseOwner?> getCurrentHouseModel() async {
    try {
      HouseOwner? currentUser;
      await FirebaseFirestore.instance.collection("users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .get()
      .then((userDoc) async {
        HouseSignupProfileModel? houseSignupProfileModel = await getHouseProfile(userDoc.id);
        currentUser = HouseOwner(
          id: userDoc.id,
          email: userDoc['email'],
          firstName: userDoc['firstName'],
          lastName: userDoc['lastName'],
          isHouseOwner: userDoc['isHouseOwner'],
          houseSignupProfileModel: houseSignupProfileModel,
        );
      });
      return currentUser;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }

  Future<HouseSignupProfileModel> getHouseProfile(String? currentUserID) async{
    late HouseSignupProfileModel houseSignupProfileModel;
    await FirebaseFirestore.instance.collection('users/$currentUserID/houses_profile')
      .get()
      .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          houseSignupProfileModel = HouseSignupProfileModel(
            postalCode: doc['postalCode'],
            houseNumber: doc['houseNumber'],
            constructionYear: doc['constructionYear'], 
            livingSpace: doc['livingSpace'], 
            plotArea: doc['plotArea'], 
            propertyCondition: doc['propertyCondition'], 
            houseDescription: doc['houseDescription'],
            furnished: doc['isFurnished'],
            numRoom: doc['numberRooms'],
            availableRoom: doc['numberAvailableRooms'],
            pricePerRoom: doc['pricePerRoom'],
            contactName: doc['contactName'],
            contactEmail: doc['contactEmail'],
            contactPhoneNumber: doc['contactPhoneNumber'],
          );
        }
      });
    return houseSignupProfileModel;
  }

  Future<Stream<QuerySnapshot<Object?>>> getHouses() async {
    String? currentUserID = FirebaseAuth.instance.currentUser?.uid;
    final Stream<QuerySnapshot> housesStream = FirebaseFirestore.instance.collection('users/$currentUserID/houses_profile').snapshots();
    return housesStream;
  }


}