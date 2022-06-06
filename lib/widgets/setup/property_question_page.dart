import 'package:flutter/material.dart';

class PropertyQuestionPage extends StatelessWidget {
  const PropertyQuestionPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget> [
        Container(
          padding: const EdgeInsets.only(left: 30.0, right: 30, top: 5),
          alignment: Alignment.centerLeft,
          child: const Text(
    "Cannenburgh 1, 1018 LG Amsterdam", 
    style: TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.grey,
    ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 30.0, right: 30, top: 5),
          alignment: Alignment.centerLeft,
          child: const Text(
    "What type of property?", 
    style: TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: 24,
    ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}