import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomies_app/widgets/gradients/gradient.dart';
import 'package:roomies_app/widgets/helper_functions.dart';
import 'package:swipable_stack/swipable_stack.dart';

import '../../backend/providers/user_profile_provider.dart';
import '../../models/user_profile_model.dart';

class LikeDislikeBar extends StatefulWidget {
  const LikeDislikeBar({
    Key? key,
    required this.swipeController,
    required this.userProfileModels,
    required this.currentUserIndex,
  }) : super(key: key);

  final SwipableStackController swipeController;
  final List<UserProfileModel>? userProfileModels;
  final int currentUserIndex;

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
                  gradient: CustomGradient().redGradient(),
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
                    final currentUserIndex = context.read<UserProfileProvider>().pagesSwiped;
                    showUserInfo(context, widget.userProfileModels![currentUserIndex], modalSheetHeight);
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

  void showUserInfo(BuildContext context, UserProfileModel userProfileModel, double modalSheetHeight) {
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
        return headerInfo(userProfileModel); 
      },
      bodyBuilder: (BuildContext context, double offset) {
        return bodyInfo(userProfileModel);
      },
    );
  }

  Widget headerInfo(UserProfileModel userProfileModel) {
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
                "${userProfileModel.userModel.firstName}, ${HelperWidget().calculateAge(userProfileModel.userModel.userSignupProfileModel.birthdate)}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
          ),
          Row(
            children: [
              Image.asset("assets/icons/Location.png", width: 20, height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "${userProfileModel.userModel.userSignupProfileModel.cityName}, ${userProfileModel.userModel.userSignupProfileModel.streetName}",
                  style: const TextStyle(
                    color: Color.fromRGBO(128, 128, 128, 1),
                    fontSize: 16,
                  ),
                ),
              ),
              const Spacer(),
              Image.asset("assets/icons/coin.png", width: 20, height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "\u{20AC}${userProfileModel.userModel.userSignupProfileModel.minBudget} - \u{20AC}${userProfileModel.userModel.userSignupProfileModel.maxBudget}",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Divider(
              color: Color.fromARGB(255, 163, 163, 163),
            ),
          ),
        ],
      ),
    );
  }

  SliverChildListDelegate bodyInfo(UserProfileModel userProfileModel) {
    return SliverChildListDelegate(
      <Widget> [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textTitle("About"),
                textDescription(userProfileModel.userModel.userSignupProfileModel.about),
                const SizedBox(height: 12,),
                textTitle("Work"),
                textDescription(userProfileModel.userModel.userSignupProfileModel.work),
                const SizedBox(height: 12,),
                textTitle("Study"),
                textDescription(userProfileModel.userModel.userSignupProfileModel.study),
                const SizedBox(height: 12,),
                textTitle("What I like to see in a roommate"),
                textDescription(userProfileModel.userModel.userSignupProfileModel.roommate),
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