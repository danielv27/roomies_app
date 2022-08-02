
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roomies_app/backend/houses_api.dart';
import 'package:roomies_app/backend/providers/house_profile_provider.dart';
import 'package:roomies_app/models/house_profile_model.dart';

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
            return Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      houses![index].imageURLS[0], 
                      fit: BoxFit.cover,
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
                        color:Color.fromRGBO(163, 178, 186, 0.5),
                      ),
                      child: FloatingActionButton(
                        heroTag: "btn1_$index",
                        elevation: 0,
                        onPressed: () async { 
                
                        },
                        backgroundColor: Colors.transparent,
                        child: const ImageIcon(AssetImage("assets/icons/Info.png"), color: Color.fromRGBO(116, 201, 176, 1), size: 25,),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  bottom: 30,
                  child: SizedBox(
                    height: 56,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Text(
                          "Ceintuurbaan ${houses![index].houseOwner.houseSignupProfileModel.houseNumber}",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
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