import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:roomies_app/backend/providers/current_house_provider.dart';
import 'package:roomies_app/widgets/gradients/gradient.dart';

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
              decoration: BoxDecoration(
                color: const Color.fromRGBO(238, 238, 238, 1),
                borderRadius: BorderRadius.circular(14.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0, left: 20, top: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
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
                    const SizedBox(width: 15,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "${data['streetName']} ${data['houseNumber']}, ${data['cityName']}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 4,
                              softWrap: false,
                              style: const TextStyle(
                                height: 1.25,
                                color:Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "Matches",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                foreground: Paint()..shader = CustomGradient().blueGradient().createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0))
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios),
                  ],
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