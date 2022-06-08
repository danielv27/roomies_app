import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:swipable_stack/swipable_stack.dart';
import '../widgets/like_dislike_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

const userImageArray = [
  [
    'assets/images/profile_pic2.jpg',
    'assets/images/profile_pic3.jpg',
    'assets/images/profile_pic4.jpg',
    'assets/images/profile_pic5.jpg',
  ],
  [
    'assets/images/profile_pic3.jpg',
    'assets/images/profile_pic2.jpg',
    'assets/images/profile_pic4.jpg',
    'assets/images/profile_pic5.jpg',
  ],
  [
    'assets/images/profile_pic4.jpg',
    'assets/images/profile_pic5.jpg',
  ],
  [
    'assets/images/profile_pic5.jpg',
  ]
];

const _images = [
  'assets/images/profile_pic2.jpg',
  'assets/images/profile_pic3.jpg',
  'assets/images/profile_pic4.jpg',
  'assets/images/profile_pic5.jpg',
];

class SwipableCards extends StatefulWidget {
  @override
  SwipableCardsState createState() => SwipableCardsState();
}

class SwipableCardsState extends State<SwipableCards> {
  late final SwipableStackController swipeController; // = SwipableStackController()..addListener(_listenController);
  late final imageController = PageController(viewportFraction: 1,keepPage: true);
  

  void _listenController() => setState(() {});

  @override
  void initState() {
    super.initState();
    swipeController = SwipableStackController()..addListener(_listenController);
  }

  @override
  void dispose() {
    super.dispose();
    
    swipeController
      ..removeListener(_listenController)
      ..dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:
      [
        SwipableStack(
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
            print("current index: $index,\ndirection: $direction\n");
          },
          builder: (context, properties) {
            final currentUserIndex = properties.index % _images.length;
            return Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.72,
                  //child: Image.asset(_images[currentUserIndex],fit: BoxFit.fitHeight),
                  child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: imageController,
                    itemBuilder: (context, index){
                      return GestureDetector(
                        child: Image.asset(userImageArray[currentUserIndex][index],fit: BoxFit.fitHeight),
                        onTapDown:(TapDownDetails details) {
                          var deviceWidth = MediaQuery.of(context).size.width;
                          var xPos = details.globalPosition.dx;
                          print(MediaQuery.of(context).size.width);
                          print("tap on " + xPos.toString());
                          if(xPos > deviceWidth * 0.65){
                            imageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                            //index++;
                            print(index);

                          }
                        },                        
                      ); // return Image.asset(_images[index],fit: BoxFit.fitHeight);
                    },
                  ),
                ),
                Align(
                alignment: Alignment.topCenter,
                child: SmoothPageIndicator(
                controller: imageController,
                count: userImageArray[currentUserIndex].length,
                effect: const ScrollingDotsEffect(
                  dotHeight: 12,
                  dotWidth: 30,
                  
                  activeDotColor: Colors.white,
                  activeDotScale: 1.1
                ),
              ),
                ),

                const Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 120),
                    child: Text(
                      "Daniel Volpin", 
                      style: TextStyle(
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

        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: likeDislikeBar(context, swipeController),
          
        ),
      ]
    );
  }
}