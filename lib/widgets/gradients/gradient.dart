import 'package:flutter/material.dart';

Gradient redGradient(){
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