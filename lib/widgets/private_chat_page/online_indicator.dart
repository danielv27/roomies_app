import 'dart:async';

import 'package:flutter/material.dart';
import 'package:roomies_app/backend/users_api.dart';

class PrivateChatOnlineIndicator extends StatefulWidget {
  final String userID;
  const PrivateChatOnlineIndicator({
    Key? key,
    required this.userID
    }) : super(key: key);

  @override
  State<PrivateChatOnlineIndicator> createState() => PrivateChatOnlineIndicatorState();
}

class PrivateChatOnlineIndicatorState extends State<PrivateChatOnlineIndicator> {



  bool onlineStatus = false;
  late StreamSubscription<bool>? subscription;

  void checkIfOnline() async {
    bool newOnlineStatus = false;
    subscription = UsersAPI().listenIfOnline(widget.userID).listen(
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
  Widget build(BuildContext context) {
    checkIfOnline();
    return AnimatedScale(
      scale: onlineStatus? 1 : 0,
      duration: onlineStatus? const Duration(milliseconds: 800) : const Duration(milliseconds: 650),
      curve: onlineStatus? Curves.elasticOut : Curves.elasticIn,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ 
            Container(
              margin: const EdgeInsets.only(right: 3,top: 1),
              height: 9,
              width: 9,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle
                
              ),
            ),
            const Text(
              'Online',
              style: TextStyle(
                fontSize: 14,
              ),)
          ]
        ),
      ),
    );
  }
}