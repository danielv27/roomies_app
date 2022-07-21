import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../backend/database.dart';
import '../../models/user_model.dart';

class OwnerBar extends StatelessWidget {
  const OwnerBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String dayTime = "morning";
    if(now.hour >= 21){
      dayTime = "night";
    }
    else if(now.hour >= 18){
      dayTime = "evening";
    }
    else if(now.hour >= 12){
      dayTime = "afternoon";
    }
    return FutureBuilder(
      future: FireStoreDataBase().getCurrentUserModel(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          UserModel currentUser = snapshot.data as UserModel;
          return AppBar(
            automaticallyImplyLeading: false,
            systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            toolbarHeight: 75,
            title: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Good $dayTime,",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                ),
                const SizedBox(height: 4,),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "${currentUser.firstName} ${currentUser.lastName}",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Center(
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
                      await Future.delayed(const Duration(milliseconds: 150));
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pop(); // remove this when main.dart is implemented with user type
                    },
                    child: Image.asset('assets/icons/nextroom_icon_white.png', width: 28),
                  ),
                ),
              ),
            ],
          );
        }
        if (snapshot.hasError) {
          return const Text(
            "Something went wrong",
          );
        }
        return const Center(child: CircularProgressIndicator());
      }
    );
  }
}