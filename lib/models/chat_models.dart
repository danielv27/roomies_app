import 'package:roomies_app/models/user_model.dart';

abstract class Chat{
  String id;
  DateTime lastMessageTime;
  String lastMessage;

  Chat({
    required this.id,
    required this.lastMessage,
    required this.lastMessageTime
  });
}

class PrivateChat extends Chat{
  final UserModel? otherUser;

  PrivateChat({
    required this.otherUser,
    required id,
    required lastMessage,
    required lastMessageTime
  }) : super(id: id,lastMessage: lastMessage, lastMessageTime: lastMessageTime);
}

class GroupChat extends Chat{
  final String groupID;
  final String groupImage;
  final List<dynamic> participantsIDs;
  
  GroupChat({
    required id,
    required this.groupID,
    required this.groupImage,
    required this.participantsIDs,
    required lastMessage,
    required lastMessageTime,

  }) : super(id: id,lastMessage: lastMessage, lastMessageTime: lastMessageTime);
}