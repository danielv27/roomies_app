import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';

import '../../models/message.dart';

class MessageBubbleWidget extends StatelessWidget {
  final Message message;
  const MessageBubbleWidget({
    Key? key,
    required this.message
    }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return message.sentByCurrent ? 
    getSenderView(ChatBubbleClipper5(type: BubbleType.sendBubble), context) : 
    getReceiverView(ChatBubbleClipper5(type: BubbleType.receiverBubble), context);
  }

    getSenderView(CustomClipper clipper, BuildContext context) => ChatBubble(
    clipper: clipper,
    alignment: Alignment.topRight,
    margin: EdgeInsets.only(top: 10,right: 10,bottom: 10),
    backGroundColor: Colors.blue,
    child: Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      child: Text(
        message.message,
        style: TextStyle(color: Colors.white),
      ),
    ),
  );

  getReceiverView(CustomClipper clipper, BuildContext context) => ChatBubble(
    clipper: clipper,
    backGroundColor: Color(0xffE7E7ED),
    margin: EdgeInsets.only(top: 10,left: 10,bottom: 10),
    child: Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      child: Text(
        message.message,
        style: TextStyle(color: Colors.black),
      ),
    ),
  );
  

}