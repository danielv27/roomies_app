import 'package:flutter/material.dart';

class CustomDecorations {

  InputDecoration signupInputDecoration(String labelName, IconData icon){
    return InputDecoration(
      filled: true,
      fillColor: const Color.fromRGBO(245, 247, 251, 1),
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 0,
          style: BorderStyle.none,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      labelText: labelName,
      labelStyle: const TextStyle(color: Colors.grey),
      prefixIcon: const Align(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: Image(
          image: AssetImage('assets/icons/person.png'),
          height: 15,
          width: 15,
        ),
      ),
    );
  }

  InputDecoration emailInputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: const Color.fromRGBO(245, 247, 251, 1),
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 0,
          style: BorderStyle.none,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      prefixIcon: const Align(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: Image(
          image: AssetImage('assets/icons/Email.png'),
          height: 20,
          width: 20,
        ),
      ),
      labelText: "Email",
      labelStyle: const TextStyle(color: Colors.grey),
    );
  }

}