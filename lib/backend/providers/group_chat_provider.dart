import 'package:flutter/material.dart';
import 'package:roomies_app/backend/chat_api.dart';
import 'package:roomies_app/models/chat_models.dart';

class GroupChatProvider extends ChangeNotifier {
  List<GroupChat>? groupChats;

  Future<void> initialize() async {
    groupChats = await ChatAPI().getGroupChats().then(((groupChats) {
      for(var groupChat in groupChats){
        print('groupChat: ${groupChat.groupID}');
        print('houseID: ${groupChat.houseID}');
        print('Participants: ${groupChat.participants}');
        print('lastMessage: ${groupChat.lastMessage}');
        print('lastMessageTime: ${groupChat.lastMessageTime}');
      return;
      }
    }));
    
  }
  Stream<List<GroupChat>> streamChanges(){
    return ChatAPI().streamGroupChatChanges();
  }
}