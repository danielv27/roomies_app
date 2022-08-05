import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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
    subscription = UsersAPI().listenIfOnline(currentUserID).listen(
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
    checkIfOnline(widget.user.id);
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CachedNetworkImage(
          key: UniqueKey(),
          imageUrl: widget.user.firstImgUrl,
          placeholder: (context, url) => const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 28,
          ),
          fit: BoxFit.cover,
          filterQuality: FilterQuality.low,
          imageBuilder: (context, imageProvider) => CircleAvatar(
            backgroundColor: Colors.red[700],
            radius: 28,
            backgroundImage: imageProvider,
          ),
          cacheManager: CacheManager(
            Config(
              'customKey',
              stalePeriod: const Duration(milliseconds : 100),
              maxNrOfCacheObjects: 100,
            ),
          ),
        ),
        AnimatedScale(
          scale: onlineStatus? 1:0,
          duration: const Duration(milliseconds: 200),
          curve: onlineStatus? Curves.easeIn:Curves.easeOut,
          child: Container(
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
          ),
        )
      ],
    );
    
  }
}