import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';

import '../../models/message.dart';

class PrivateMessageBubbleWidget extends StatelessWidget {
  final Message message;
  const PrivateMessageBubbleWidget({
    Key? key,
    required this.message,
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
    margin: const EdgeInsets.only(top: 10,right: 18,bottom: 10),
    backGroundColor: Colors.blue,
    child: Container(
      
      padding: const EdgeInsets.only(right: 5,left: 5),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      child: IntrinsicWidth(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12,top: 6,left: 8),
              child: Text(
                message.message,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "${message.timeStamp.hour}:${message.timeStamp.minute.toString().padLeft(2,'0')}",
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12
                ),
              ),
            ),
          ]
        ),
      ),
    ),
  );

  getReceiverView(CustomClipper clipper, BuildContext context) => ChatBubble(
    clipper: clipper,
    backGroundColor: Colors.white,
    margin: const EdgeInsets.only(top: 10,left: 18,bottom: 10),
    child: Container(
      padding: const EdgeInsets.only(right: 5,left: 5),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      child: IntrinsicWidth(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8,bottom: 12,top: 6),
              child: Text(
                message.message,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "${message.timeStamp.hour}:${message.timeStamp.minute.toString().padLeft(2,'0')}",
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12
                ),
              ),
            ),
            
          ]
        ),
      ),
    ),
  );
  

}