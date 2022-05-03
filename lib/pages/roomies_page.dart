import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RoomiesPage extends StatelessWidget {


  const RoomiesPage({Key? key}) : super(key: key);
  @override
  
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(180),
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
            toolbarHeight: 400,
            title: Text(user.email!),
            actions: <Widget>[
              IconButton(
                onPressed: () => FirebaseAuth.instance.signOut(),
                icon: const Icon(Icons.settings_applications_sharp, size: 32,),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Text('Roomies'),
      ),
    );
  }
}