import 'package:flutter/material.dart';
import 'package:roomies_app/widgets/houses_page/house_info_button/select_media_tile.dart';

class HouseMediaTiles extends StatelessWidget {
  const HouseMediaTiles({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
  const List<Choice> mediaTiles = <Choice>[  
    Choice(
      title: 'Pattleground', 
      icon: ImageIcon(
        AssetImage("assets/icons/ground.png"), 
        size: 30, 
        color: Color.fromRGBO(128, 128, 128, 1),
      ),
    ),  
    Choice(
      title: '360', 
      icon: ImageIcon(
        AssetImage("assets/icons/360.png"), 
        size: 36, 
        color: Color.fromRGBO(128, 128, 128, 1)
      ),
    ),  
    Choice(
      title: 'Video', 
      icon: ImageIcon(
        AssetImage("assets/icons/play.png"), 
        size: 30, 
        color: Color.fromRGBO(128, 128, 128, 1),
      ),
    ),  
  ];  

    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: SizedBox(
        height: 90,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(child: SelectMediaTile(choice: mediaTiles[0], borderRadius: const BorderRadius.only(topLeft: Radius.circular(15.0), bottomLeft: Radius.circular(15.0)))), 
            Expanded(child: SelectMediaTile(choice: mediaTiles[1], borderRadius: const BorderRadius.only())), 
            Expanded(child: SelectMediaTile(choice: mediaTiles[2], borderRadius: const BorderRadius.only(topRight: Radius.circular(15.0), bottomRight: Radius.circular(15.0)))), 
          ],
        ),
      ),
    );
  }
}