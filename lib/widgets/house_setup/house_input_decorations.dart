import 'package:flutter/material.dart';

class CustomHouseDecorations {

  InputDecoration setupFormDecoration(String labelText) {
    return InputDecoration(
      filled: true,
      fillColor: const Color.fromRGBO(245, 247, 251, 1),
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 0,
          style: BorderStyle.none,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      prefixIcon: const Align(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: Image(
          image: AssetImage('assets/icons/person.png'),
          height: 15,
          width: 15,
        ),
      ),
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.grey),
    );
  }

  InputDecoration lastSetupPageDecoration(String hintText, var imageIcon) {
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
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Align(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: Image(
            image: imageIcon,
            height: 15,
            width: 15,
          ),
        ),
      ),
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w300),
    );
  }

  Text textDescription(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color.fromRGBO(101, 101, 107, 1),
      ),
    );
  }

}