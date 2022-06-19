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
    return Container(
      decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
        Color.fromRGBO(239, 85, 100, 1),
        Color.fromRGBO(195, 46, 66, 1),
        Color.fromRGBO(190, 40, 62, 1),
        Color.fromRGBO(210, 66, 78, 1),
        Color.fromRGBO(244, 130, 114, 1),
    ])),
      child: Padding(
        padding: const EdgeInsets.only(left:16.0,top:30),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Hello",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "${users[1].firstName} ${users[1].lastName}",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
            ),
            SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: users.length,
                  itemBuilder: (context, index){
                    return Padding(
                      padding: const EdgeInsets.only(right:11.0,top: 11),
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 32,
                            backgroundImage: NetworkImage(users[index].firstImgUrl),
                          ),
                          Text(users[index].firstName, style: TextStyle(color: Colors.white),)
                        ],
                      ),
                    );
                  }
                  ),
              
            ),
          ],
        ),
      ),
    );
  }
}