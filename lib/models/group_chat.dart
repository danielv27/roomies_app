import 'package:roomies_app/models/message.dart';
import 'package:roomies_app/models/user_model.dart';

class GroupChat{
  final String groupID;
  final String houseID;
  final List<String> participants;
  final DateTime lastMessageTime;
  final String lastMessage;

  GroupChat({
    required this.groupID,
    required this.houseID,
    required this.participants,
    required this.lastMessageTime,
    required this.lastMessage,
  });
}