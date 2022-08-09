import 'package:roomies_app/models/user_model.dart';

abstract class Chat{
  DateTime lastMessageTime;
  String lastMessage;

  Chat({
    required this.lastMessage,
    required this.lastMessageTime
  });
}

class PrivateChat extends Chat{
  final String otherUserID;

  PrivateChat({
    required this.otherUserID,
    required lastMessage,
    required lastMessageTime
  }) : super(lastMessage: lastMessage, lastMessageTime: lastMessageTime);
}

class GroupChat extends Chat{
  final String groupID;
  final String houseID;
  final List<dynamic> participants;
  
  GroupChat({
    required this.groupID,
    required this.houseID,
    required this.participants,
    required lastMessage,
    required lastMessageTime,

  }) : super(lastMessage: lastMessage, lastMessageTime: lastMessageTime);
}