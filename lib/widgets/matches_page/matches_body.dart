import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomies_app/backend/chat_api.dart';
import 'package:roomies_app/backend/providers/chat_provider.dart';
import 'package:roomies_app/backend/providers/matches_provider.dart';
import 'package:roomies_app/widgets/matches_page/chat_tile.dart';
import '../../models/chat_models.dart';
import 'package:rxdart/rxdart.dart';

class MatchesBodyWidget extends StatefulWidget {
  final MatchesProvider matchesProvider;
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
    final matches = context.watch<MatchesProvider>().matches;
    final likedHouses = context.watch<MatchesProvider>().likedHouses;
    final privateChatStream = ChatAPI().streamPrivateChatChanges(matches);
    final groupChatStream = ChatAPI().streamGroupChatChanges(likedHouses);

    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20)
          ),
        ),
  
        child: StreamBuilder<List<List<Chat>?>>(
          stream: CombineLatestStream.list([privateChatStream, groupChatStream]),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              final chatProvider = context.read<ChatProvider>();
              final List<Chat> chats = [];
              if(snapshot.data?[0] != null){
                final privateChats = snapshot.data?[0] as List<PrivateChat>;
                 chats.addAll(privateChats.where((privateChat) => chats.every((chat) => chat.id != privateChat.id)));
              }
              if(snapshot.data?[1] != null){
                final groupChats = snapshot.data?[1] as List<GroupChat>;
                chats.addAll(groupChats.where((groupChat) => chats.every((chat) => chat.id != groupChat.id)));
              }
              if(chats.isNotEmpty){
                chats.sort(((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime)));
                chatProvider.setChats(chats); // gives error in terminal since notify listeners is called too early.
                return chatTileList(chats);
              }
            }
            else if((snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.waiting)){
              print(snapshot.connectionState);
              return const Center(child: CircularProgressIndicator(color: Colors.red));  
            }
            print(snapshot.connectionState);
            return const Center(child: Text('No Chats to Display'));
          }
        )
      )
    );
  }
}


Widget chatTileList(List<Chat> chats){
    return ListView.builder(
      padding: const EdgeInsets.only(top: 18,bottom: 105),
      itemCount: chats.length,
      itemBuilder: (context,index) => ChatTile(chat: chats[index], index: index),
  );
}