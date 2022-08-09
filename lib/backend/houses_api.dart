import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roomies_app/backend/users_api.dart';
import 'package:roomies_app/models/house_profile_model.dart';
import 'package:roomies_app/models/user_model.dart';

class HousesAPI {

  Future<HouseOwner?> getCurrentHouseModel() async {
    try {
      HouseOwner? currentHouseOwner;
      await FirebaseFirestore.instance.collection("users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .get()
      .then((houseDoc) async {
        List<HouseSignupProfileModel> housesSignupProfileModel = await getHousesProfile(houseDoc.id);
        currentHouseOwner = HouseOwner(
          id: houseDoc.id,
          email: houseDoc['email'],
          firstName: houseDoc['firstName'],
          lastName: houseDoc['lastName'],
          isHouseOwner: houseDoc['isHouseOwner'],
          houseSignupProfileModel: housesSignupProfileModel[0],
        );
      });
      return currentHouseOwner;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }

  Future<List<HouseSignupProfileModel>> getHousesProfile(String? currentUserID) async{
    List<HouseSignupProfileModel> housesSignupProfileModel = [];
    await FirebaseFirestore.instance.collection('users')
      .doc(currentUserID)
      .collection('houses_profile')
      .get()
      .then((querySnapshot) async {
        for (var house in querySnapshot.docs) {
          List<dynamic> houseProfileImages = [];
          await house.reference.collection('house_images')
            .get()
            .then((houseImages) {
              for (var images in houseImages.docs) {
                houseProfileImages = images['urls'];
              }
              HouseSignupProfileModel houseSignupProfileModel = HouseSignupProfileModel(
                postalCode: house['postalCode'],
                houseNumber: house['houseNumber'],
                streetName: house['streetName'],
                cityName: house['cityName'],
                latLng: house['latLng'],
                constructionYear: house['constructionYear'], 
                livingSpace: house['livingSpace'], 
                plotArea: house['plotArea'], 
                propertyCondition: house['propertyCondition'], 
                houseDescription: house['houseDescription'],
                furnished: house['isFurnished'],
                numRoom: house['numberRooms'],
                availableRoom: house['numberAvailableRooms'],
                pricePerRoom: house['pricePerRoom'],
                contactName: house['contactName'],
                contactEmail: house['contactEmail'],
                contactPhoneNumber: house['contactPhoneNumber'],
                houseProfileImages: houseProfileImages,
              );
              housesSignupProfileModel.add(houseSignupProfileModel);
            });
          }
      });
    return housesSignupProfileModel;
  }

  Future<Stream<QuerySnapshot<Object?>>> getUserHouses() async {
    String? currentUserID = FirebaseAuth.instance.currentUser?.uid;
    final Stream<QuerySnapshot> housesStream = FirebaseFirestore.instance.collection('users/$currentUserID/houses_profile').snapshots();
    return housesStream;
  }

  Future<List<HouseProfileModel>?> getNewHousesModels(int limit) async {
    List<HouseProfileModel>? houses = await getHouses(limit);
    List<HouseProfileModel>? houseProfileModels = [];

    try{  
      for (var house in houses!) {
        late List<dynamic> userProfileImages = [];
        late HouseProfileModel houseProfileModel;
        await FirebaseFirestore.instance.collection('users/${house.houseOwner.id}/houses_profile')
          .doc(house.houseRef)
          .collection('house_images')
          .get()
          .then((querySnapshot) {
            for (var doc in querySnapshot.docs) {
              userProfileImages = doc.data()['urls'];
            }
            houseProfileModel = HouseProfileModel(
              houseOwner: house.houseOwner,
              imageURLS: userProfileImages,
              houseRef: house.houseRef,
            );
          });
        houseProfileModels.add(houseProfileModel);
      }
      return houseProfileModels;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }

  Future<List<HouseProfileModel>?> getHouses(int limit) async {
    List<HouseProfileModel> housesProfileModel = [];
    List<String>? likedHouses = await getLikedHousesIDs(FirebaseAuth.instance.currentUser!.uid);
    likedHouses!.add(FirebaseAuth.instance.currentUser!.uid);

    await FirebaseFirestore.instance.collection('houses')
      .limit(limit)
      .where(FieldPath.documentId, whereNotIn: likedHouses)
      .get()
      .then((housesQuery) async {
        for (var house in housesQuery.docs) { 
          final String houseRef = house.data()['houseRef'];
          final String userID = house.data()['userID'];

          List<dynamic>? houseProfileImages = await getHouseImages(houseRef, userID);
          HouseSignupProfileModel? houseSignupProfileModel = await getHouseSignupProfileModel(houseRef, userID, houseProfileImages);
          HouseOwner? houseOwnerHouse = await getHouseOwnerModel(houseRef, userID, houseSignupProfileModel!);

          HouseProfileModel houseProfileModel = HouseProfileModel(
            houseOwner: houseOwnerHouse!,
            imageURLS: houseProfileImages,
            houseRef: houseRef,
          );
          housesProfileModel.add(houseProfileModel);
        }
      });
    return housesProfileModel;
  }
  
  Future<List> getHouseImages(houseRef, userID) async {

    List<dynamic> houseProfileImages = [];
    await FirebaseFirestore.instance.collection('users')
      .doc(userID)
      .collection('houses_profile')
      .doc(houseRef)
      .collection('house_images')
      .get()
      .then((houseImgaesQuery) {
        for (var images in houseImgaesQuery.docs) {
          houseProfileImages = images['urls'];
        }
      });
    return houseProfileImages;
  }
  
  Future<HouseSignupProfileModel?> getHouseSignupProfileModel(houseRef, userID, houseProfileImages) async {
    HouseSignupProfileModel? houseSignupProfileModel;
    await FirebaseFirestore.instance.collection('users')
      .doc(userID)
      .collection('houses_profile')
      .doc(houseRef)
      .get()
      .then((house) {
        houseSignupProfileModel = HouseSignupProfileModel(
          postalCode: house['postalCode'],
          houseNumber: house['houseNumber'],
          apartmentNumber: house['apartmentNumber'],
          streetName: house['streetName'],
          cityName: house['cityName'],
          latLng: house['latLng'],
          constructionYear: house['constructionYear'], 
          livingSpace: house['livingSpace'], 
          plotArea: house['plotArea'], 
          propertyCondition: house['propertyCondition'], 
          houseDescription: house['houseDescription'],
          furnished: house['isFurnished'],
          numRoom: house['numberRooms'],
          availableRoom: house['numberAvailableRooms'],
          pricePerRoom: house['pricePerRoom'],
          contactName: house['contactName'],
          contactEmail: house['contactEmail'],
          contactPhoneNumber: house['contactPhoneNumber'],
          houseProfileImages: houseProfileImages,
        );
      });
    return houseSignupProfileModel;
  }
  
  Future<HouseOwner?> getHouseOwnerModel(houseRef, userID, HouseSignupProfileModel houseSignupProfileModel) async {
    HouseOwner? houseOwnerHouse;
    await FirebaseFirestore.instance.collection('users')
      .doc(userID)
      .get()
      .then((houseOwner) async {
          houseOwnerHouse = HouseOwner(
            id: houseOwner.id,
            email: houseOwner['email'],
            firstName: houseOwner['firstName'],
            lastName: houseOwner['lastName'],
            isHouseOwner: houseOwner['isHouseOwner'],
            houseSignupProfileModel: houseSignupProfileModel,
            location: houseSignupProfileModel.latLng,
          );
      });
    return houseOwnerHouse;
  }

  Future<void> addHouseEncounter(bool liked, String currentUserID, String? houseID) async {
    await FirebaseFirestore.instance.collection('users/$currentUserID/house_encounters')
    .doc(houseID)
    .set({ 
      'liked': liked,
      'timeStamp': DateTime.now(),
    });
  }

  Future<void> addUserEncounter(String houseOwnerID, String? houseID, String currentUserID) async {
    await FirebaseFirestore.instance.collection('users')
    .doc(houseOwnerID)
    .collection('houses_profile')
    .doc(houseID)
    .collection('liked')
    .doc(currentUserID)
    .set({ 
      'user': currentUserID,
      'timeStamp': DateTime.now(),
    });
  }

  Future<List<UserModel>> getUserEncounters(String houseOwnerID, String? houseID) async {
    List<String> matchesIDs = [];
    List<UserModel> housemMatches = [];

    await FirebaseFirestore.instance.collection('users')
    .doc(houseOwnerID)
    .collection('houses_profile')
    .doc(houseID)
    .collection('liked')
    .get()
    .then((usersID) {
      for (var user in usersID.docs) {
        matchesIDs.add(user['user']);
      }
    });
    for(var id in matchesIDs){
      UserModel? userModel = await UsersAPI().getUserModelByID(id);
      userModel != null ? housemMatches.add(userModel) : null;
    }
    return housemMatches;
  }

  Future<List<String>?> getLikedHousesIDs(String? currentUserID) async {
    List<String> likedHouses = [];
    await FirebaseFirestore.instance.collection('users/$currentUserID/house_encounters')
    .get()
    .then((querySnapshot) {
      for(var doc in querySnapshot.docs){
        if (doc['liked']) {
          likedHouses.add(doc.id);
        }
      }
    });
    return likedHouses;
  }

  Future<List<HouseProfileModel>> getLikedHouses(String? currentUser) async {
    List<HouseProfileModel> housesProfileModel = [];

    List<String>? likedHouses = await getLikedHousesIDs(currentUser);
    await FirebaseFirestore.instance.collection('houses')
    .where(FieldPath.documentId, whereIn: likedHouses)
    .get()
    .then((querySnapshot) async {
      for(var house in querySnapshot.docs) {
          final String houseRef = house.data()['houseRef'];
          final String userID = house.data()['userID'];

          List<dynamic>? houseProfileImages = await getHouseImages(houseRef, userID);
          HouseSignupProfileModel? houseSignupProfileModel = await getHouseSignupProfileModel(houseRef, userID, houseProfileImages);
          HouseOwner? houseOwnerHouse = await getHouseOwnerModel(houseRef, userID, houseSignupProfileModel!);

          HouseProfileModel houseProfileModel = HouseProfileModel(
            houseOwner: houseOwnerHouse!,
            imageURLS: houseProfileImages,
            houseRef: houseRef,
          );
          housesProfileModel.add(houseProfileModel);
      }
    });
    return housesProfileModel;
  }

}