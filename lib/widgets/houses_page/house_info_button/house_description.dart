import 'package:flutter/material.dart';
import 'package:roomies_app/models/house_profile_model.dart';

class HouseDescription extends StatelessWidget {
  const HouseDescription({
    Key? key,
    required this.houseProfile,
  }) : super(key: key);

  final HouseSignupProfileModel houseProfile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Description",
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              houseProfile.houseDescription,
              style: const TextStyle(
                color: Color.fromRGBO(128, 128, 128, 1),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}