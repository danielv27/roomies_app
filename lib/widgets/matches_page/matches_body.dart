

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomies_app/backend/providers/matches_provider.dart';
import 'package:roomies_app/widgets/matches_page/user_tile.dart';
import '../../models/group_chat.dart';
import '../../models/user_model.dart';

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
    return Consumer<MatchesProvider>(
      builder: ((context, provider, child) { 
        provider.sortByTimeStamp();
        return Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20)
              ),
            ),
            child: chatTileList(provider.userModels, []),
          )
        );
      })
    );
  }
}

Widget chatTileList(List<UserModel> users, List<GroupChat> groupChats){
  
  return ListView.builder(
    padding: const EdgeInsets.only(top: 18,bottom: 105),
    itemCount: users.length,
    itemBuilder: (context,index) => UserTile(user: users[index]),
    addAutomaticKeepAlives: false,
  );
}