import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart'; //breaks ios add font manually
import '../backend/database.dart';
import '../widgets/swipable_cards.dart';

//user for swipable cards testing. should be removed once images are added to database users
const _images = [
  'assets/images/profile_pic.png',
  'assets/images/profile_pic.png',
  'assets/images/profile_pic.png',
];

class RoomiesPage extends StatelessWidget {
  RoomiesPage({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser!;
  List dataList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              ])),
          child: AppBar(
            automaticallyImplyLeading: false,
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
            //likeDislikeBar(context),
          ],
        ),
  );
  }
  

  SizedBox imageRoomiesInfo(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.72,
      child: SwipableCards(),

      // child: Stack(
      //   children: <Widget>[
      //     Container(color: Colors.red,
      //     ),
      //     SizedBox(
      //       child: FutureBuilder(
      //         future: FireStoreDataBase().getData(),
      //         builder: (context, snapshot) {
      //           if (snapshot.hasError) {
      //             return const Text(
      //               "Something went wrong",
      //             );
      //           }
      //           if (snapshot.connectionState == ConnectionState.done) {
      //             dataList = snapshot.data as List;
      //             return Container(); //return buildUsers(dataList);
      //           }
      //           return const Center(child: CircularProgressIndicator(color: Colors.red));
      //         },
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  // Row likeDislikeBar(BuildContext context) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: <Widget>[
  //       SizedBox.fromSize(
  //         size: const Size(56, 56),
  //         child: ClipOval(
  //           child: Material(
  //             color: Colors.white,
  //             child: InkWell(
  //               splashColor: Colors.red[50],
  //               onTap: () {
  //                 print("Dislike button pressed");
  //               },
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: const <Widget>[
  //                   ImageIcon(
  //                     AssetImage("assets/icons/Close.png"),
  //                     color: Colors.red,
  //                     size: 26,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //       const SizedBox(width: 30),    
  //       SizedBox.fromSize(
  //         size: const Size(70, 70),
  //         child: ClipOval(
  //           child: Material(
  //             color: Colors.red,
  //             child: InkWell(
  //               splashColor: Colors.red[50],
  //               onTap: () {
  //                 print("Like Button pressed");
  //               },
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: const <Widget>[
  //                   ImageIcon(
  //                     AssetImage("assets/icons/Heart.png"),
  //                     color: Colors.white,
  //                     size: 30,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //       const SizedBox(width: 30),
  //       SizedBox.fromSize(
  //         size: const Size(56, 56),
  //         child: ClipOval(
  //           child: Material(
  //             color: Colors.white,
  //             child: InkWell(
  //               splashColor: Colors.red[50],
  //               onTap: () {
  //                 print("Info button pressed");
  //                 showUserInfo(context);
  //               },
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: const <Widget>[
  //                   ImageIcon(
  //                     AssetImage("assets/icons/Info.png"),
  //                     color: Color.fromARGB(255, 116, 201, 175),
  //                     size: 30,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // void showUserInfo(BuildContext context) {
  //   showModalBottomSheet<void>(
  //     barrierColor: Colors.transparent,
  //     isScrollControlled: true,
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(30.0), 
  //         topRight: Radius.circular(30.0)
  //       ),
  //     ),
  //     builder: (BuildContext context) {
  //       return SingleChildScrollView(
  //         padding: MediaQuery.of(context).viewInsets,
  //         child: Center(
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               Container(
  //                 padding: const EdgeInsets.all(15),
  //                 child: Column(
  //                   children: [
  //                     const Text("Daniel Volpin"),
  //                     const Divider(
  //                       color: Color.fromARGB(255, 163, 163, 163),
  //                     ),
  //                     const Align(
  //                       alignment: Alignment.centerLeft,
  //                       child: Text(
  //                         "About",
  //                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
  //                       ),
  //                     ),
  //                     const Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.. Readmore"),
  //                     const SizedBox(height: 12,),
  //                     const Align(
  //                       alignment: Alignment.centerLeft,
  //                       child: Text(
  //                         "Work",
  //                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
  //                       ),
  //                     ),
  //                     const Text("Wonen op een prachtige locatie in de Pijp! Dit ruim appartement is onderdeel van een goed..."),
  //                     const SizedBox(height: 12,),
  //                     const Align(
  //                       alignment: Alignment.centerLeft,
  //                       child: Text(
  //                         "Study",
  //                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
  //                       ),
  //                     ),
  //                     const Text("Wonen op een prachtige locatie in de Pijp! Dit ruim appartement is onderdeel van .."),
  //                     const SizedBox(height: 20),
  //                     Row(),
  //                     const SizedBox(height: 200),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget buildUsers(dataList) {
  //   return SizedBox(
  //     height: 300,
  //     child: ListView.builder(
  //       reverse: true, //makes a column start from the bottom
  //       padding: const EdgeInsets.all(24),
  //       itemCount: dataList.length,
  //       itemBuilder: (BuildContext context, int index) {
  //         return (dataList[index] != null)? Row(
  //           children: <Widget>[
  //             Text(
                
  //               (dataList[index]["firstName"] +
  //                   " " +
  //                   dataList[index]["lastName"] +
  //                   ", "),
  //               style: const TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.white,
  //                   fontSize: 28
  //               ),
  //             ),
  //           ],
  //         ): Container();
  //       },
  //     ),
  //   );
  // }
}
