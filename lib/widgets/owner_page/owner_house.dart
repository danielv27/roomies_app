import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:roomies_app/backend/current_house_provider.dart';

import '../gradients/blue_gradient.dart';

class ListedOwnerHouse extends StatefulWidget {
  const ListedOwnerHouse({
    Key? key,
    required this.houseProvider,
  }) : super(key: key);

  final CurrentHouseProvider houseProvider;

  @override
  State<ListedOwnerHouse> createState() => _OwnerHouseState();
}

class _OwnerHouseState extends State<ListedOwnerHouse> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.houseProvider.houses,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return Container(
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
                        height: 68,
                        width: 68,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14.0),
                          color: Colors.white,
                        ),
                        child: Image.asset("assets/icons/Grey-house-selected.png",
                          height: 20,
                          width: 20,
                        ),
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "${data['postalCode']}, ${data['houseNumber']}\n",
                              style: const TextStyle(
                                height: 2.0,
                                color:Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: "Matches", // TODO: Add number of matched houses
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                foreground: Paint()..shader = blueGradient().createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0))
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
              ),
            );
          })
          .toList()
          .cast(),
        );
      },
    );

  }
}