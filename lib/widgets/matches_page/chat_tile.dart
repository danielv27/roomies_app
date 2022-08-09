import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:roomies_app/backend/chat_api.dart';
import 'package:roomies_app/models/chat_models.dart';
import 'package:roomies_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:roomies_app/widgets/matches_page/avatar_with_online_indicator.dart';

import '../../pages/chat_page.dart';

class ChatTile extends StatefulWidget {
  final Chat chat;
  
  const ChatTile({
      Key? key,
      required this.chat,
    }) : super(key: key);

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {

  // Stream<void> updateLastMessage() async* {
  //   String? lastMessage = widget.user.lastMessage;
  //   while(true){
  //     lastMessage = await ChatAPI().getLastPrivateMessage(FirebaseAuth.instance.currentUser?.uid, widget.user.id);
  //     if(lastMessage.isNotEmpty && lastMessage != widget.user.lastMessage){
  //       DateTime? timeStamp = await ChatAPI().getLastPrivateMessageTimeStamp(FirebaseAuth.instance.currentUser?.uid, widget.user.id);
  //       widget.user.setLastMessage(lastMessage);
  //       widget.user.setTimeStamp(timeStamp);
  //     }
  //     await Future.delayed(const Duration(seconds: 2));
  //   }
  // } 

  @override
  void initState() {
    super.initState();
    //updateLastMessage().listen((event){});
  }

  @override
  Widget build(BuildContext context) {
    
    String lastMessage = widget.chat.lastMessage;

    if(lastMessage.length > 35){
      lastMessage = '${lastMessage.substring(0, 35)}...';
    }

    if(widget.chat is PrivateChat){
      final chat = widget.chat as PrivateChat;
      return Padding(
        padding: const EdgeInsets.only(left:18.0,bottom: 23),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageTransition(type: PageTransitionType.rightToLeft,
                child: PrivateChatPage(
                  otherUser: chat.otherUser!,
                )
              )
            );
          },
          child: Row(
            children: [
              AvatarWithOnlineIndicator(user: chat.otherUser!, userProfileImage: chat.otherUser!.firstImageProvider),
              SizedBox(width: MediaQuery.of(context).size.width * 0.04),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Text(
                    "${chat.otherUser!.firstName} ${chat.otherUser!.lastName}",
                    textAlign: TextAlign.left,
                  ),
                  Text(lastMessage),
                ],
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.only(right: 20),
                color: Colors.green, width: 5, height: 5,
              ),
            ],
          ),
        ),
      );
    }
    return Container();
  }
}