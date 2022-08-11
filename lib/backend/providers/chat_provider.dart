import 'package:flutter/material.dart';
import 'package:roomies_app/backend/chat_api.dart';
import 'package:roomies_app/models/chat_models.dart';

class ChatProvider extends ChangeNotifier {
  List<Chat> chats = [];
  // List<GroupChat>? groupChats;
  // List<PrivateChat>? privateChats;

  // Future<void> initialize() async {
  //   groupChats = await ChatAPI().getGroupChats();
  //   privateChats = await ChatAPI().getPrivateChats();

  //   if(groupChats != null) chats.addAll(groupChats!);
  //   if(privateChats != null) chats.addAll(privateChats!);

  //   notifyListeners();
  // }



}