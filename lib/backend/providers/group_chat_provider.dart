import 'package:flutter/material.dart';
import 'package:roomies_app/backend/chat_api.dart';
import 'package:roomies_app/models/group_chat.dart';

class GroupChatProvider extends ChangeNotifier {
  List<GroupChat>? groupChats;

  Future<void> initialize() async {
    groupChats = await ChatAPI().getGroupChats().then(((groupChats) {
      print(groupChats[0].participants);
    }));
    
  }
  Stream<List<GroupChat>> streamChanges(){
    return ChatAPI().streamGroupChatChanges();
  }
}