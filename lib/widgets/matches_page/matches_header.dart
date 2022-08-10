import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:roomies_app/backend/chat_api.dart';
import 'package:roomies_app/backend/providers/chat_provider.dart';
import 'package:roomies_app/backend/providers/current_profile_provider.dart';
import 'package:roomies_app/backend/providers/matches_provider.dart';
import 'package:roomies_app/models/chat_models.dart';
import 'package:roomies_app/widgets/matches_page/avatar_with_gradient_border.dart';
import 'package:roomies_app/widgets/matches_page/matches_body.dart';
import '../../models/user_model.dart';
import '../../pages/chat_page.dart';
import 'package:provider/provider.dart';


class MatchesHeaderWidget extends StatefulWidget {
  final UserModel? currentUser;
  final MatchesProvider matchesProvider;
  final ChatProvider chatProvider;

  const MatchesHeaderWidget({
      Key? key,
      required this.currentUser,
      required this.matchesProvider,
      required this.chatProvider
    }) : super(key: key);

  @override
  State<MatchesHeaderWidget> createState() => _MatchesHeaderWidgetState();
}

class _MatchesHeaderWidgetState extends State<MatchesHeaderWidget> {
  
  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(top:32),
      child: Column(
        children: [
          searchBar(context, widget.matchesProvider.userModels, widget.chatProvider.chats, widget.currentUser),
          SizedBox(height: MediaQuery.of(context).size.height*0.02),
          circularUserList(context, widget.matchesProvider.userModels),
        ],
      ),
    );
  }
}

Widget searchBar(BuildContext context,List<UserModel>? users, List<Chat> chats, UserModel? currentUser){
  DateTime now = DateTime.now();
  String dayTime = "morning";
  if(now.hour >= 21){
    dayTime = "night";
  }
  else if(now.hour >= 18){
    dayTime = "evening";
  }
  else if(now.hour >= 12){
    dayTime = "afternoon";
  }
  UserModel? currentUser = context.read<CurrentUserProvider>().currentUser?.userModel;
  return AppBar(
    centerTitle: false,
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    actions: [
      GestureDetector(
        onTap: () { 
          print('search pressed');
          showSearch(
            context: context,
            delegate: ChatsSearchDelegate(chats, users),
          );
        },
        child: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.white.withOpacity(0.4),
          child: const Icon(Icons.search_rounded,color: Colors.white,),
        ),
      ),
      GestureDetector(
        onTap: () {
          print('profile pressed');
        },
        child: Container(
          decoration:const  BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
              Color.fromARGB(255, 255, 113, 127),
              Color.fromARGB(255, 208, 70, 82),
              Color.fromARGB(255, 221, 33, 61),
              Color.fromARGB(255, 243, 55, 80),
              Color.fromARGB(255, 241, 168, 158),
              ]
            ),
          shape: BoxShape.circle
          ),
          padding: const EdgeInsets.all(3.5),
          child: 
          CircleAvatar(
            backgroundColor: Colors.red[700],
            radius: 28,
            backgroundImage: currentUser!.firstImageProvider,
          ),
        ),
      ),
      const Padding(padding: EdgeInsets.only(right: 16)),
    ],
    title: Column(
      children: [
          Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Good $dayTime,",
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "${currentUser.firstName} ${currentUser.lastName}",
            style: const TextStyle(
              color: Colors.white
            ),
          ),
        ),
      ],
    ),
  );
}

Widget circularUserList(BuildContext context, List<UserModel>? users){
  List<UserModel> usersSortedByName = [];
  users != null? usersSortedByName = List.from(users):null;
  usersSortedByName.sort((a, b) => a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase()));
  return SizedBox(
    height: MediaQuery.of(context).size.height *0.13,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: usersSortedByName.length,
      itemBuilder: (context, index){
        return Padding(
          padding: const EdgeInsets.only(top: 11,left: 15,right: 4),
          child: GestureDetector(
            onTap: () {
              print('chat with user $index'); 
              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: PrivateChatPage(otherUser: usersSortedByName[index],)));
            },
            child: Column(
              children: [
                AvatarWithGradientBorder(radius: 26, borderWidth: 4, image: usersSortedByName[index].firstImageProvider, backgroundColor: Colors.red[700],),
                Text(usersSortedByName[index].firstName, style: const TextStyle(color: Colors.white),)
              ],
            ),
          ),
        );
      }
    ), 
  );
}

class ChatsSearchDelegate extends SearchDelegate {
  late final List<Chat> chats;
  late final List<UserModel> matches;
  ChatsSearchDelegate(chatList, matchList){
    chats = chatList;
    matches = matchList;
  }
  
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back,color: Colors.red,)
    );
  }
  
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if(query.isEmpty){
            close(context, null);
          }
          query = '';
        },
        icon: const Icon(Icons.clear,color: Colors.red,))
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    
    Stream<List<Chat>> chatStream = ChatAPI().streamPrivateChatChanges(matches);
    List<Chat> results = chats.where((chat){
      String fullName = '';
      final input = query.toLowerCase();
      if(chat is PrivateChat){
        PrivateChat currentChat = chat;
        fullName = "${currentChat.otherUser?.firstName.toLowerCase()} ${currentChat.otherUser?.lastName.toLowerCase()}";
      }
      return fullName.contains(input);
    }).toList();
    return GestureDetector( //this is for now might remove
      onTap:() => close(context, null),
      child: chatTileList(results, chatStream));
      //child: chatTileList(results));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    Stream<List<Chat>> chatStream = ChatAPI().streamPrivateChatChanges(matches);
    List<Chat> suggestions = chats.where((chat){
      String fullName = '';
      final input = query.toLowerCase();
      if(chat is PrivateChat){
        PrivateChat currentChat = chat;
        fullName = "${currentChat.otherUser?.firstName.toLowerCase()} ${currentChat.otherUser?.lastName.toLowerCase()}";
      }
      return fullName.contains(input);
    }).toList();
    return chatTileList(suggestions, chatStream);
    //return chatTileList([suggestions]);
  }
}