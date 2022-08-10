import 'package:flutter/material.dart';
import 'package:roomies_app/backend/chat_api.dart';
import 'package:roomies_app/models/chat_models.dart';
import 'package:roomies_app/models/user_model.dart';
import 'package:stream_transform/stream_transform.dart';

class ChatProvider extends ChangeNotifier {
  List<Chat> chats = [];
  List<GroupChat>? groupChats;
  List<PrivateChat>? privateChats;

  Future<void> initialize() async {
    groupChats = await ChatAPI().getGroupChats();
    privateChats = await ChatAPI().getPrivateChats();

    if(groupChats != null) chats.addAll(groupChats!);
    if(privateChats != null) chats.addAll(privateChats!);

    sortByTimeStamp();
    notifyListeners();
  }

  void updateChat(int index, Chat chat){
    chats[index].lastMessage = chat.lastMessage;
    chats[index].lastMessageTime = chat.lastMessageTime;
    sortByTimeStamp();
    notifyListeners();
  }

  void sortByTimeStamp(){
    chats.sort((a, b) { 
      if(a.lastMessageTime == b.lastMessageTime){
        return 0;
      }
      return b.lastMessageTime.compareTo(a.lastMessageTime);});
    notifyListeners();
  }

  Stream<List<Chat>> streamChanges(List<UserModel> matches){
    
    Stream<List<PrivateChat>> privateChatStream = ChatAPI().streamPrivateChatChanges(matches);
    Stream<List<GroupChat>> groupChatStream = ChatAPI().streamGroupChatChanges();

    return privateChatStream.combineLatest(groupChatStream, (private, group) {
      List<Chat> chats = [];
      chats.addAll(private);
      chats.addAll(group as List<GroupChat>);
      chats.sort(((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime)));
      return chats;
    });
  }
}