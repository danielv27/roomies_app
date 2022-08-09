import 'package:flutter/material.dart';
import 'package:roomies_app/models/house_profile_model.dart';

class HeaderHouseInformation extends StatelessWidget {
  const HeaderHouseInformation({
    Key? key,
    required this.houseProfile,
  }) : super(key: key);

  final HouseSignupProfileModel houseProfile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 15),
      child: Column(
        children: [
          Center(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                color: Color.fromRGBO(238, 238, 238, 1),
              ),
              height: 5,
              width: 80,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15.0, top:  25.0),
              child: Text(
                "${houseProfile.streetName} ${houseProfile.houseNumber}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
          ),
          Row(
            children: [
              Text(
                "${houseProfile.postalCode}, ${houseProfile.cityName}",
                style: const TextStyle(
                  color: Color.fromRGBO(128, 128, 128, 1),
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Image.asset("assets/icons/apartment-size.png", width: 18, height: 18,),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  "${houseProfile.livingSpace}m\u00B2",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
              const Spacer(),
              Image.asset("assets/icons/number-rooms.png", width: 18, height: 18,),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  "${houseProfile.numRoom} Rooms",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              const Text(
                "Nog vrij: ",
                style: TextStyle(
                  color: Color.fromRGBO(128, 128, 128, 1),
                  fontSize: 16,
                ),
              ),
              Image.asset("assets/icons/green-bed.png", width: 18, height: 18,),
              Text(
                "${houseProfile.availableRoom} kamers",
                style: const TextStyle(
                  color: Color.fromRGBO(34, 197, 94, 1),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Image.asset("assets/icons/coin.png", width: 18, height: 18,),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "\u{20AC}${houseProfile.pricePerRoom}",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
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