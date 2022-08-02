import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:roomies_app/backend/providers/house_profile_provider.dart';
import 'package:roomies_app/widgets/gradients/gradient.dart';
import 'package:roomies_app/widgets/houses_page/liked_houses_page.dart';
import 'package:roomies_app/widgets/houses_page/swipable_cards.dart';

class HousesPage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;

  HousesPage({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool buttonInfoPressed = false;
    final houseProvider = context.watch<HouseProfileProvider>();
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
                "Find livings",
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LikedHouses(houseProvider: houseProvider, user: user)),
                        );
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
        child: SwipableCards(houseProvider: houseProvider, buttonInfoPressed: buttonInfoPressed)          
      ),
    );
  }
}

