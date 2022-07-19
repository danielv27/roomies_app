import 'package:flutter/material.dart';

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