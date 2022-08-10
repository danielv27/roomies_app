

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomies_app/backend/chat_api.dart';
import 'package:roomies_app/backend/providers/chat_provider.dart';
import 'package:roomies_app/backend/providers/matches_provider.dart';
import 'package:roomies_app/widgets/matches_page/chat_tile.dart';
import '../../models/chat_models.dart';

class MatchesBodyWidget extends StatefulWidget {
  final matchesProvider;
  const MatchesBodyWidget({
      Key? key,
      required this.matchesProvider
    }) : super(key: key);

  @override
  State<MatchesBodyWidget> createState() => _MatchesBodyWidgetState();
}

class _MatchesBodyWidgetState extends State<MatchesBodyWidget> {
  @override
  Widget build(BuildContext context){
    final List<Chat> chats = context.read<ChatProvider>().chats;
    final matches = context.read<MatchesProvider>().userModels;
    //final chatStream = context.read<ChatProvider>().streamChanges(matches);
    final chatStream = ChatAPI().streamPrivateChatChanges(matches);
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20)
          ),
        ),
        child: chatTileList(chats, chatStream),
      )
    );
      
  }
}

Widget chatTileList(List<Chat> initialChats, Stream<List<Chat>> chatStream){
  return StreamBuilder(
    initialData: initialChats,
    stream: chatStream,
    builder: (context, snapshot) {
      if(snapshot.hasData){
          List<Chat> chats = snapshot.data as List<Chat>;
          return ListView.builder(
          padding: const EdgeInsets.only(top: 18,bottom: 105),
          itemCount: chats.length,
          itemBuilder: (context,index) => ChatTile(chat: chats[index], index: index),
          addAutomaticKeepAlives: false,
        );
      }
      return const Center(child: CircularProgressIndicator(color: Colors.red));
      


    }
  );
}