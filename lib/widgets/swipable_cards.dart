import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:swipable_stack/swipable_stack.dart';
import '../widgets/like_dislike_bar.dart';

const _images = [
  'assets/images/profile_pic2.jpg',
  'assets/images/profile_pic3.jpg',
  'assets/images/profile_pic4.jpg',
  'assets/images/profile_pic5.jpg',
];

class SwipableCards extends StatefulWidget {
  @override
  SwipableCardsState createState() => SwipableCardsState();
}

class SwipableCardsState extends State<SwipableCards> {
  late final SwipableStackController _controller;

  void _listenController() => setState(() {});

  @override
  void initState() {
    super.initState();
    _controller = SwipableStackController()..addListener(_listenController);
  }

  @override
  void dispose() {
    super.dispose();
    _controller
      ..removeListener(_listenController)
      ..dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:
      [
        SwipableStack(
          controller: _controller,
          builder: (context, properties) {
            final itemIndex = properties.index % _images.length;
            return Stack(
            
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.72,
                  child: Image.asset(_images[itemIndex],fit: BoxFit.fitHeight)
                ),
                const Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 120),
                    child: Text(
                      "Daniel Volpin", 
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32
                      )
                    ),
                  )
                )
              ],
            );
          },
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: likeDislikeBar(context),
          
        ),
      ]
    );
  }
}