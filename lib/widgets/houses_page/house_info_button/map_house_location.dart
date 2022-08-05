import 'package:flutter/material.dart';

class MapHouseLocation extends StatelessWidget {
  const MapHouseLocation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        children: const [
          Text(
            "Location",
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}