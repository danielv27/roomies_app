import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:roomies_app/backend/database.dart';
import 'package:roomies_app/pages/chat_page.dart';
import 'package:roomies_app/widgets/matches_page/user_tile.dart';
import '../../backend/matches_provider.dart';
import '../../models/message.dart';
import '../../models/user_model.dart';

class MatchesBodyWidget extends StatefulWidget {
  final MatchesProvider provider;
  
  const MatchesBodyWidget({
      Key? key,
      required this.provider
    }) : super(key: key);

  @override
  State<MatchesBodyWidget> createState() => _MatchesBodyWidgetState();
}

class _MatchesBodyWidgetState extends State<MatchesBodyWidget> {
  @override
  Widget build(BuildContext context){
    List<UserModel>? users = widget.provider.userModels;
    users?.sort((a, b) => a.lastName.compareTo(b.lastName));
    return users == null ? CircularProgressIndicator() :
    
    Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20)
          ),
        ),
        child: userTileList(users),
      )
    );
  }
}

Widget userTileList(List<UserModel> users){
  return ListView.builder(
    padding: const EdgeInsets.only(top: 18,bottom: 105),
    itemCount: users.length,
    itemBuilder: (context,index) => UserTile(user: users[index])
  );
}

      //need to add to an instance of a statefull class
      // bool isOnline = false;
      // FireStoreDataBase().checkIfOnline(users[index].id).listen(
      //   (event) {
      //     isOnline = event;
      //     isOnline ?
      //     print('${users[index].firstName} ${users[index].lastName} is online'):
      //     null;
      //   }
      // );

      
    



// Widget avatarWithOnlineIndicator(ImageProvider image,bool isOnline){
//   return !isOnline ? Stack(
//     children: [
      // CircleAvatar(
      //   radius: 30,
      //   backgroundColor: Colors.red[700],
      //   //backgroundImage: image,
      // ),
//       Container(
//         alignment: Alignment.bottomRight,
//         color: Colors.green,
//         width: 5,
//         height: 5,
//       )
//     ],
//   ):
//   CircleAvatar(
//     radius: 30,
//     backgroundColor: Colors.red[700],
//     backgroundImage: image,
//   );
// }

