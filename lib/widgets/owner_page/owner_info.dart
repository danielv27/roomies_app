import 'package:flutter/material.dart';
import 'package:roomies_app/backend/current_house_provider.dart';
import 'package:roomies_app/backend/current_profile_provider.dart';

import '../../models/house_profile_model.dart';

class HouseOwnerContactInformation extends StatefulWidget {
  const HouseOwnerContactInformation({
    Key? key,
    required this.houseProvider
  }) : super(key: key);

  final CurrentHouseProvider houseProvider;

  @override
  State<HouseOwnerContactInformation> createState() => _HouseOwnerContactInformationState();
}

class _HouseOwnerContactInformationState extends State<HouseOwnerContactInformation> {
  @override
  Widget build(BuildContext context) {
    final HouseSignupProfileModel? houseProfile = widget.houseProvider.currentUser?.houseSignupProfileModel;

    return (houseProfile == null) 
    ? const Center(child: CircularProgressIndicator(color: Colors.blue)) 
    : Container(
        margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.125,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(245, 247, 251, 1),
            borderRadius: BorderRadius.circular(14.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Image.asset("assets/icons/Email.png",
                  height: 20,
                  width: 20,
                ),
                const SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: Text(
                    "Name: ${houseProfile.contactName}\nEmail: ${houseProfile.contactEmail}\nTel: ${houseProfile.contactPhoneNumber}",
                    style: const TextStyle(
                      color:Color.fromRGBO(101, 101, 107, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}