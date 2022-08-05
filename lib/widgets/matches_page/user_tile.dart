import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:roomies_app/backend/messages_api.dart';
import 'package:roomies_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:roomies_app/widgets/matches_page/avatar_with_online_indicator.dart';

import '../../pages/chat_page.dart';

class UserTile extends StatefulWidget {
  final UserModel user;
  
  const UserTile({
      Key? key,
      required this.user,
    }) : super(key: key);

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {

  Stream<void> updateLastMessage() async* {
    String? lastMessage = widget.user.lastMessage;
    while(true){
      lastMessage = await MessagesAPI().getLastPrivateMessage(FirebaseAuth.instance.currentUser?.uid, widget.user.id);
      if(lastMessage.isNotEmpty && lastMessage != widget.user.lastMessage){
        DateTime? timeStamp = await MessagesAPI().getLastPrivateMessageTimeStamp(FirebaseAuth.instance.currentUser?.uid, widget.user.id);
        widget.user.setLastMessage(lastMessage);
        widget.user.setTimeStamp(timeStamp);
      }
      await Future.delayed(const Duration(seconds: 2));
    }
  } 

  @override
  void initState() {
    super.initState();
    updateLastMessage().listen((event){});
  }

  @override
  Widget build(BuildContext context) {
    
    String lastMessage = '';
    if(widget.user.lastMessage != null){
      lastMessage = widget.user.lastMessage!;
    }

    if(lastMessage.length > 35){
      lastMessage = '${lastMessage.substring(0, 35)}...';
    }

    return Padding(
      padding: const EdgeInsets.only(left:18.0,bottom: 23),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageTransition(type: PageTransitionType.rightToLeft,
              child: PrivateChatPage(
                otherUser: widget.user,
              )
            )
          );
        },
        child: Row(
          children: [
            AvatarWithOnlineIndicator(user: widget.user, userProfileImage: widget.user.firstImageProvider),
            SizedBox(width: MediaQuery.of(context).size.width * 0.04),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Text(
                  "${widget.user.firstName} ${widget.user.lastName}",
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
}