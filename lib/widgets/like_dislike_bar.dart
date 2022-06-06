import 'package:flutter/material.dart';
import 'package:swipable_stack/swipable_stack.dart';

Widget likeDislikeBar(BuildContext context, SwipableStackController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 23.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox.fromSize(
            size: const Size(56, 56),
            child: ClipOval(
              child: Material(
                color: Colors.white,
                child: InkWell(
                  splashColor: Colors.red[50],
                  onTap: () {
                    print("Dislike button pressed");
                    controller.next(swipeDirection: SwipeDirection.left);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      ImageIcon(
                        AssetImage("assets/icons/Close.png"),
                        color: Colors.red,
                        size: 26,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 30),    
          SizedBox.fromSize(
            size: const Size(70, 70),
            child: ClipOval(
              child: Material(
                color: Colors.red,
                child: InkWell(
                  splashColor: Colors.red[50],
                  onTap: () {
                    print("Like Button pressed");
                    controller.next(swipeDirection: SwipeDirection.right);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      ImageIcon(
                        AssetImage("assets/icons/Heart.png"),
                        color: Colors.white,
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 30),
          SizedBox.fromSize(
            size: const Size(56, 56),
            child: ClipOval(
              child: Material(
                color: Colors.white,
                child: InkWell(
                  splashColor: Colors.red[50],
                  onTap: () {
                    print("Info button pressed");
                    showUserInfo(context);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      ImageIcon(
                        AssetImage("assets/icons/Info.png"),
                        color: Color.fromARGB(255, 116, 201, 175),
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showUserInfo(BuildContext context) {
    showModalBottomSheet<void>(
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0), 
          topRight: Radius.circular(30.0)
        ),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: MediaQuery.of(context).viewInsets,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      const Text("Daniel Volpin"),
                      const Divider(
                        color: Color.fromARGB(255, 163, 163, 163),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "About",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                        ),
                      ),
                      const Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.. Readmore"),
                      const SizedBox(height: 12,),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Work",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                        ),
                      ),
                      const Text("Wonen op een prachtige locatie in de Pijp! Dit ruim appartement is onderdeel van een goed..."),
                      const SizedBox(height: 12,),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Study",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                        ),
                      ),
                      const Text("Wonen op een prachtige locatie in de Pijp! Dit ruim appartement is onderdeel van .."),
                      const SizedBox(height: 20),
                      Row(),
                      const SizedBox(height: 200),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }