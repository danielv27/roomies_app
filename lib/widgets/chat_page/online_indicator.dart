import 'dart:async';

import 'package:flutter/material.dart';
import 'package:roomies_app/backend/users_api.dart';

class OnlineIndicator extends StatefulWidget {
  final String userID;
  const OnlineIndicator({
    Key? key,
    required this.userID
    }) : super(key: key);

  @override
  State<OnlineIndicator> createState() => OnlineIndicatorState();
}

class OnlineIndicatorState extends State<OnlineIndicator> {



  bool onlineStatus = false;
  late StreamSubscription<bool>? subscription;

  void checkIfOnline() async {
    bool newOnlineStatus = false;
    subscription = UsersAPI().checkIfOnline(widget.userID).listen(
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
      
      scale: onlineStatus ? 1 : 0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticInOut,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ 
            Container(
              margin: EdgeInsets.only(right: 3,top: 1),
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