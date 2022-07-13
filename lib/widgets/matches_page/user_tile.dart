import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:roomies_app/backend/database.dart';
import 'package:roomies_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:roomies_app/widgets/gradients/gradient.dart';
import 'package:roomies_app/widgets/matches_page/avatar_with_online_indicator.dart';

import '../../models/message.dart';
import '../../pages/chat_page.dart';

class UserTile extends StatefulWidget {
  final UserModel user;
  
  const UserTile({
      Key? key,
      required this.user
    }) : super(key: key);

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder(
      future: FireStoreDataBase().getMessages(FirebaseAuth.instance.currentUser?.uid, widget.user.id),
      builder: (context, snapshot) {
        String lastMessage = '';
        if(snapshot.hasData){
          List<Message> messages = snapshot.data as List<Message>;
          messages.sort((a, b) => b.timeStamp.toString().compareTo(a.timeStamp.toString()));
          messages.isNotEmpty ? lastMessage = messages[0].message : null;
          if(lastMessage.length > 50){
            lastMessage = lastMessage.substring(0, 50) + '...';
          }
        }
        return Padding(
          padding: const EdgeInsets.only(left:18.0,bottom: 23),
          child: GestureDetector(
            onTap: () => Navigator.push(context,
              PageTransition(type: PageTransitionType.rightToLeft,
                child: ChatPage(
                  otherUser: widget.user,
                  wentBack: () => setState(() {})
                )
              )
            ),
            child: Row(
              children: [
                AvatarWithOnlineIndicator(user: widget.user),
                SizedBox(width: MediaQuery.of(context).size.width*0.04,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    Text(
                      "${widget.user.firstName} ${widget.user.lastName}",
                      textAlign: TextAlign.left,
                    ),
                    Text(lastMessage)
                  ]
                )
              ],
            ),
          ),
        );
      }
    );
  }
}