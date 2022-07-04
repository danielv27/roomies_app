import 'package:flutter/material.dart';

import '../circle_ring.dart';

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
        Column(
          children: [
            apartmentOption(context),
            
          ],
        ),
      ],
    );
  }

  GestureDetector apartmentOption(BuildContext context) {
    return GestureDetector(
      onTap: () { 
        print("Tapped a Container"); 
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.1,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(245,247,251, 1),
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CustomPaint(
                size: const Size(20, 20),
                painter: CirclePainter(),
              ),
              const SizedBox(width: 14,),
              const Text(
                "Apartment",
                style: TextStyle(
                  color: Color.fromRGBO(101,101,107, 1),
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Image.asset(
                "assets/icons/Grey-house.png",
                height: 20,
                width: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}