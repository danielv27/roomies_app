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
                    List<Message> messages = snapshot.data as List<Message>;
                    messages.sort((a, b) => b.timeStamp.toString().compareTo(a.timeStamp.toString()));
                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 10),
                      itemCount: messages.length,
                      reverse: true,
                      itemBuilder: (context,index) => MessageBubbleWidget(message: messages[index])
                    );
                  }else{
                    Center(child: Text('not messages with this user'),);
                    
                  }

                }
                if (snapshot.hasError) {
                return const Text("Something went wrong");
                }
                return const Center(child: CircularProgressIndicator(color: Colors.red));
              } 
              
            ),
          ),
          NewMessageWidget(otherUser: widget.otherUser),
        ],
      ),
      );
  }

  getTitleText(String title) => Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      );

  getSenderView(CustomClipper clipper, BuildContext context) => ChatBubble(
      clipper: clipper,
      alignment: Alignment.topRight,
      margin: EdgeInsets.only(top: 20),
      backGroundColor: Colors.blue,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Text(
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );

  getReceiverView(CustomClipper clipper, BuildContext context) => ChatBubble(
    clipper: clipper,
    backGroundColor: Color(0xffE7E7ED),
    margin: EdgeInsets.only(top: 20),
    child: Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      child: Text(
        "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat",
        style: TextStyle(color: Colors.black),
      ),
    ),
  );
}