import 'package:roomies_app/models/message.dart';
import 'package:roomies_app/models/user_model.dart';

class GroupChat{
  final String groupID;
  final List<UserModel> otherUsers;
  final DateTime lastMessageTime;
  final int unreadMessages;
  final List<Message> messages;

  GroupChat({
    required this.groupID,
    required this.otherUsers,
    required this.lastMessageTime,
    required this.unreadMessages,
    required this.messages
  });
}