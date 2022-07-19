import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomies_app/backend/database.dart';
import 'package:roomies_app/backend/user_profile_provider.dart';
import 'package:swipable_stack/swipable_stack.dart';
import '../../models/user_profile_model.dart';
import 'like_dislike_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SwipableCards extends StatefulWidget {
  final UserProfileProvider userProvider;
  
  const SwipableCards({
    Key? key,
    required this.userProvider
    }) : super(key: key);
    
  @override
  SwipableCardsState createState() => SwipableCardsState();
}

class SwipableCardsState extends State<SwipableCards> {
  late final SwipableStackController swipeController;
  late final initialIndex = widget.userProvider.pagesSwiped;
  late final Future<List<UserProfileModel>?> futureListUserProfileModel = FireStoreDataBase().getUsersImages(3);

  bool loading = true;

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

  void load() async {
    //doesnt really work at the moment
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      loading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    final List<UserProfileModel>? userProfileModels = widget.userProvider.userProfileModels;
    //load();
    return userProfileModels == null ?
    const Center(child: CircularProgressIndicator()):
    Stack(
      children: [
            SwipableStack(
              itemCount: userProfileModels.length,
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
                Provider.of<UserProfileProvider>(context,listen: false).incrementIndex();
                print("swipped user: $index,\ndirection: $direction\n");
                
              },
              builder: (context, properties) {
                final int currentUserIndex = properties.index + initialIndex; 
                final currenUserImages = userProfileModels[currentUserIndex].imageURLS;
                final imgController = PageController();

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
                          
                          count: userProfileModels[currentUserIndex].imageURLS.length,
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
                          userProfileModels[currentUserIndex].userModel.firstName + ' $currentUserIndex', 
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32
                          )
                        ),
                      )
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: likeDislikeBar(context, swipeController, userProfileModels[currentUserIndex]),
                    ),
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
            ),
      ]
    );
  }
}