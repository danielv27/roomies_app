import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_10.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_2.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_3.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_4.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_6.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_7.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_8.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_9.dart';
import 'package:roomies_app/backend/database.dart';
import 'package:roomies_app/models/user_model.dart';
import 'package:roomies_app/widgets/chat_page/chat_header.dart';
import 'package:roomies_app/widgets/chat_page/message_bubble_widget.dart';

import '../models/message.dart';
import '../widgets/chat_page/new_message_widget.dart';




class ChatPage extends StatefulWidget {
  final UserModel otherUser;
  
  
  const ChatPage({
      Key? key,
      required this.otherUser
    }) : super(key: key);  

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> messages = [];
  //late final messageStream = FireStoreDataBase().listenToMessages(FirebaseAuth.instance.currentUser?.uid, widget.otherUser.id);
  late GlobalKey<AnimatedListState> _key = GlobalKey();



  

  


  @override
  void initState(){
    super.initState();
    
  }
  

  void _addMessage(Message message){
    messages.insert(0, message);
    //_key.currentState?.insertItem(0, duration: const Duration(milliseconds: 130));
    if(_key.currentState != null){
      _key.currentState?.insertItem(0, duration: const Duration(milliseconds: 130));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true ,
      body: Column(
        children: [
          ChatHeader(otherUser: widget.otherUser),
          Expanded(
            child: FutureBuilder(
              future: FireStoreDataBase().getMessages(FirebaseAuth.instance.currentUser?.uid, widget.otherUser.id),
              builder:(context, snapshot) {
                if(snapshot.connectionState == ConnectionState.done){
                  if(snapshot.hasData){
                    messages = snapshot.data as List<Message>;
                    messages.sort((a, b) => b.timeStamp.toString().compareTo(a.timeStamp.toString()));
                    FireStoreDataBase().listenToMessages(FirebaseAuth.instance.currentUser?.uid, widget.otherUser.id)
                    .listen(
                      (event) {
                        List<Message>? newMessages = event;
                        if(newMessages != null && newMessages.length > messages.length){
                          newMessages.sort((a, b) => b.timeStamp.toString().compareTo(a.timeStamp.toString()));
                          String? lastMessage = newMessages[0].message;
                          print(lastMessage);

                          // need to add case of handling multiple messages sent quickly using newMessages.length - messages.length
                          _addMessage(newMessages[0]);
                        }
                      },
                    );
                    return AnimatedList(
                      key: _key,
                      padding: const EdgeInsets.only(bottom: 10),
                      initialItemCount: messages.length,
                      shrinkWrap: true,
                      reverse: true,
                      itemBuilder: (context,index, animation) {
                        //the item builders animation only animates for elements beyond the initial messages length
                        return SizeTransition(
                          sizeFactor: animation,
                          child: MessageBubbleWidget(message: messages[index]));
                      }
                    );
                  }else{
                    Center(child: Text('not messages with this user'),);
                    
                  }

                }
                if (snapshot.hasError) {
                return const Text("Something went wrong");
                }
                if(snapshot.connectionState == ConnectionState.active){
                   List<Message> newMessages = snapshot.data as List<Message>;
                   if(newMessages.length > messages.length){
                    newMessages.sort((a, b) => b.timeStamp.toString().compareTo(a.timeStamp.toString()));
                    _addMessage(newMessages[0]);
                   }
                  
                }
                return const Center(child: CircularProgressIndicator(color: Colors.red));
              } 
              
            ),
          ),
          NewMessageWidget(
            otherUser: widget.otherUser, 
            onMessageSent: (message) => _addMessage(Message(message: message, otherUserID: widget.otherUser.id, sentByCurrent: true, timeStamp: DateTime.now()))
          ),
        ],
      ),
    );
  }
}