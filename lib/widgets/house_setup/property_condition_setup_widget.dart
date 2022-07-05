import 'package:flutter/material.dart';

import '../circle_ring.dart';

class PropertyConditionSetupPage extends StatefulWidget {
  PropertyConditionSetupPage({
    Key? key, 
    required this.propertyConditionChosen,
  }) : super(key: key);

  late String propertyConditionChosen;

  @override
  State<PropertyConditionSetupPage> createState() => _PropertyConditionSetupPageState();
}

class _PropertyConditionSetupPageState extends State<PropertyConditionSetupPage> {
  final List houseConditionList = [
    "Poor Condition\n",
    "Good Condition\n",
    "Perfect Condition\n",
  ];

  final List houseConditionDescriptionList = [
    "The house needs major maintenance in the short term",
    "Well maintained but the house is not in new condition",
    "The property is in perfect condition, just like new",
  ];

  String propertyConditionChosen = "";

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
              "What is the condition?",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: [
              houseCondition(context, houseConditionList[0], houseConditionDescriptionList[0]),
              houseCondition(context, houseConditionList[1], houseConditionDescriptionList[1]),
              houseCondition(context, houseConditionList[2], houseConditionDescriptionList[2]),
            ],
          ),
        ],
      ),
    );
  }

  GestureDetector houseCondition(BuildContext context, String houseConditionAtIndex, String houseDescriptionAtIndex) {
    return GestureDetector(
      onTap: () {
        print("Tapped $houseConditionAtIndex");
        setState(() {
          widget.propertyConditionChosen = houseConditionAtIndex;
          print(widget.propertyConditionChosen.toString());
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14.0),
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.15,
        decoration: BoxDecoration(
          color: (widget.propertyConditionChosen != houseConditionAtIndex)
              ? const Color.fromRGBO(245, 247, 251, 1)
              : const Color.fromRGBO(176, 203, 255, 1),
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 20, right: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                (widget.propertyConditionChosen != houseConditionAtIndex)
                    ? "assets/icons/Ring-circle.png"
                    : "assets/icons/Ring-circle-selected.png",
                height: 20,
                width: 20,
              ),
              // CustomPaint( // should we draw the create a custom-made blue ring or just use icons ?
              //   size: const Size(20, 20),
              //   painter: CirclePainter(),
              // ),
              const SizedBox(
                width: 14,
              ),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4), // need the SizedBox to align its height with the blue circle icon
                    Text(
                      houseConditionAtIndex,
                      style: TextStyle(
                        color: (widget.propertyConditionChosen != houseConditionAtIndex)
                            ? const Color.fromRGBO(101, 101, 107, 1)
                            : Colors.white,
                        fontSize: 14,
                        fontWeight: (widget.propertyConditionChosen != houseConditionAtIndex)
                            ? FontWeight.w300
                            : FontWeight.w500,
                      ),
                    ),
                    Text(
                      houseDescriptionAtIndex,
                      style: TextStyle(
                        color: (widget.propertyConditionChosen != houseConditionAtIndex)
                            ? const Color.fromRGBO(101, 101, 107, 1)
                            : Colors.white,
                        fontSize: 14,
                        fontWeight: (widget.propertyConditionChosen != houseConditionAtIndex)
                            ? FontWeight.w300
                            : FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
              const Spacer(),
              Image.asset(
                (widget.propertyConditionChosen != houseConditionAtIndex)
                    ? "assets/icons/Grey-house.png"
                    : "assets/icons/Grey-house-selected.png",
                height: 20,
                width: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
