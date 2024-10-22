import 'package:flutter/material.dart';
import 'package:roomies_app/models/user_model.dart';
import 'package:roomies_app/widgets/chat_page/online_indicator.dart';
import 'package:roomies_app/widgets/gradients/gradient.dart';

class ChatHeader extends StatelessWidget {
  final UserModel otherUser;
  VoidCallback? wentBack;
  
  ChatHeader({
    Key? key,
    required this.otherUser,
    this.wentBack
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: MediaQuery.of(context).size.height *0.14,
      decoration: BoxDecoration(
      gradient: redGradient(),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left:14.0,right: 14.0,top: 10,bottom: 10),
        child: AppBar(
          leading: GestureDetector(
            onTap:() { 
              Navigator.pop(context);
              wentBack!();
            },
            child:  Center(
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4), // border color
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new_sharp,color: Colors.white,size: 16,)),
            )
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          centerTitle: true,
          title: Column(
            children:  [
              Text("${otherUser.firstName} ${otherUser.lastName}"),
              const SizedBox(height: 3),
              OnlineIndicator(userID: otherUser.id)
            ],
          ),
          actions: [
            CircleAvatar(
              backgroundColor: Colors.red,
              backgroundImage: NetworkImage(otherUser.firstImgUrl,scale: 0.8),
              radius: 26,
            ),
          ],
        ),
      ),
    );
  }
}