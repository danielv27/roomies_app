import 'user_model.dart';

class UserProfileModel {
  final UserModel userModel;
  final List<String> imageURLS;

  UserProfileModel({
    required this.userModel,
    required this.imageURLS,
  });
}

class UserPersonalProfileModel {
  String radius;
  final String minimumBudget;
  final String maximumBudget;

  UserPersonalProfileModel({
    required this.radius,
    required this.minimumBudget,
    required this.maximumBudget,
  });

}
