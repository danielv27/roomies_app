import 'package:flutter/material.dart';
import 'package:roomies_app/widgets/houses_page/house_info_button/display_activity_tile.dart';
import 'package:roomies_app/widgets/houses_page/house_info_button/select_media_tile.dart';

class HouseActivityTiles extends StatelessWidget {
  const HouseActivityTiles({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    const List<ActivityIcon> activityTiles = <ActivityIcon>[  
      ActivityIcon(
        title: 'Single Matches', 
        icon: Image(
          image: AssetImage("assets/icons/Show.png"), 
          fit: BoxFit.contain, 
          width: 30, height: 30,
        ),
      ),  
      ActivityIcon(
        title: 'Group Matches', 
        icon: Image(
          image: AssetImage("assets/icons/Heart-red-gradient.png"), 
          fit: BoxFit.contain, 
          width: 27, height: 27,
        ),
      ),  
      ActivityIcon(
        title: 'On Roomies', 
        icon: Image(
          image: AssetImage("assets/icons/Calendar.png"), 
          fit: BoxFit.contain, 
          width: 25, height: 25,
        ),
      ),  
    ];  

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textTitle("Activity"),
          const SizedBox(height: 12,),
          SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: DisplayActivityTile(activityTile: activityTiles[0], borderRadius: const BorderRadius.only(topLeft: Radius.circular(15.0), bottomLeft: Radius.circular(15.0)))), 
                Expanded(child: DisplayActivityTile(activityTile: activityTiles[1], borderRadius: const BorderRadius.only())), 
                Expanded(child: DisplayActivityTile(activityTile: activityTiles[2], borderRadius: const BorderRadius.only(topRight: Radius.circular(15.0), bottomRight: Radius.circular(15.0)))), 
              ],
            ),
          ),
        ],
      ),
    );
  }

  Text textTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold, 
        fontSize: 20,
      ),
    );
  }
}