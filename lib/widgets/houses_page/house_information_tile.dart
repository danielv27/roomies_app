import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:roomies_app/pages/houses_matched_page.dart';

import '../../models/house_profile_model.dart';

class HouseInformationTile extends StatelessWidget {
  const HouseInformationTile({
    Key? key,
    required this.house,
    required this.index,
    required this.infoButtonEnabled
  }) : super(key: key);

  final HouseProfileModel house;
  final int index;
  final bool infoButtonEnabled;

  @override
  Widget build(BuildContext context) {
    var houseProfile = house.houseOwner.houseSignupProfileModel;
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5, tileMode: TileMode.mirror),
              child: CachedNetworkImage(
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                imageUrl: house.imageURLS[0],
                fit: BoxFit.cover,
                filterQuality: FilterQuality.medium,
              ),
            ),
          ),
        ),
        if(infoButtonEnabled) Transform.translate(
          offset: const Offset(-13, 21),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 56,
              width: 56,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: FloatingActionButton(
                heroTag: 'tile$index',
                elevation: 0,
                onPressed: () async { 
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      child: UsersHousesMatched(house: house),
                      inheritTheme: true,
                      ctx: context,
                    ),
                  );
                },
                backgroundColor: const Color.fromRGBO(163, 178, 186, 0.5),
                child: const ImageIcon(AssetImage("assets/icons/Info.png"), color: Color.fromRGBO(116, 201, 176, 1), size: 25,),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 75),
          child: Column(
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
              Row(
                children: [
                  Text(
                    "${houseProfile.postalCode}, ${houseProfile.cityName}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              Text(
                "${houseProfile.livingSpace}m\u00B2, ${int.parse(houseProfile.numRoom) - int.parse(houseProfile.availableRoom)} People",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
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
        ),
      ],
    );
  }
}