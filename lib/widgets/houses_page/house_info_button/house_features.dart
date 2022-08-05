import 'package:flutter/material.dart';
import 'package:roomies_app/models/house_profile_model.dart';

class HouseFeatures extends StatelessWidget {
  const HouseFeatures({
    Key? key,
    required this.context,
    required this.houseProfile,
  }) : super(key: key);

  final BuildContext context;
  final HouseSignupProfileModel houseProfile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textTitle("Features"),
          const Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Text("Overview", style: TextStyle(color: Colors.grey, fontSize: 16),),
          ),
          Card(  
            elevation: 0,
            margin: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
              side: BorderSide(
                color: Color.fromRGBO(238, 238, 238, 1),
              ),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Text("Rent price", style: TextStyle(color: Colors.grey, fontSize: 14),),
                  ),
                  Text("\u{20AC}${houseProfile.pricePerRoom} - per maand (geen service kosten)", style: const TextStyle(fontSize: 14),),
                  const SizedBox(height: 15,),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Text("Deposit", style: TextStyle(color: Colors.grey, fontSize: 14),),
                  ),
                  Text("\u{20AC}${(houseProfile.pricePerRoom)} oneoff", style: const TextStyle(fontSize: 14),),
                  const Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15),
                    child: Divider(
                      thickness: 0.75,
                      color: Color.fromARGB(255, 163, 163, 163),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                    child: Text("Rental Agreement", style: TextStyle(color: Colors.grey, fontSize: 14),),
                  ),
                  const Text("Temporary rental", style: TextStyle(fontSize: 14),),
                ],
              ),
            ),
          ),
        ],
      ),
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