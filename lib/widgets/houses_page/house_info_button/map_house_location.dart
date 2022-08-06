import 'package:flutter/material.dart';
import 'package:roomies_app/models/user_model.dart';
import 'package:roomies_app/widgets/houses_page/house_info_button/display_map_widget.dart';

class MapHouseLocation extends StatelessWidget {
  const MapHouseLocation({
    Key? key,
    required this.houseOwner,
  }) : super(key: key);

  final HouseOwner houseOwner;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Location",
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 12,),
          SizedBox(
            height: 200, 
            width: MediaQuery.of(context).size.width, 
            child: DisplayNeighborhoodLocation(houseOwner: houseOwner),
          ),
        ],
      ),
    );
  }
}