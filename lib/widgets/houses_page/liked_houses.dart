import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roomies_app/backend/houses_api.dart';
import 'package:roomies_app/backend/providers/house_profile_provider.dart';
import 'package:roomies_app/models/house_profile_model.dart';
import 'package:roomies_app/widgets/gradients/gradient.dart';

class LikedHouses extends StatefulWidget {
  const LikedHouses({
    Key? key,
    required this.houseProvider,
    required this.user,
  }) : super(key: key);

  final HouseProfileProvider houseProvider;
  final User user;

  @override
  State<LikedHouses> createState() => _LikedHousesState();
}

class _LikedHousesState extends State<LikedHouses> {
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
                "Liked houses",
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
                HousesLiked(houseProvider: widget.houseProvider, user: widget.user),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HousesLiked extends StatefulWidget {
  HousesLiked({
    Key? key,
    required this.houseProvider,
    required this.user,
  }) : super(key: key);

  final HouseProfileProvider houseProvider;
  final User user;

  @override
  State<HousesLiked> createState() => _HousesLikedState();
}

class _HousesLikedState extends State<HousesLiked> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: HousesAPI().getLikedHouses(widget.user.uid),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        var houses = snapshot.data as List<HouseProfileModel>;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(), 
          itemCount: snapshot.data!.length,
          itemBuilder: (BuildContext context, int index) { 
            return Text(houses[index].houseOwner.firstName);
          },
        );
      },
    );
  }
}