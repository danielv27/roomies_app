import 'dart:async';

import 'package:flutter/material.dart';
import 'package:roomies_app/backend/users_api.dart';

import '../../models/user_model.dart';

class AvatarWithOnlineIndicator extends StatefulWidget {
  final UserModel user;

  const AvatarWithOnlineIndicator({
    Key? key,
    required this.user
  }) : super(key: key);

  @override
  State<AvatarWithOnlineIndicator> createState() => AvatarWithOnlineIndicatorState();
}

class AvatarWithOnlineIndicatorState extends State<AvatarWithOnlineIndicator> {
  
  bool onlineStatus = false;
  StreamSubscription<bool>? subscription;
  

  Future<void> checkIfOnline(String currentUserID) async {
    
    bool newOnlineStatus = false;
    subscription = UsersAPI().checkIfOnline(currentUserID).listen(
        (event) {
          newOnlineStatus = event;
          bool onlineStatusChanged = newOnlineStatus != onlineStatus;
          
          onlineStatusChanged && mounted ?
          setState(() {
            onlineStatus = newOnlineStatus;
          }):null;
        }
      );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    subscription != null ? subscription!.cancel():null;
  }



  @override
  Widget build(BuildContext context) {
    final String currentUserID = widget.user.id;
    checkIfOnline(currentUserID);
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.red[700],
          backgroundImage: NetworkImage(widget.user.firstImgUrl),
        ),
        onlineStatus ? Container(
          margin: const EdgeInsets.only(bottom: 2,right: 2),
          height: 13,
          width: 13,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white
            ),
            color: Colors.green,
            shape: BoxShape.circle
          ),
        ):Container(),
      ],
    );
    
  }
}