import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomies_app/backend/providers/house_profile_provider.dart';
import 'package:roomies_app/models/house_profile_model.dart';
import 'package:roomies_app/widgets/gradients/gradient.dart';
import 'package:roomies_app/widgets/houses_page/house_info_button/header_house_info.dart';
import 'package:roomies_app/widgets/houses_page/house_info_button/house_description.dart';
import 'package:roomies_app/widgets/houses_page/house_info_button/house_features.dart';
import 'package:roomies_app/widgets/houses_page/house_info_button/house_media_tiles.dart';
import 'package:roomies_app/widgets/houses_page/house_info_button/house_activity_tiles.dart';
import 'package:roomies_app/widgets/houses_page/house_info_button/map_house_location.dart';
import 'package:roomies_app/widgets/houses_page/house_info_button/neighborhood_tile.dart';
import 'package:swipable_stack/swipable_stack.dart';

class LikeDislikeBar extends StatefulWidget {
  const LikeDislikeBar({
    Key? key,
    required this.swipeController,
    required this.houseProfileModels,
    required this.currentHouseIndex,
  }) : super(key: key);

  final SwipableStackController swipeController;
  final List<HouseProfileModel>? houseProfileModels;
  final int currentHouseIndex;

  @override
  State<LikeDislikeBar> createState() => _LikeDislikeBarState();
}

class _LikeDislikeBarState extends State<LikeDislikeBar> {
  bool buttonInfoPressed = false;

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
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
                    final currentUserIndex = context.read<HouseProfileProvider>().pagesSwiped;
                    showUserInfo(context, widget.houseProfileModels![currentUserIndex], modalSheetHeight);
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

  void showUserInfo(BuildContext context, HouseProfileModel houseProfileModel, double modalSheetHeight) {
    showStickyFlexibleBottomSheet(
      context: context,
      minHeight: 0,
      initHeight: 0.5,
      maxHeight: 0.95,
      headerHeight: 0,
      anchors: [0, 0.5, 0.95],
      bottomSheetColor: Colors.transparent,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0), 
          topRight: Radius.circular(25.0)
        ),
        shape: BoxShape.rectangle,
        color: Colors.white,
      ),
      headerBuilder: (BuildContext context, double bottomSheetOffset) {
        return headerInfo(); 
      },
      bodyBuilder: (BuildContext context, double offset) {
        return bodyInfo(houseProfileModel);
      },
    );
  }

  Widget headerInfo() {
    return Container();
  }

  SliverChildListDelegate bodyInfo(HouseProfileModel houseProfileModel) {
    var houseProfile = houseProfileModel.houseOwner.houseSignupProfileModel;
    return SliverChildListDelegate(
      <Widget> [
        Padding(
          padding: const EdgeInsets.only(left: 17, right: 17, bottom: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderHouseInformation(houseProfile: houseProfile),
              HouseMediaTiles(context: context),
              HouseDescription(houseProfile: houseProfile),
              HouseFeatures(context: context, houseProfile: houseProfile),
              HouseActivityTiles(context: context),
              const NeighborhoodTile(),
              MapHouseLocation(houseOwner: houseProfileModel.houseOwner),
            ],
          ),
        )
      ],
    );
  }
}