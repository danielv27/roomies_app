import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomies_app/backend/current_profile_provider.dart';
import 'package:roomies_app/backend/database.dart';
import 'package:roomies_app/backend/user_profile_provider.dart';
import 'package:swipable_stack/swipable_stack.dart';
import '../../models/user_profile_model.dart';
import 'like_dislike_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SwipableCards extends StatefulWidget {
  final UserProfileProvider userProvider;
  late bool buttonInfoPressed;
  
  SwipableCards({
    Key? key,
    required this.userProvider,
    required this.buttonInfoPressed,
    }) : super(key: key);
    
  @override
  SwipableCardsState createState() => SwipableCardsState();
}

class SwipableCardsState extends State<SwipableCards> {
  late final SwipableStackController swipeController;
  late final initialIndex = widget.userProvider.pagesSwiped;
  late final buttonInfoPressed = widget.buttonInfoPressed;
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
    
    final String? currentUserID = context.read<CurrentUserProvider>().currentUser?.userModel.id;
    final List<UserProfileModel>? userProfileModels = widget.userProvider.userProfileModels;
    int currentUserIndex = widget.userProvider.pagesSwiped;

    if(userProfileModels != null && (currentUserIndex >= userProfileModels.length || userProfileModels.isEmpty)){
      return const Center(child:Text('No More Users To Swipe'));
    }
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
            print('userListLength = ${userProfileModels.length}');
            if(direction == SwipeDirection.right){
              print('liked ${userProfileModels[index].userModel.firstName} ${userProfileModels[index].userModel.lastName}');
              FireStoreDataBase().addEncounter(true, currentUserID!, userProfileModels[index].userModel.id);
            }
            if(direction == SwipeDirection.left){
              print('diskliked ${userProfileModels[index].userModel.firstName} ${userProfileModels[index].userModel.lastName}');
              FireStoreDataBase().addEncounter(false, currentUserID!, userProfileModels[index].userModel.id);
            }   
          },
          builder: (context, properties) {
            final currentUserIndex = properties.index + initialIndex; 
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
                      child: images[index],
                      onTapUp:(details) {
                        var deviceWidth = MediaQuery.of(context).size.width;
                        var xPos = details.globalPosition.dx;
                        
                        if(index < currenUserImages.length - 1 && xPos > deviceWidth * 0.65){
                            imgController.nextPage(duration: const Duration(milliseconds: 200),curve: Curves.easeInOut);
                            print("current image index: ${index + 1}");
                          
                        }

                        if(index >= 1 && xPos < deviceWidth * 0.35){
                            imgController.previousPage(duration: const Duration(milliseconds: 200),curve: Curves.easeInOut);
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
              ],
            );
          },
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: LikeDislikeBar(swipeController: swipeController, userProfileModels: userProfileModels, currentUserIndex: currentUserIndex),
        ),
      ]
    );
  }
}