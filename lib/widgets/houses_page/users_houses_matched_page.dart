import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:roomies_app/backend/houses_api.dart';
import 'package:roomies_app/backend/users_api.dart';
import 'package:roomies_app/models/house_profile_model.dart';
import 'package:roomies_app/models/user_model.dart';
import 'package:roomies_app/widgets/gradients/gradient.dart';

class UsersHousesMatched extends StatefulWidget {
  UsersHousesMatched({
    Key? key,
    required this.house,
  }) : super(key: key);

  final HouseProfileModel house;

  @override
  State<UsersHousesMatched> createState() => _UsersHousesMatchedState();
}

class _UsersHousesMatchedState extends State<UsersHousesMatched> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: Container(
          decoration: BoxDecoration(
            gradient: redGradient()
          ),
          child: AppBar(
            centerTitle: true,
            systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            toolbarHeight: 75,
            title: Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 8),
              child: Text(
                "Matched Users",
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 30.0, right: 30, top: 5),
          height: MediaQuery.of(context).size.height * 0.72,
          child: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder(
                  future: Future.wait([
                      UsersAPI().getMatches(FirebaseAuth.instance.currentUser!.uid),
                      HousesAPI().getUserEncounters(widget.house.houseOwner.id, widget.house.houseRef),
                  ]),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.red));
                    }
                    List<UserModel> matchedUsers = snapshot.data[0] as List<UserModel>;
                    List<UserModel> usersLikedHouse = snapshot.data[1] as List<UserModel>;
                    List<UserModel>? matched = [];
                    for (var matchedUser in matchedUsers) {
                      for (var likedHouse in usersLikedHouse) {
                        if (matchedUser.id == likedHouse.id) {
                          matched.add(matchedUser);
                        }
                      }
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(), 
                      itemCount: matched.length,
                      itemBuilder: (BuildContext context, int index) { 
                        return Text("${matched[index].firstName} ${matched[index].lastName}");
                      }
                    );
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}