import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:page_transition/page_transition.dart';
import 'package:roomies_app/models/chat_models.dart';
import 'package:roomies_app/widgets/matches_page/avatar_with_online_indicator.dart';

import '../../pages/private_chat_page.dart';

class ChatTile extends StatefulWidget {
  final Chat chat;
  final int index;
  
  const ChatTile({
      Key? key,
      required this.chat,
      required this.index
    }) : super(key: key);

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {

  @override
  void initState() {
    super.initState();

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
    final chat = widget.chat as GroupChat;
    return Padding(
      padding: const EdgeInsets.only(left:18.0,bottom: 23),
      child: GestureDetector(
        onTap: () {
        //   Navigator.push(
        //     context,
        //     PageTransition(type: PageTransitionType.rightToLeft,
        //       child: PrivateChatPage(
        //         otherUser: chat.otherUser!,
        //       )
        //     )
        //   );
        },
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.red[700],
              radius: 28,
              backgroundImage: setCachedNetworkImageProvider(chat.groupImage),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.04),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Text(
                  'house',
                  //"${chat.otherUser!.firstName} ${chat.otherUser!.lastName}",
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

  CachedNetworkImageProvider setCachedNetworkImageProvider(String image) {
    return CachedNetworkImageProvider(
      image,
      scale: 1.0,
      cacheManager: CacheManager(
        Config(
          'housesChatImage',
          stalePeriod: const Duration(days : 10),
          maxNrOfCacheObjects: 1000,
        )
      ),
    );
  }
}