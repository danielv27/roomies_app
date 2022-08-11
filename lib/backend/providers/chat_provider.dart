import 'package:flutter/material.dart';
import 'package:roomies_app/models/chat_models.dart';

class ChatProvider extends ChangeNotifier {
  List<Chat> chats = [];

  void setChats(List<Chat> chats){
    this.chats = chats;
  }
}