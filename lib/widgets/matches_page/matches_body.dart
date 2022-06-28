import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:roomies_app/pages/chat_page.dart';
import '../../models/user_model.dart';

class MatchesBodyWidget extends StatelessWidget {
  final List<UserModel> users;
  
  const MatchesBodyWidget({
      Key? key,
      required this.users
    }) : super(key: key);
  @override
  Widget build(BuildContext context){
    users.sort((a, b) => a.lastName.compareTo(b.lastName));
    return Expanded(
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
    padding: EdgeInsets.only(top: 18,bottom: 105),
    itemCount: users.length,
    itemBuilder: (context,index){
      return Padding(
        padding: const EdgeInsets.only(left:18.0,bottom: 23),
        child: GestureDetector(
          onTap: () => {
            print('start chat with ${users[index].firstName} ${users[index].lastName}'),
            Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: ChatPage(otherUser: users[index],)))
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.red[700],
                backgroundImage: NetworkImage(users[index].firstImgUrl),
              ),
              SizedBox(width: MediaQuery.of(context).size.width*0.04,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Text(
                    "${users[index].firstName} ${users[index].lastName}",
                    textAlign: TextAlign.left,
                  ),
                  Text("last message sent",textAlign: TextAlign.left,)
                ]
              )
            ],
          ),
        ),
      );
    },
  );
}