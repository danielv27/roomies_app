import 'package:flutter/material.dart';
import 'package:roomies_app/models/user_model.dart';

class NeighborhoodTile extends StatelessWidget {
  const NeighborhoodTile({
    Key? key,
    required this.houseOwner,
    house
  }) : super(key: key);

  final HouseOwner houseOwner;

  @override
  Widget build(BuildContext context) {
    final houseProfile =  houseOwner.houseSignupProfileModel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textTitle("Neighborhood"),
        const SizedBox(height: 12,),
        Container(
          margin: const EdgeInsets.only(bottom: 15.0),
          child: Container(
            margin: const EdgeInsets.only(bottom: 15.0),
            height: 100,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(238, 238, 238, 1),
              borderRadius: BorderRadius.circular(14.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.0),
                      color: Colors.white,
                    ),
                    child: Image.asset("assets/icons/Location.png",
                      height: 15,
                      width: 15,
                    ),
                  ),
                  const SizedBox(width: 14,),
                  Expanded(
                    child: Text(
                      "${houseProfile.streetName} ${houseProfile.houseNumber}, ${houseProfile.cityName}",
                      style: const TextStyle(
                        color:Colors.black,
                        height: 1.5,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 3,
                    ),
                  ),
                  const SizedBox(width: 10,),
                  const Icon(Icons.arrow_forward_ios)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Text textTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold, 
        fontSize: 20,
      ),
    );
  }
}