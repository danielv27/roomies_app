import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roomies_app/widgets/tinder_card.dart';

import '../backend/database.dart';

class RoomiesPage extends StatelessWidget {
  RoomiesPage({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser!;
  List dataList = [];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: PreferredSize(
      preferredSize: const Size.fromHeight(75),
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
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          toolbarHeight: 75,
          title: Text(
            "Find roommates",
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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
    body: Column(
      children: [
        imageRoomiesInfo(context),
        const SizedBox(height: 15),
        likeDislikeBar(),
      ],
    ),
  );

  SizedBox imageRoomiesInfo(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.60,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          const TinderCard(
            urlImage: "assets/images/profile_pic.png",
          ),
          SizedBox(
            child: FutureBuilder(
              future: FireStoreDataBase().getData(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text(
                    "Something went wrong",
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  dataList = snapshot.data as List;
                  return buildUsers(dataList);
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }

  Row likeDislikeBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 56,
          height: 56,
          child: GestureDetector(
            onTap: () => print("pressed dislike"),
            child: const ImageIcon(
              AssetImage("assets/icons/Vector.png"),
              color: Colors.red,
              size: 26,
            ),
          ),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 5,
                offset: const Offset(0, 2), 
              ),
            ],
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 30),
        Container(
          width: 74,
          height: 74,
          child: GestureDetector(
            onTap: () => print("pressed like"),
            child: const ImageIcon(
              AssetImage("assets/icons/Heart.png"),
              color: Colors.white,
              size: 26,
            ),
          ),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 5,
                offset: const Offset(0, 2), 
              ),
            ],
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(239, 85, 100, 1),
                Color.fromRGBO(195, 46, 66, 1),
                Color.fromRGBO(190, 40, 62, 1),
                Color.fromRGBO(210, 66, 78, 1),
                Color.fromRGBO(244, 130, 114, 1),
              ]
            ),
          ),
        ),
        const SizedBox(width: 30),
        Container(
          width: 56,
          height: 56,
          child: GestureDetector(
            onTap: () => print("user information"),
            child: const ImageIcon(
              AssetImage("assets/icons/info-icon.png"),
              color: Color.fromARGB(255, 116, 201, 175),
              size: 26,
            ),
          ),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 5,
                offset: const Offset(0, 2), 
              ),
            ],
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget buildUsers(dataList) {
    return ListView.separated(
      reverse: true, //makes a column start from the bottom
      padding: const EdgeInsets.all(28),
      itemCount: dataList.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          verticalDirection: VerticalDirection.down,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  (dataList[index]["firstName"] + " " + dataList[index]["lastName"] + ", "),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 28),
                ),
                Text(
                  (dataList[index]["age"]),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 28),
                ),
              ]
            ),
            Text(
              dataList[index]["email"],
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        );
      },
    );
  }

}

