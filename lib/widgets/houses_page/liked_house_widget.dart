import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roomies_app/backend/houses_api.dart';
import 'package:roomies_app/backend/providers/house_profile_provider.dart';
import 'package:roomies_app/models/house_profile_model.dart';

import 'house_information_tile.dart';

class HousesLiked extends StatefulWidget {
  const HousesLiked({
    Key? key,
    required this.houseProvider,
    required this.user,
  }) : super(key: key);

  final HouseProfileProvider houseProvider;
  final User user;

  @override
  State<HousesLiked> createState() => _HousesLikedState();
}

class _HousesLikedState extends State<HousesLiked> {
  List<HouseProfileModel>? houses;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: HousesAPI().getLikedHouses(widget.user.uid),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.red));
        }
        if(snapshot.hasData){
          houses = snapshot.data as List<HouseProfileModel>;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: houses!.length,
            itemBuilder: (BuildContext context, int index) {
              var house = houses![index];
              return HouseInformationTile(house: house, index: index, infoButtonEnabled: true);
            },
          );
        }
        return const Text('No houses have been liked');
      },
    );
  }
}

