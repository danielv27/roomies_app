import 'user_model.dart';

class UserProfileModel {
  final UserModel userModel;
  final List<String> imageURLS;

  UserProfileModel({
    required this.userModel,
    required this.imageURLS,
  });
}

class UserSignupProfileModel {
  String radius;
  final String minimumBudget;
  final String maximumBudget;

  UserSignupProfileModel({
    required this.radius,
    required this.minimumBudget,
    required this.maximumBudget,
  });

}
