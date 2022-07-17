import 'package:flutter/material.dart';
import 'package:roomies_app/backend/database.dart';
import 'package:roomies_app/widgets/gradients/gradient.dart';
import '../models/user_model.dart';
import '../widgets/matches_page/matches_body.dart';
import '../widgets/matches_page/matches_header.dart';

import 'chat_page.dart'; //for later when using navigator.push for a specific chat

class MatchesPage extends StatelessWidget {
  const MatchesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
          gradient: redGradient()
          ),
          child: FutureBuilder(
            future: FireStoreDataBase().getUsers(4),
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


