import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomies_app/backend/current_profile_provider.dart';
import 'package:roomies_app/backend/matches_provider.dart';
import 'package:roomies_app/models/user_model.dart';
import 'package:roomies_app/models/user_profile_model.dart';

import '../backend/database.dart';

class HousesPage extends StatelessWidget {
  const HousesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserProfileModel? currentUser = context.read<CurrentUserProvider>().currentUser;
    final List<UserModel> matches = context.read<MatchesProvider>().userModels;
    return currentUser == null ? 
      const Center(child:CircularProgressIndicator()):
      Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child:  AppBar(title: Text(currentUser.userModel.firstName + " " + currentUser.userModel.lastName)
          ),
        ),
        // body: FutureBuilder(
        //   future: FireStoreDataBase().getNewUsers(5, null),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.done) {
        //       List<UserModel> userList = snapshot.data as List<UserModel>;
        //       return Center(
        //         child: ListView.builder(
        //           padding: const EdgeInsets.only(top: 70,left: 70, bottom: 115),
        //           itemCount: userList.length,
        //           itemBuilder: (context, index) {
        //             var user = userList[index];
        //             return Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 Text("first name: ${user.firstName}"),
        //                 Text("last name: ${user.lastName}"),
        //                 Text("UID: ${user.id}"),
        //                 const SizedBox(height: 10,)
        //               ],
        //             );
        //           },
        //         ),
        //       );
        //     }
        //     if (snapshot.hasError) {
        //       return const Text(
        //         "Something went wrong",
        //       );
        //     }
        //     return const Center(child: CircularProgressIndicator(color: Colors.red));
        //   },
        // ),
        body: ListView.builder(
          itemCount: matches.length,
          itemBuilder: (context, index) => Text(matches[index].email)
        ),
            
    );
  }
}

