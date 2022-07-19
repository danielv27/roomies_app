import 'user_model.dart';

class UserProfileModel {
  final UserModel userModel;
  final List<dynamic> imageURLS;

  UserProfileModel({
    required this.userModel,
    required this.imageURLS,
  });
}

class UserSignupProfileModel {
  String radius;
  String minBudget; 
  String maxBudget; 
  String about;
  String work;
  String study; 
  String roommate; 
  String birthdate;

  UserSignupProfileModel({
    required this.minBudget, 
    required this.maxBudget, 
    required this.about, 
    required this.work, 
    required this.study, 
    required this.roommate, 
    required this.birthdate,
    this.radius = "0",
  });

}