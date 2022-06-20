import 'package:flutter/material.dart';
import 'package:roomies_app/backend/database.dart';
import '../models/user_types.dart';
import '../widgets/matches_page/matches_body.dart';
import '../widgets/matches_page/matches_header.dart';

import 'chat_page.dart'; //for later when using navigator.push for a specific chat

class MatchesPage extends StatelessWidget {
  const MatchesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
          child: FutureBuilder(
            future: FireStoreDataBase().getUsers(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.done){
                List<UserModel> userList = snapshot.data as List<UserModel>;
                return Column(
                  children: [
                    MatchesHeaderWidget(users: userList),
                    MatchesBodyWidget(users: userList)
                  ] 
                );             
              }
              if (snapshot.hasError) {
                return const Text("Something went wrong");
              }
              return const Center(child: CircularProgressIndicator(color: Colors.red));
        
            },
          ),
        ),
      
    );
  }
}


