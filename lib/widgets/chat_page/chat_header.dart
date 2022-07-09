import 'package:flutter/material.dart';
import 'package:roomies_app/models/user_model.dart';

class ChatHeader extends StatelessWidget {
  final UserModel otherUser;
  
  const ChatHeader({
    Key? key,
    required this.otherUser
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
          //height: MediaQuery.of(context).size.height *0.14,
          decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
            Color.fromRGBO(239, 85, 100, 1),
            Color.fromRGBO(195, 46, 66, 1),
            Color.fromRGBO(190, 40, 62, 1),
            Color.fromRGBO(210, 66, 78, 1),
            Color.fromRGBO(244, 130, 114, 1),
          ])),
          child: Padding(
            padding: const EdgeInsets.only(left:14.0,right: 14.0,top: 10,bottom: 10),
            child: AppBar(
              leading: GestureDetector(
                onTap:() =>  Navigator.pop(context),
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
              title: Text("${otherUser.firstName} ${otherUser.lastName}"),
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