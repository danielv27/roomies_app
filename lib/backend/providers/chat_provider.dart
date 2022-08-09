import 'package:flutter/material.dart';
import 'package:roomies_app/backend/chat_api.dart';
import 'package:roomies_app/models/chat_models.dart';

class ChatProvider extends ChangeNotifier {
  List<Chat> chats = [];
  List<GroupChat>? groupChats;
  List<PrivateChat>? privateChats;

  Future<void> initialize() async {
    print('chatinit');
    groupChats = await ChatAPI().getGroupChats();
    for(var groupChat in groupChats!){
      print(groupChat.groupID);
    }
    privateChats = await ChatAPI().getPrivateChats();

    if(groupChats != null) chats.addAll(groupChats!);
    if(privateChats != null) chats.addAll(privateChats!);

    sortByTimeStamp();
    notifyListeners();
  }

  void sortByTimeStamp(){
    chats.sort((a, b) => b.lastMessageTime.toString().compareTo(a.lastMessageTime.toString()));
  }

  Stream<List<Chat>> streamChanges(){
    return ChatAPI().streamGroupChatChanges();
  }
}