import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomies_app/backend/houses_api.dart';
import 'package:roomies_app/backend/providers/current_profile_provider.dart';
import 'package:roomies_app/backend/providers/house_profile_provider.dart';
import 'package:roomies_app/models/house_profile_model.dart';
import 'package:roomies_app/widgets/houses_page/like_dislike_bar.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SwipableCards extends StatefulWidget {
  final HouseProfileProvider houseProvider;
  late bool buttonInfoPressed;
  
  SwipableCards({
    Key? key,
    required this.houseProvider,
    required this.buttonInfoPressed,
    }) : super(key: key);
    
  @override
  SwipableCardsState createState() => SwipableCardsState();
}

class SwipableCardsState extends State<SwipableCards> {
  late final SwipableStackController swipeController;
  late final initialIndex = widget.houseProvider.pagesSwiped;
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
    final List<HouseProfileModel>? houseProfileModels = widget.houseProvider.houseProfileModels;
    int currentHouseIndex = widget.houseProvider.pagesSwiped;

    if(houseProfileModels != null && (currentHouseIndex >= houseProfileModels.length || houseProfileModels.isEmpty)){
      return const Center(child:Text('No More Users To Swipe'));
    }
    return houseProfileModels == null ?
    const Center(child: CircularProgressIndicator(color: Colors.red)):
    Stack(
      children: [
        SwipableStack(
          itemCount: houseProfileModels.length,
          onWillMoveNext: (index, direction) {
            final allowedActions = [
              SwipeDirection.right,
              SwipeDirection.left,
            ];
            return allowedActions.contains(direction);
          },
          controller: swipeController,
          onSwipeCompleted: (index, direction) async {
            //this is where a swipe is handled
            print('houseListLength = ${houseProfileModels.length}');
            if(direction == SwipeDirection.right){
              print('liked ${houseProfileModels[index].houseOwner.firstName} ${houseProfileModels[index].houseOwner.lastName}');
              await HousesAPI().addHouseEncounter(true, currentUserID!, houseProfileModels[index].houseRef);
              await HousesAPI().addUserEncounter(houseProfileModels[index].houseOwner.id, houseProfileModels[index].houseRef, currentUserID);
            }
            if(direction == SwipeDirection.left){
              print('diskliked ${houseProfileModels[index].houseOwner.firstName} ${houseProfileModels[index].houseOwner.lastName}');
              print(houseProfileModels[index].houseRef);
              await HousesAPI().addHouseEncounter(false, currentUserID!, houseProfileModels[index].houseRef);
            }
            if (!mounted) return;
            await Provider.of<HouseProfileProvider>(context,listen: false).incrementIndex();
          },
          builder: (context, properties) {
            final currentHouseIndex = properties.index + initialIndex;
            
            if(currentHouseIndex >= houseProfileModels.length){
              return Container();
            }

            final currenUserImages = houseProfileModels[currentHouseIndex].imageURLS;
            final imgController = PageController();

            final images = List.generate(
              currenUserImages.length,
              (index) {
                return Image.network(
                  currenUserImages[index],
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                      ),
                    );
                  },
                );
              }
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
                      
                      count: houseProfileModels[currentHouseIndex].imageURLS.length,
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
                      '${houseProfileModels[currentHouseIndex].houseOwner.houseSignupProfileModel.houseNumber} $currentHouseIndex', 
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
          child: LikeDislikeBar(swipeController: swipeController, houseProfileModels: houseProfileModels, currentHouseIndex: currentHouseIndex),
        ),
      ]
    );
  }
}