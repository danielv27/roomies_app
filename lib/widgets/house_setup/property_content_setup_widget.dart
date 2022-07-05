import 'package:flutter/material.dart';

import '../circle_ring.dart';

class PropertyContentSetupPage extends StatefulWidget {
  PropertyContentSetupPage({
    Key? key, 
  }) : super(key: key);

  @override
  State<PropertyContentSetupPage> createState() => _PropertyContentSetupPageState();
}

class _PropertyContentSetupPageState extends State<PropertyContentSetupPage> {
  final List uploadIcon = [
    Image.asset("assets/icons/upload-house-images.png", width: 42, height: 42.77),
    Image.asset("assets/icons/upload-building-map.png", width: 43.2, height: 37.8),
  ];

  final List uploadDescriptionFields = [
    "Pictures",
    "Building map",
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 30.0, right: 30, top: 5),
            alignment: Alignment.centerLeft,
            child: const Text(
              "Cannenburgh 1, 1018 LG Amsterdam", // TODO: take information from the controllers and display it here
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 30.0, right: 30, top: 5),
            alignment: Alignment.centerLeft,
            child: const Text(
              "Content for the house",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: [
              houseCondition(context, uploadDescriptionFields[0], uploadIcon[0]),
              houseCondition(context, uploadDescriptionFields[1], uploadIcon[1]),
            ],
          ),
        ],
      ),
    );
  }

  GestureDetector houseCondition(BuildContext context, String descriptionField, var uploadIcon) {
    return GestureDetector(
      onTap: () {
        setState(() {

        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14.0),
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(245, 247, 251, 1),
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 30, top: 30, bottom: 30, right: 30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Upload",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w300
                      ),
                    ),
                    const SizedBox(height: 6,),
                    Text(
                      descriptionField,
                      style: const TextStyle(
                        color: Color.fromRGBO(51, 51, 51, 1),
                        fontSize: 23,
                        fontWeight: FontWeight.w600
                      ),
                    )
                  ],
                ),
              ),
              const Spacer(),
              uploadIcon,
            ],
          ),
        ),
      ),
    );
  }
}
