import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:roomies_app/backend/providers/current_profile_provider.dart';
import 'package:roomies_app/backend/providers/user_profile_provider.dart';
import 'package:roomies_app/backend/users_api.dart';
import 'package:roomies_app/widgets/helper_functions.dart';
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
    const Center(child: CircularProgressIndicator(color: Colors.red)):
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
          onSwipeCompleted: (index, direction) async {
            print('userListLength = ${userProfileModels.length}');
            if(direction == SwipeDirection.right){
              print('liked ${userProfileModels[index].userModel.firstName} ${userProfileModels[index].userModel.lastName}');
              await UsersAPI().addEncounter(true, currentUserID!, userProfileModels[index].userModel.id);
            }
            if(direction == SwipeDirection.left){
              print('diskliked ${userProfileModels[index].userModel.firstName} ${userProfileModels[index].userModel.lastName}');
              await UsersAPI().addEncounter(false, currentUserID!, userProfileModels[index].userModel.id);
            }
            await Provider.of<UserProfileProvider>(context,listen: false).incrementIndex();
          },
          builder: (context, properties) {
            final currentUserIndex = properties.index + initialIndex;
            
            if(currentUserIndex >= userProfileModels.length){
              return Container();
            }

            final currenUserImages = userProfileModels[currentUserIndex].imageURLS;
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
                      'swipableCardUserImages',
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
                UserInformation(userProfileModels: userProfileModels, currentUserIndex: currentUserIndex),
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

class UserInformation extends StatelessWidget {
  const UserInformation({
    Key? key,
    required this.userProfileModels,
    required this.currentUserIndex,
  }) : super(key: key);

  final List<UserProfileModel>? userProfileModels;
  final int currentUserIndex;

  @override
  Widget build(BuildContext context) {
    final userProfile = userProfileModels![currentUserIndex].userModel.userSignupProfileModel;
    final user = userProfileModels![currentUserIndex].userModel;

    return Padding(
      padding: const EdgeInsets.only(left: 25, bottom: 125.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${user.firstName}, ${HelperWidget().calculateAge(userProfile.birthdate)}', 
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w700
            )
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              Image.asset("assets/icons/Location.png", width: 18, height: 18,),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  user.location,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15,),
          Row(
            children: [
              Image.asset("assets/icons/coin.png", width: 18, height: 18,),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "\u{20AC}${userProfile.minBudget} - \u{20AC}${userProfile.maxBudget}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}