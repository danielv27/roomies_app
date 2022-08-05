import 'package:flutter/material.dart';

class Choice {  
  const Choice({
    required this.title, 
    required this.icon
  });  

  final String title;  
  final ImageIcon icon;  
} 
  
class SelectMediaTile extends StatelessWidget {  
  const SelectMediaTile({
    Key? key, 
    required this.choice,
    required this.borderRadius,
  }) : super(key: key);  

  final Choice choice;  
  final BorderRadius borderRadius;
  
  @override  
  Widget build(BuildContext context) {  
    return GestureDetector(
      child: Card(  
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
              Expanded(child: Container(child: choice.icon)),  
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Text(
                  choice.title, 
                  style: const TextStyle(
                    color: Color.fromRGBO(128, 128, 128, 1),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ]  
          ),  
        ),  
      ),
      onTap: () {
        print("Tapped ${choice.title}");
      }
    );
  }
}  