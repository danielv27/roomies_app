import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart'; //breaks ios add font manually
import 'package:provider/provider.dart';
import 'package:roomies_app/backend/providers/user_profile_provider.dart';
import 'package:roomies_app/backend/users_api.dart';

import '../widgets/gradients/gradient.dart';
import '../widgets/roomies_page/swipable_cards.dart';

class RoomiesPage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;

  RoomiesPage({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    bool buttonInfoPressed = false;
    final userProvider = context.watch<UserProfileProvider>();
    return Scaffold(  
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: Container(
          decoration: BoxDecoration(
            gradient: redGradient()
          ),
          child: AppBar(
            centerTitle: false,
            automaticallyImplyLeading: false,
            systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            toolbarHeight: 75,
            title: Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 8),
              child: Text(
                "Find roommates",
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 35.0, bottom: 10),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: TextButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(9.0)),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(Colors.white.withOpacity(0.2))
                      ),
                      onPressed: () async {
                        UsersAPI().goOffline(FirebaseAuth.instance.currentUser?.uid);
                        await Future.delayed(const Duration(milliseconds: 150));
                        FirebaseAuth.instance.signOut();
                      },
                      child: Image.asset('assets/icons/nextroom_icon_white.png', width: 28),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.72,
        child: SwipableCards(userProvider: userProvider, buttonInfoPressed: buttonInfoPressed)          
      ),
    );
  }
}

