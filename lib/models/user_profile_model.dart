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

  UserSignupProfileModel({
    this.radius = "0",
  });

}
