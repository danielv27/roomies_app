import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomies_app/backend/providers/house_profile_provider.dart';
import 'package:roomies_app/models/house_profile_model.dart';
import 'package:roomies_app/widgets/gradients/gradient.dart';
import 'package:swipable_stack/swipable_stack.dart';

import '../../models/user_profile_model.dart';

class LikeDislikeBar extends StatefulWidget {
  const LikeDislikeBar({
    Key? key,
    required this.swipeController,
    required this.houseProfileModels,
    required this.currentHouseIndex,
  }) : super(key: key);

  final SwipableStackController swipeController;
  final List<HouseProfileModel>? houseProfileModels;
  final int currentHouseIndex;

  @override
  State<LikeDislikeBar> createState() => _LikeDislikeBarState();
}

class _LikeDislikeBarState extends State<LikeDislikeBar> {
  bool buttonInfoPressed = false;

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var modalSheetHeight = buttonInfoPressed ? 0.8 : 0.5;

    return Padding(
      padding: const EdgeInsets.only(bottom: 23.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox.fromSize(
            size: const Size(56, 56),
            child: ClipOval(
              child: Material(
                color: Colors.white.withOpacity(0.4),
                child: InkWell(
                  splashColor: Colors.red[50],
                  onTap: () {
                    widget.swipeController.next(swipeDirection: SwipeDirection.left);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      ImageIcon(
                        AssetImage("assets/icons/Close.png"),
                        color: Colors.red,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 30),    
          SizedBox.fromSize(
            size: const Size(70, 70),
            child: ClipOval(
              child: Container(
                decoration: BoxDecoration(
                  gradient: redGradient(),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.red[50],
                    onTap: () {
                      widget.swipeController.next(swipeDirection: SwipeDirection.right);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        ImageIcon(
                          AssetImage("assets/icons/Heart.png"),
                          color: Colors.white,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 30),
          SizedBox.fromSize(
            size: const Size(56, 56),
            child: ClipOval(
              child: Material(
                color: Colors.white.withOpacity(0.4),
                child: InkWell(
                  splashColor: Colors.red[50],
                  onTap: () {
                    final currentUserIndex = context.read<HouseProfileProvider>().pagesSwiped;
                    showUserInfo(context, widget.houseProfileModels![currentUserIndex], modalSheetHeight);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      ImageIcon(
                        AssetImage("assets/icons/Info_circle.png"),
                        color: Colors.white,
                        size: 28,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showUserInfo(BuildContext context, HouseProfileModel houseProfileModel, double modalSheetHeight) {
    showStickyFlexibleBottomSheet(
      context: context,
      minHeight: 0,
      initHeight: 0.5,
      maxHeight: 0.95,
      headerHeight: 165,
      anchors: [0, 0.5, 0.95],
      bottomSheetColor: Colors.transparent,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0), 
          topRight: Radius.circular(30.0)
        ),
        shape: BoxShape.rectangle,
        color: Colors.white,
      ),
      headerBuilder: (BuildContext context, double bottomSheetOffset) {
        return headerInfo(houseProfileModel); 
      },
      bodyBuilder: (BuildContext context, double offset) {
        return bodyInfo(houseProfileModel);
      },
    );
  }

  Widget headerInfo(HouseProfileModel houseProfileModel) {
    var houseProfile = houseProfileModel.houseOwner.houseSignupProfileModel;

    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      child: Column(
        children: [
          Center(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                color: Color.fromRGBO(238, 238, 238, 1),
              ),
              height: 5,
              width: 80,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15.0, top:  25.0),
              child: Text(
                "Ceintuurbaan ${houseProfile.houseNumber}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
          ),
          Row(
            children: [
              Text(
                "${houseProfile.postalCode}, Amsterdam",
                style: const TextStyle(
                  color: Color.fromRGBO(128, 128, 128, 1),
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Image.asset("assets/icons/apartment-size.png", width: 18, height: 18,),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  "${houseProfile.livingSpace}m\u00B2",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
              const Spacer(),
              Image.asset("assets/icons/number-rooms.png", width: 18, height: 18,),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  "${houseProfile.numRoom} Rooms",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              const Text(
                "Nog vrij: ",
                style: TextStyle(
                  color: Color.fromRGBO(128, 128, 128, 1),
                  fontSize: 16,
                ),
              ),
              Image.asset("assets/icons/green-bed.png", width: 18, height: 18,),
              Text(
                "${houseProfile.availableRoom} kamers",
                style: const TextStyle(
                  color: Color.fromRGBO(34, 197, 94, 1),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Image.asset("assets/icons/coin.png", width: 18, height: 18,),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "\u{20AC}${houseProfile.pricePerRoom}",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  SliverChildListDelegate bodyInfo(HouseProfileModel houseProfileModel) {
    var houseProfile = houseProfileModel.houseOwner.houseSignupProfileModel;

    const List<Choice> choices = <Choice>[  
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

    return SliverChildListDelegate(
      <Widget> [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 90,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(child: SelectCard(choice: choices[0], borderRadius: const BorderRadius.only(topLeft: Radius.circular(15.0), bottomLeft: Radius.circular(15.0)))), 
                      Expanded(child: SelectCard(choice: choices[1], borderRadius: const BorderRadius.only())), 
                      Expanded(child: SelectCard(choice: choices[2], borderRadius: const BorderRadius.only(topRight: Radius.circular(15.0), bottomRight: Radius.circular(15.0)))), 
                    ],
                  ),
                ),
                const SizedBox(height: 15,),
                textTitle("Omschrijving"),
                textDescription(houseProfile.houseDescription),
                const SizedBox(height: 12,),
                textTitle("Kenmerken"),
                const SizedBox(height: 12,),
                textTitle("Activity"),
                const SizedBox(height: 12,),
                textTitle("Buurt"),
                const SizedBox(height: 12,),
                textTitle("Locatie"),
                const SizedBox(height: 12,),
              ],
            ),
          ),
        )
      ]
    );
  }

  Text textDescription(String description) {
    return Text(
      description,
      style: const TextStyle(
        color: Color.fromRGBO(128, 128, 128, 1),
        fontSize: 16,
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

class Choice {  
  const Choice({
    required this.title, 
    required this.icon
  });  

  final String title;  
  final ImageIcon icon;  
} 
  
class SelectCard extends StatelessWidget {  
  const SelectCard({
    Key? key, 
    required this.choice,
    required this.borderRadius,
  }) : super(key: key);  

  final Choice choice;  
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
    );
  }
}  