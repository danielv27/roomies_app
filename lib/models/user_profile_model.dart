import 'user_model.dart';

class UserProfileModel {
  final UserModel userModel;
  final List<String> imageURLS;

  UserProfileModel({
    required this.userModel,
    required this.imageURLS,
  });
}
