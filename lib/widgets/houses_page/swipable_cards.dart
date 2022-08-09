import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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
            print('houseListLength = ${houseProfileModels.length}');
            if(direction == SwipeDirection.right){
              print('liked ${houseProfileModels[index].houseOwner.firstName} ${houseProfileModels[index].houseOwner.lastName}');
              await HousesAPI().addHouseEncounter(true, currentUserID!, houseProfileModels[index].houseRef);
              await HousesAPI().addUserEncounter(houseProfileModels[index].houseOwner.id, houseProfileModels[index].houseRef, currentUserID);
            }
            if(direction == SwipeDirection.left){
              print('diskliked ${houseProfileModels[index].houseOwner.firstName} ${houseProfileModels[index].houseOwner.lastName}');
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
                return CachedNetworkImage(
                  key: UniqueKey(),
                  imageUrl: currenUserImages[index],
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.medium,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  cacheManager: CacheManager(
                    Config(
                      'swipableCardHouseImages',
                      stalePeriod: const Duration(days : 1),
                      maxNrOfCacheObjects: 50,
                    )
                  ),
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
                HouseInformation(houseProfileModels: houseProfileModels, currentHouseIndex: currentHouseIndex),
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

class HouseInformation extends StatelessWidget {
  const HouseInformation({
    Key? key,
    required this.houseProfileModels,
    required this.currentHouseIndex,
  }) : super(key: key);

  final List<HouseProfileModel>? houseProfileModels;
  final int currentHouseIndex;

  @override
  Widget build(BuildContext context) {
    final houseProfile = houseProfileModels![currentHouseIndex].houseOwner.houseSignupProfileModel;
    final occupiedRoomes = int.parse(houseProfile.numRoom) - int.parse(houseProfile.availableRoom);

    return Padding(
      padding: const EdgeInsets.only(left: 25, bottom: 125.0, right: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          Text(
            "${houseProfile.streetName} ${houseProfile.houseNumber}",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5,),
          Text(
            "${houseProfile.postalCode}, ${houseProfile.cityName}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 30,),
          Row(
            children: [
              Text(
                "${houseProfile.livingSpace}m\u00B2, $occupiedRoomes People",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              Image.asset("assets/icons/coin.png", width: 18, height: 18,),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "\u{20AC}${houseProfile.pricePerRoom}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700
                  ),
                ),
              ),
            ],
          ),
          Text(
            "Nog vrij: ${houseProfile.availableRoom}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}