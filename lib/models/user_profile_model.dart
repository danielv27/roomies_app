import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileModel {
  final String id;
  final String imageName;
  final String imageUrl;
  final String firstImgUrl; 

  UserProfileModel({
    required this.id,
    required this.imageName,
    required this.imageUrl,
    this.firstImgUrl = 'http://www.classicaloasis.com/wp-content/uploads/2014/03/profile-square.jpg'
  });
}
