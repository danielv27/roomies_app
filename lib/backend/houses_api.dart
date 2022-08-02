import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
            List<HouseSignupProfileModel> housesSignupProfileModel = await getHousesProfile(houseDoc.id);
            for (var houseProfile in housesSignupProfileModel) {
              HouseOwner houseOwnerHouses = HouseOwner(
                id: houseDoc.id,
                email: houseDoc['email'],
                firstName: houseDoc['firstName'],
                lastName: houseDoc['lastName'],
                isHouseOwner: houseDoc['isHouseOwner'],
                houseSignupProfileModel: houseProfile,
              );
              houseList.add(houseOwnerHouses);
            }
          }
        }
      );
      return houseList;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }


  // Future<List<HouseProfileModel>?> getNewHouseProfileModels(int limit) async {
  //   List<HouseOwner>? houseOwners = await getNewHouses(limit, null);
  //   List<HouseProfileModel>? housesProfileModel = [];
  //   try{  
  //     for (var houseOwner in houseOwners!) {
  //       await FirebaseFirestore.instance.collection('users')
  //         .doc(houseOwner.id)
  //         .collection('houses_profile')
  //         .get()
  //         .then((querySnapshot) {
  //           HouseProfileModel houseProfileModel = HouseProfileModel(
  //             houseOwner: houseOwner,
  //             imageURLS: houseOwner.houseSignupProfileModel.houseProfileImages,
  //           );
  //           housesProfileModel.add(houseProfileModel);
  //         });
  //     }
  //     return housesProfileModel;
  //   } catch (e) {
  //     debugPrint("Error - $e");
  //     return null;
  //   }
  // }

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
          List<dynamic>? houseProfileImages = await getHouseImages(house.data()['ImagesRef']);

          HouseSignupProfileModel? houseSignupProfileModel = await getHouseSignupProfileModel(house.data()['houseRef'], houseProfileImages);

          HouseOwner? houseOwnerHouse = await getHouseOwnerModel(house.data()['houseRef'], houseSignupProfileModel);

          String houseRef = house.data()['houseRef'];
          final splittedHouseRef = houseRef.split('/');

          HouseProfileModel houseProfileModel = HouseProfileModel(
            houseOwner: houseOwnerHouse!,
            imageURLS: houseProfileImages,
            houseRef: splittedHouseRef.last
          );
          housesProfileModel.add(houseProfileModel);
        }
      });
    return housesProfileModel;
  }
  
  Future<List> getHouseImages(imagesRef) async {
    final splitImagesRef = imagesRef.split('/');
    String users = splitImagesRef[0];
    String userID = splitImagesRef[1];
    String housesProfile = splitImagesRef[2];
    String docID = splitImagesRef[3];
    String houseImages = splitImagesRef[4];

    List<dynamic> houseProfileImages = [];
    await FirebaseFirestore.instance.collection(users)
      .doc(userID)
      .collection(housesProfile)
      .doc(docID)
      .collection(houseImages)
      .get()
      .then((houseImgaesQuery) {
        for (var images in houseImgaesQuery.docs) {
          houseProfileImages = images['urls'];
        }
      });
    return houseProfileImages;
  }
  
  Future<HouseSignupProfileModel?> getHouseSignupProfileModel(houseRef, houseProfileImages) async {
    final splitHouseRef = houseRef.split('/');
    String users = splitHouseRef[0];
    String userID = splitHouseRef[1];
    String housesProfile = splitHouseRef[2];
    String houseID = splitHouseRef[3];

    HouseSignupProfileModel? houseSignupProfileModel;
    await FirebaseFirestore.instance.collection(users)
      .doc(userID)
      .collection(housesProfile)
      .doc(houseID)
      .get()
      .then((house) {
        houseSignupProfileModel = HouseSignupProfileModel(
          postalCode: house['postalCode'],
          houseNumber: house['houseNumber'],
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
  
  Future<HouseOwner?> getHouseOwnerModel(houseRef, houseSignupProfileModel) async {
    final splitHouseRef = houseRef.split('/');
    String users = splitHouseRef[0];
    String userID = splitHouseRef[1];

    HouseOwner? houseOwnerHouse;
    await FirebaseFirestore.instance.collection(users)
      .doc(userID)
      .get()
      .then((houseOwner) {
          houseOwnerHouse = HouseOwner(
            id: houseOwner.id,
            email: houseOwner['email'],
            firstName: houseOwner['firstName'],
            lastName: houseOwner['lastName'],
            isHouseOwner: houseOwner['isHouseOwner'],
            houseSignupProfileModel: houseSignupProfileModel,
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

  Future<List<String>?> getLikedHousesIDs(String? currentUserID) async {
    List<String> likedHouses = [];
    await FirebaseFirestore.instance.collection('users/$currentUserID/house_encounters')
    .get()
    .then((querySnapshot) {
      for(var doc in querySnapshot.docs){
        likedHouses.add(doc.id);
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
        List<dynamic>? houseProfileImages = await getHouseImages(house.data()['ImagesRef']);

        HouseSignupProfileModel? houseSignupProfileModel = await getHouseSignupProfileModel(house.data()['houseRef'], houseProfileImages);

        HouseOwner? houseOwnerHouse = await getHouseOwnerModel(house.data()['houseRef'], houseSignupProfileModel);

        String houseRef = house.data()['houseRef'];
        final splittedHouseRef = houseRef.split('/');

        HouseProfileModel houseProfileModel = HouseProfileModel(
          houseOwner: houseOwnerHouse!,
          imageURLS: houseProfileImages,
          houseRef: splittedHouseRef.last,
        );
        housesProfileModel.add(houseProfileModel);
      }
    });
    return housesProfileModel;
  }

}