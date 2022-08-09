

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomies_app/backend/providers/chat_provider.dart';
import 'package:roomies_app/widgets/matches_page/chat_tile.dart';
import '../../models/chat_models.dart';

class MatchesBodyWidget extends StatefulWidget {
  
  const MatchesBodyWidget({
      Key? key,
    }) : super(key: key);

  @override
  State<MatchesBodyWidget> createState() => _MatchesBodyWidgetState();
}

class _MatchesBodyWidgetState extends State<MatchesBodyWidget> {
  @override
  Widget build(BuildContext context){
    final List<Chat> chats = context.read<ChatProvider>().chats;

    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20)
          ),
        ),
        child: chatTileList(chats),
      )
    );
      
  }
}

Widget chatTileList(List<Chat> chats){
  
  return ListView.builder(
    padding: const EdgeInsets.only(top: 18,bottom: 105),
    itemCount: chats.length,
    itemBuilder: (context,index) => ChatTile(chat: chats[index]),
    addAutomaticKeepAlives: false,
  );
}