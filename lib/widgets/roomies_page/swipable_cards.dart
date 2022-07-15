import 'package:flutter/material.dart';
import 'package:roomies_app/backend/database.dart';
import 'package:swipable_stack/swipable_stack.dart';
import '../../models/user_profile_model.dart';
import 'like_dislike_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SwipableCards extends StatefulWidget {
  
  const SwipableCards({Key? key, }) : super(key: key);

  
  @override
  SwipableCardsState createState() => SwipableCardsState();
}

class SwipableCardsState extends State<SwipableCards> {
  late final SwipableStackController swipeController; // = SwipableStackController()..addListener(_listenController);
  Future<List<UserProfileModel>?> futureListUserProfileModel = FireStoreDataBase().getUsersImages();



  @override
  void initState() {
    super.initState();
    swipeController = SwipableStackController();
  }

  @override
  void dispose() {
    super.dispose();
    swipeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder(
          future: futureListUserProfileModel,
          builder: (context, snapshot) {
            var userProfileModelList = snapshot.data as List<UserProfileModel>?;
            if (snapshot.hasData) {
              return SwipableStack(
                itemCount: userProfileModelList!.length,
                onWillMoveNext: (index, direction) {
                  final allowedActions = [
                    SwipeDirection.right,
                    SwipeDirection.left,
                  ];
                  return allowedActions.contains(direction);
                },
                controller: swipeController,
                onSwipeCompleted: (index, direction) {
                  //this is where a swipe is handled
                  print("swipped user: $index,\ndirection: $direction\n");
                },
                builder: (context, properties) {
                  final currentUserIndex = properties.index % userProfileModelList.length;
                  final currenUserImages = userProfileModelList[currentUserIndex].imageURLS;
                  final imgController = PageController(viewportFraction: 1.03,keepPage: true);

                  final images = List.generate(
                    currenUserImages.length,
                    (index) =>  Image.network(currenUserImages[index],fit: BoxFit.fill,)
                  );

                  return Stack(
                    children: [
                      PageView.builder(
                        allowImplicitScrolling: true,
                        itemCount: currenUserImages.length,
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        controller: imgController,
                        itemBuilder: (context, index){
                          return GestureDetector(
                            child: images[index],//Image.asset(currenUserImages[index],width: MediaQuery.of(context).size.width),
                            onTapUp:(details) {
                              var deviceWidth = MediaQuery.of(context).size.width;
                              var xPos = details.globalPosition.dx;
                              
                              if(index < currenUserImages.length - 1 && xPos > deviceWidth * 0.65){
                                  imgController.nextPage(duration: const Duration(milliseconds: 200),curve: Curves.easeInOut);
                                  print("current image index: ${index + 1}");
                                
                              }

                              if(index >= 1 && xPos < deviceWidth * 0.35){
                                  imgController.previousPage(duration: Duration(milliseconds: 200),curve: Curves.easeInOut);
                                  print("current image index: ${index - 1}");
                              }
                              
                            },                        
                          ); 
                        },
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 11.0),
                          child: SmoothPageIndicator(
                            controller: imgController,
                            onDotClicked: ((index) {
                              imgController.jumpToPage(index);
                            }),
                            
                            count: userProfileModelList[currentUserIndex].imageURLS.length,
                            effect: const ScrollingDotsEffect(
                              dotHeight: 3,
                              dotWidth: 72,
                              spacing: 4.5,
                              activeDotColor: Colors.white,
                              activeDotScale: 1
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 120),
                          child: Text(
                            userProfileModelList[currentUserIndex].userModel.firstName, 
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32
                            )
                          ),
                        )
                      )
                    ],
                  );
                },
                // will be used for adding a label to the swipable cards later on          
                // overlayBuilder: (context, properties) {
                //   //final opacity = min(properties.swipeProgress, 1.0);
                //   final isRight = properties.direction == SwipeDirection.right;
                //   return Opacity(
                //     opacity: isRight ? 1 : 0,
                //     child: Text("OLAOLAOAOALAOO"),
                //   );
                // },
                //add this line to remove the ability to move the image around
                //allowVerticalSwipe: false,
              );
            } if (snapshot.hasError) {
              return const Text(
                "Something went wrong",
              );
            } else {
              return const Center(child: CircularProgressIndicator()); 
            }
          }
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: likeDislikeBar(context, swipeController),
        ),
      ]
    );
  }
}