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

import '../widgets/chat_page/new_message_widget.dart';




class ChatPage extends StatelessWidget {
  final UserModel otherUser;
  
  const ChatPage({
      Key? key,
      required this.otherUser
    }) : super(key: key);  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true ,
      bottomSheet: NewMessageWidget(otherUser: otherUser),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: ChatHeader(otherUser: otherUser)),
      body: ListView(
          children: <Widget>[
            getTitleText("Example 1"),
            getSenderView(
                ChatBubbleClipper1(type: BubbleType.sendBubble), context),
            getReceiverView(
                ChatBubbleClipper1(type: BubbleType.receiverBubble), context),
            SizedBox(
              height: 30,
            ),
            getTitleText("Example 2"),
            getSenderView(
                ChatBubbleClipper2(type: BubbleType.sendBubble), context),
            getReceiverView(
                ChatBubbleClipper2(type: BubbleType.receiverBubble), context),
            SizedBox(
              height: 30,
            ),
            getTitleText("Example 3"),
            getSenderView(
                ChatBubbleClipper3(type: BubbleType.sendBubble), context),
            getReceiverView(
                ChatBubbleClipper3(type: BubbleType.receiverBubble), context),
            SizedBox(
              height: 30,
            ),
            getTitleText("Example 4"),
            getSenderView(
                ChatBubbleClipper4(type: BubbleType.sendBubble), context),
            getReceiverView(
                ChatBubbleClipper4(type: BubbleType.receiverBubble), context),
            SizedBox(
              height: 30,
            ),
            getTitleText("Example 5"),
            getSenderView(
                ChatBubbleClipper5(type: BubbleType.sendBubble), context),
            getReceiverView(
                ChatBubbleClipper5(type: BubbleType.receiverBubble), context),
            SizedBox(
              height: 30,
            ),
            getTitleText("Example 6"),
            getSenderView(
                ChatBubbleClipper6(type: BubbleType.sendBubble), context),
            getReceiverView(
                ChatBubbleClipper6(type: BubbleType.receiverBubble), context),
            SizedBox(
              height: 30,
            ),
            getTitleText("Example 7"),
            getSenderView(
                ChatBubbleClipper7(type: BubbleType.sendBubble), context),
            getReceiverView(
                ChatBubbleClipper7(type: BubbleType.receiverBubble), context),
            SizedBox(
              height: 30,
            ),
            getTitleText("Example 8"),
            getSenderView(
                ChatBubbleClipper8(type: BubbleType.sendBubble), context),
            getReceiverView(
                ChatBubbleClipper8(type: BubbleType.receiverBubble), context),
            SizedBox(
              height: 30,
            ),
            getTitleText("Example 9"),
            getSenderView(
                ChatBubbleClipper9(type: BubbleType.sendBubble), context),
            getReceiverView(
                ChatBubbleClipper9(type: BubbleType.receiverBubble), context),
            SizedBox(
              height: 30,
            ),
            getTitleText("Example 10"),
            getSenderView(
                ChatBubbleClipper10(type: BubbleType.sendBubble), context),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: getReceiverView(
                  ChatBubbleClipper10(type: BubbleType.receiverBubble), context),
            )
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