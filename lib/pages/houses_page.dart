import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roomies_app/models/user_model.dart';

import '../backend/database.dart';

class HousesPage extends StatelessWidget {
  const HousesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: FutureBuilder(
          future: FireStoreDataBase().getCurrentUser(),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              UserModel currentUser = snapshot.data as UserModel;
              return AppBar(title: Text(currentUser.firstName));
            }
            if (snapshot.hasError) {
              return const Text(
                "Something went wrong",
              );
            }
            return const Center(child: CircularProgressIndicator(color: Colors.red));
          },
        ),
      ),
      body: FutureBuilder(
            future: FireStoreDataBase().getUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<UserModel> userList = snapshot.data as List<UserModel>;
                return Center(
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 70,left: 70, bottom: 115),
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      var user = userList[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("first name: ${user.firstName}"),
                          Text("last name: ${user.lastName}"),
                          Text("UID: ${user.id}"),
                          SizedBox(height: 10,)
                        ],
                      );
                    },
                  ),
                );
              }
              if (snapshot.hasError) {
                return const Text(
                  "Something went wrong",
                );
              }
              return const Center(child: CircularProgressIndicator(color: Colors.red));
            },
          ),
    );
  }
}

