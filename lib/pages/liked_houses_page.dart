import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roomies_app/backend/providers/house_profile_provider.dart';
import 'package:roomies_app/widgets/gradients/gradient.dart';
import 'package:roomies_app/widgets/houses_page/liked_house_widget.dart';

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
            gradient: CustomGradient().redGradient()
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
      body: Container(
        padding: const EdgeInsets.only(left: 30.0, right: 30, top: 5),
        child: HousesLiked(
          houseProvider: widget.houseProvider, user: widget.user
        ),
      ),
    );
  }
}