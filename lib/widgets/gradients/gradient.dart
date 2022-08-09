import 'package:flutter/material.dart';

class CustomGradient {

  LinearGradient redGradient(){
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
      Color.fromRGBO(239, 85, 100, 1),
      Color.fromRGBO(195, 46, 66, 1),
      Color.fromRGBO(190, 40, 62, 1),
      Color.fromRGBO(210, 66, 78, 1),
      Color.fromRGBO(244, 130, 114, 1),
      ]
    );
  }

  LinearGradient blueGradient() {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.fromRGBO(0, 53, 190, 1), 
        Color.fromRGBO(57, 103, 224, 1), 
        Color.fromRGBO(117, 154, 255, 1)
      ],
    );
  }

}