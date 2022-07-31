import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roomies_app/models/house_profile_images.dart';
import 'package:roomies_app/models/house_profile_model.dart';
import 'package:roomies_app/models/user_model.dart';

class HousesAPI {

  Future<HouseOwner?> getCurrentHouseModel() async {
    try {
      HouseOwner? currentUser;
      await FirebaseFirestore.instance.collection("users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .get()
      .then((houseDoc) async {
        HouseSignupProfileModel? houseSignupProfileModel = await getHouseProfile(houseDoc.id);
        currentUser = HouseOwner(
          id: houseDoc.id,
          email: houseDoc['email'],
          firstName: houseDoc['firstName'],
          lastName: houseDoc['lastName'],
          isHouseOwner: houseDoc['isHouseOwner'],
          houseSignupProfileModel: houseSignupProfileModel,
        );
      });
      return currentUser;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }

  Future<HouseOwner?> getHouseModelByID(String? userID) async {
    try {
      HouseOwner? houseOwner;
      HouseSignupProfileModel? houseSignupProfileModel = await getHouseProfile(userID);

      await FirebaseFirestore.instance.collection("users")
      .doc(userID)
      .get()
      .then((houseDoc) {
        houseOwner = HouseOwner(
          id: houseDoc.id,
          email: houseDoc['email'],
          firstName: houseDoc['firstName'],
          lastName: houseDoc['lastName'],
          isHouseOwner: houseDoc['isHouseOwner'],
          houseSignupProfileModel: houseSignupProfileModel,
        );
      });
      return houseOwner;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }

  Future<List<HouseOwner>?> getNewHouses(int limit, List<String?>? currentEncounters) async {
    try {
      List<HouseOwner> houseList = [];
      // List<String?>? encounters = await getEncountersIDs(FirebaseAuth.instance.currentUser?.uid);
      // encounters!.add(FirebaseAuth.instance.currentUser?.uid);
      await FirebaseFirestore.instance.collection("users")
      .limit(limit)
      .where('isHouseOwner',isEqualTo: true)
      // .where(FieldPath.documentId, whereNotIn: encounters)
      .get()
      .then(
        (querySnapshot) async {
          for (var houseDoc in querySnapshot.docs) {
            HouseSignupProfileModel houseSignupProfileModel = await getHouseProfile(houseDoc.id);
            HouseOwner newHouse = HouseOwner(
              id: houseDoc.id,
              email: houseDoc['email'],
              firstName: houseDoc['firstName'],
              lastName: houseDoc['lastName'],
              isHouseOwner: houseDoc['isHouseOwner'],
              houseSignupProfileModel: houseSignupProfileModel,
            );
            houseList.add(newHouse);
          }
        }
      );
      return houseList;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }


  Future<List<HouseProfileModel>?> getNewHouseProfileModels(int limit) async {
    List<HouseOwner>? houses = await getNewHouses(limit, null);
    List<HouseProfileModel>? housesProfileModel = [];

    try{  
      for (var house in houses!) {
        late HouseProfileModel houseProfileModel;
        late List<dynamic> houseProfileImages = [];

        await FirebaseFirestore.instance.collection('users/${house.id}/house_images')
          .get()
          .then((querySnapshot) {
            for (var doc in querySnapshot.docs) {
              houseProfileImages = doc.data()['urls'];
            }
            houseProfileModel = HouseProfileModel(
              houseOwner: house,
              imageURLS: houseProfileImages,
            );
          });
        housesProfileModel.add(houseProfileModel);
      }
      return housesProfileModel;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }

    Future<HouseProfileModel?> getCurrentUserProfile() async {
    try {
      HouseOwner? houseOwner = await getCurrentHouseModel();  
      HouseProfileModel? houseProfileModel;
      late List<dynamic> houseProfileImages = [];

      await FirebaseFirestore.instance.collection('users/${houseOwner?.id}/house_images')
        .get()
        .then((querySnapshot) {
          for (var doc in querySnapshot.docs) {
            houseProfileImages = doc.data()['urls'];
          }
          houseProfileModel = HouseProfileModel(
            houseOwner: houseOwner!,
            imageURLS: houseProfileImages,
          );
        });
      return houseProfileModel;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }

  Future<HouseProfileImages?> getHousesImagesById(String? currentUserID) async{
    try{ 
      late HouseProfileImages houseProfileImagesModel;
      late List<dynamic> houseProfileImages = [];

      await FirebaseFirestore.instance.collection('users/$currentUserID/house_images')
        .get()
        .then((querySnapshot) {
          for (var doc in querySnapshot.docs) {
            houseProfileImages = doc['urls'];
          }
          houseProfileImagesModel = HouseProfileImages(
            imageURLS: houseProfileImages,
          );
        });
      return houseProfileImagesModel;
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