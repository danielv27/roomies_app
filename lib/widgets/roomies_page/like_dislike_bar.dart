import 'package:flutter/material.dart';
import 'package:roomies_app/widgets/gradients/gradient.dart';
import 'package:swipable_stack/swipable_stack.dart';

import '../../models/user_profile_model.dart';

Widget likeDislikeBar(BuildContext context, SwipableStackController controller, UserProfileModel userProfileModels) {
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
                    print("Dislike button pressed");
                    controller.next(swipeDirection: SwipeDirection.left);
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
                      print("Like Button pressed");
                      controller.next(swipeDirection: SwipeDirection.right);
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
                    print("Info button pressed");
                    showUserInfo(context, userProfileModels);
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

  void showUserInfo(BuildContext context, UserProfileModel userProfileModel) {
    showModalBottomSheet<void>(
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0), 
          topRight: Radius.circular(30.0)
        ),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15.0, top:  25.0),
                    child: Text(
                      "${userProfileModel.userModel.firstName}, 22",
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
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Amsterdam, De Pijp",
                        style: TextStyle(
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
                  padding: EdgeInsets.only(bottom: 15.0, top: 15.0),
                  child: Divider(
                    color: Color.fromARGB(255, 163, 163, 163),
                  ),
                ),
                Column(
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
              ],
            ),
          ),
        );
      },
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