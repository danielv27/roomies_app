import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:swipable_stack/swipable_stack.dart';
import '../widgets/like_dislike_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

const userImageArray = [
  [
    'assets/images/profile_pic2.jpg',
    'assets/images/profile_pic3.jpg',
    'assets/images/profile_pic2.jpg',
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

class SwipableCards extends StatefulWidget {
  @override
  SwipableCardsState createState() => SwipableCardsState();
}

class SwipableCardsState extends State<SwipableCards> {
  late final SwipableStackController swipeController; // = SwipableStackController()..addListener(_listenController);

  

  void _listenController() => setState(() {});

  @override
  void initState() {
    super.initState();
    swipeController = SwipableStackController()..addListener(_listenController);
  }

  @override
  void dispose() {
    super.dispose();
    //imageController.dispose();
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
            final currentUserIndex = properties.index % userImageArray.length;
            final currenUserImages = userImageArray[currentUserIndex];
            final imgController = PageController(viewportFraction: 1.03,keepPage: true);
            final images = List.generate(
              currenUserImages.length,
              (index) =>  Image.asset(currenUserImages[index],fit: BoxFit.fill,)
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
                        print("tap on " + xPos.toString());
                        if(index < currenUserImages.length - 1 && xPos > deviceWidth * 0.65){
                            imgController.nextPage(duration: Duration(milliseconds: 200),curve: Curves.easeInOut);
                            print("current index: $index");
                          
                        }
                        if(index >= 1 && xPos < deviceWidth * 0.35){
                            imgController.previousPage(duration: Duration(milliseconds: 200),curve: Curves.easeInOut);
                            print("current index: $index");
                          
                        }
                        
                      },                        
                    ); // return Image.asset(_images[index],fit: BoxFit.fitHeight);
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
                      
                      count: userImageArray[currentUserIndex].length,
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