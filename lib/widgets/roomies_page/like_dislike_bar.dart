import 'package:flutter/material.dart';
import 'package:roomies_app/widgets/gradients/gradient.dart';
import 'package:swipable_stack/swipable_stack.dart';

import '../../models/user_profile_model.dart';

class LikeDislikeBar extends StatefulWidget {
  LikeDislikeBar({
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

class _LikeDislikeBarState extends State<LikeDislikeBar> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  bool buttonInfoPressed = false;

  @override
  initState() {
    super.initState();
    animationController = BottomSheet.createAnimationController(this);
    animationController.duration = const Duration(milliseconds: 500);
  }

  @override
  void dispose() {
    animationController.dispose();
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
                    print("Dislike button pressed");
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
                      print("Like Button pressed");
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
                    showUserInfo(context, widget.userProfileModels![widget.currentUserIndex], modalSheetHeight);
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
    showModalBottomSheet(
      transitionAnimationController: animationController,
      barrierColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0), 
          topRight: Radius.circular(30.0)
        ),
      ),
      builder: (BuildContext context) {
        return makeDissmissable(
          child: DraggableScrollableSheet(
            initialChildSize: modalSheetHeight,
            minChildSize: modalSheetHeight,
            maxChildSize: 1,
            builder: (_, ScrollController scrollController) {
              return Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0), 
                        topRight: Radius.circular(30.0)
                      ),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(15),
                    child: ListView(
                      controller: scrollController,
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
                  Transform.translate(
                    offset: const Offset(-25, -25),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: redGradient(),
                        ),
                        child: FloatingActionButton(
                          elevation: 0,
                          onPressed: () { 
                              buttonInfoPressed = !buttonInfoPressed;
                              showUserInfo(context, userProfileModel, modalSheetHeight * 1.5);
                              // scrollController.jumpTo(100);
                              //animationController.animateTo(0.5, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                            //scrollController.jumpTo(0.5);
                          },
                          backgroundColor: Colors.transparent,
                          child: const Icon(Icons.arrow_upward_outlined),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
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
  
  Widget makeDissmissable({required DraggableScrollableSheet child}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).pop();
      },
      child: GestureDetector(onTap: () {}, child: child,),
    );
  }

}