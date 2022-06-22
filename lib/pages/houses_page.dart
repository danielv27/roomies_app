import 'package:flutter/material.dart';
import 'package:roomies_app/models/user_types.dart';

import '../backend/database.dart';

class HousesPage extends StatelessWidget {
  const HousesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.green,
      body: FutureBuilder(
            future: FireStoreDataBase().getUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<UserModel> userList = snapshot.data as List<UserModel>;
                return Center(
                  child: ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      var user = userList[index];
                      return Column(
                        children: [
                          Text("first name: ${user.id}"),
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

