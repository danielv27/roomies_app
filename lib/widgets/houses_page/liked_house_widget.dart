
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:page_transition/page_transition.dart';
import 'package:roomies_app/backend/houses_api.dart';
import 'package:roomies_app/backend/providers/house_profile_provider.dart';
import 'package:roomies_app/models/house_profile_model.dart';
import 'package:roomies_app/widgets/houses_page/users_houses_matched_page.dart';

class HousesLiked extends StatefulWidget {
  const HousesLiked({
    Key? key,
    required this.houseProvider,
    required this.user,
  }) : super(key: key);

  final HouseProfileProvider houseProvider;
  final User user;

  @override
  State<HousesLiked> createState() => _HousesLikedState();
}

class _HousesLikedState extends State<HousesLiked> {
  List<HouseProfileModel>? houses;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: HousesAPI().getLikedHouses(widget.user.uid),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.red));
        }
        houses = snapshot.data as List<HouseProfileModel>;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(), 
          itemCount: houses!.length,
          itemBuilder: (BuildContext context, int index) {
            var house = houses![index];
            var houseProfile = houses![index].houseOwner.houseSignupProfileModel;
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
                        key: UniqueKey(),
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                        imageUrl: houses![index].imageURLS[0],
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.medium,
                        cacheManager: CacheManager(
                          Config(
                            "likedHouse",
                            stalePeriod: const Duration(days: 2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Transform.translate(
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
                        heroTag: "btn1_$index",
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
                        "Ceintuurbaan ${houseProfile.houseNumber}",
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
                            "${houseProfile.postalCode}, Amsterdam",
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
          },
        );
      },
    );
  }
}