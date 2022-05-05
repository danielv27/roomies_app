import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FireStoreDataBase {
  List userList = [];
  final CollectionReference collectionRef = FirebaseFirestore.instance.collection("users");

  Future getData() async {
    try {
      await collectionRef.get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          userList.add(result.data());
        }
      });
      return userList;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }
}