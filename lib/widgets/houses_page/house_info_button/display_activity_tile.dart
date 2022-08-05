import 'package:flutter/material.dart';

class ActivityIcon {  
  const ActivityIcon({
    required this.title, 
    required this.icon
  });  

  final String title;  
  final Image icon;  
} 
  
class DisplayActivityTile extends StatelessWidget {  
  const DisplayActivityTile({
    Key? key, 
    required this.activityTile,
    required this.borderRadius,
  }) : super(key: key);  

  final ActivityIcon activityTile;  
  final BorderRadius borderRadius;
  
  @override  
  Widget build(BuildContext context) {  
    return Card(  
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Color.fromRGBO(238, 238, 238, 1),
        ),
        borderRadius: borderRadius,
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,  
          children: <Widget>[  
            Expanded(child: SizedBox(child: activityTile.icon,)),  
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Text(
                activityTile.title, 
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                ),
              ),
            ),
          ]  
        ),  
      ),  
    );
  }
}  