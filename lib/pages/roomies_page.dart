import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:roomies_app/widgets/card_provider.dart';
import 'package:roomies_app/widgets/tinder_card.dart';

class RoomiesPage extends StatelessWidget {
  RoomiesPage({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: Container(
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
            ]
          )
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          toolbarHeight: 200,
          title: Text(user.email!),
          actions: <Widget>[
            IconButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: const Icon(
                Icons.settings_applications_sharp,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    ),
    body: SizedBox(
      height: MediaQuery.of(context).size.height * 0.70,
      child: const SafeArea(
        child: TinderCard(
          urlImage: "assets/images/profile_pic.png",
        ),
      ),
    ),
  );
}

