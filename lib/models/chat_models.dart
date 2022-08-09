import 'package:roomies_app/models/user_model.dart';

abstract class Chat{
  DateTime? lastMessageTime;
  String? lastMessage;
}

class PrivateChat extends Chat{
  final UserModel otherUser;
  PrivateChat({required this.otherUser});
}

class GroupChat extends Chat{
  final String groupID;
  final String houseID;
  final List<dynamic> participants;
  
  
  GroupChat({
    required this.groupID,
    required this.houseID,
    required this.participants,
    required lastMessageTime,
    required lastMessage
  });
}