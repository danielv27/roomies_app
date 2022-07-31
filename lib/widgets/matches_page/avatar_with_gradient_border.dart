import 'package:flutter/material.dart';
import 'package:roomies_app/widgets/gradients/gradient.dart';

class AvatarWithGradientBorder extends StatelessWidget {
  final Color? backgroundColor;
  final double radius;
  final ImageProvider<Object>? image;
  final double borderWidth;
  

  const AvatarWithGradientBorder({
    Key? key,
    this.backgroundColor,
    required this.radius,
    this.image,
    required this.borderWidth
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:const  BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
          Color.fromARGB(255, 255, 113, 127),
          Color.fromARGB(255, 180, 54, 64),
          Color.fromARGB(255, 160, 36, 54),
          Color.fromARGB(255, 243, 55, 80),
          Color.fromRGBO(244, 130, 114, 1),
          ]
        ),
        shape: BoxShape.circle
      ),
      padding: EdgeInsets.all(borderWidth),
      child: CircleAvatar(
        backgroundColor: backgroundColor,
        radius: radius,
        backgroundImage: image,
      ),
    );
  }
}