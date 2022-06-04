import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:swipable_stack/swipable_stack.dart';

const _images = [
  'assets/images/profile_pic.png',
  'assets/images/profile_pic.png',
  'assets/images/profile_pic.png',
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
    return SwipableStack(
      controller: _controller,
      builder: (context, properties) {
        //return Image.asset(_images[1]);
        final itemIndex = properties.index % _images.length;
        return Stack(
          children: [
            Image.asset(_images[itemIndex])
          ],
        );
      },
    );
  }
}