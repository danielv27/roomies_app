import 'package:flutter/material.dart';
import '../../models/user_types.dart';

class MatchesHeaderWidget extends StatelessWidget {
  final List<UserModel> users;

  const MatchesHeaderWidget({
      Key? key,
      required this.users
    }) : super(key: key);
  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(top:32),
      child: Column(
        children: [
          searchBar(users),
          SizedBox(height: MediaQuery.of(context).size.height*0.02),
          circularUserList(context, users),
        ],
      ),
    );
  }
}

Widget searchBar(List<UserModel> users){
  return AppBar(
    centerTitle: false,
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    actions: [
        CircleAvatar(
        radius: 32,
        backgroundColor: Colors.white.withOpacity(0.4),
        child: const Icon(Icons.search_rounded,color: Colors.white,),
      ),
      CircleAvatar(
        backgroundColor: Colors.red,
        radius: 32,
        backgroundImage: NetworkImage(users[1].firstImgUrl),
      ),
      const Padding(padding: EdgeInsets.only(right: 16))

    ],
    title: Column(
      children: [
        const Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Good night,",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "${users[1].firstName} ${users[1].lastName}",
            style: const TextStyle(
              //fontSize: 16,
              color: Colors.white
            ),
          ),
        ),
      ],
    ),
  );
}

Widget circularUserList(BuildContext context, List<UserModel> users){
  return SizedBox(
    height: MediaQuery.of(context).size.height *0.13,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: users.length,
      itemBuilder: (context, index){
        return Padding(
          padding: const EdgeInsets.only(top: 11,left: 15,right: 4),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.red[700],
                radius: 28,
                backgroundImage: NetworkImage(users[index].firstImgUrl),
              ),
              Text(users[index].firstName, style: TextStyle(color: Colors.white),)
            ],
          ),
        );
      }
    ), 
  );
}