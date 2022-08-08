import 'package:flutter/material.dart';
import 'package:roomies_app/widgets/gradients/gradient.dart';

class PropertyTypeSetupPage extends StatefulWidget {
  PropertyTypeSetupPage({
    Key? key,
    required this.pageController,
    required this.propertyTypeController,
  }) : super(key: key);

  String? propertyTypeChosen;

  final TextEditingController propertyTypeController;
  final PageController pageController;

  @override
  State<PropertyTypeSetupPage> createState() => _PropertyTypeSetupPageState();
}

class _PropertyTypeSetupPageState extends State<PropertyTypeSetupPage> {
  final List propertyTypeList = [
    "Apartment",
    "Studio",
    "Studentencomplex",
    "Tussenwoning",
    "Hoekwoning",
    "2-onder-1-kapwoning",
    "Geschakelde woning"
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: SingleChildScrollView(
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
                  "What type of property?",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  propertyType(context, propertyTypeList[0]),
                  propertyType(context, propertyTypeList[1]),
                  propertyType(context, propertyTypeList[2]),
                  propertyType(context, propertyTypeList[3]),
                  propertyType(context, propertyTypeList[4]),
                  propertyType(context, propertyTypeList[5]),
                  propertyType(context, propertyTypeList[6]),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomSheet: bottomSheet(context),
    );
  }

  SizedBox bottomSheet(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: CustomGradient().blueGradient(),
            ),
            height: 50,
            width: MediaQuery.of(context).size.width * 0.75,
            margin: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                primary: Colors.transparent,
                shadowColor: Colors.transparent,
                onSurface: Colors.transparent,
              ),
              onPressed: () { 
                if (widget.propertyTypeController.text.isNotEmpty) {
                  widget.pageController.nextPage(
                    duration: const Duration(milliseconds: 500), 
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: const Text(
                "Next",
                style: TextStyle(fontSize: 20, color:Colors.white)
              ),
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector propertyType(BuildContext context, String proprtyTypeAtIndex) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.propertyTypeController.text = proprtyTypeAtIndex;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14.0),
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.1,
        decoration: BoxDecoration(
          color: (widget.propertyTypeController.text != proprtyTypeAtIndex)
              ? const Color.fromRGBO(245, 247, 251, 1)
              : const Color.fromRGBO(176, 203, 255, 1),
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Image.asset(
                (widget.propertyTypeController.text != proprtyTypeAtIndex)
                    ? "assets/icons/Ring-circle.png"
                    : "assets/icons/Ring-circle-selected.png",
                height: 20,
                width: 20,
              ),
              const SizedBox(
                width: 14,
              ),
              Text(
                proprtyTypeAtIndex,
                style: TextStyle(
                  color: (widget.propertyTypeController.text != proprtyTypeAtIndex)
                      ? const Color.fromRGBO(101, 101, 107, 1)
                      : Colors.white,
                  fontSize: 14,
                  fontWeight: (widget.propertyTypeChosen != proprtyTypeAtIndex)
                      ? FontWeight.w300
                      : FontWeight.w500,
                ),
              ),
              const Spacer(),
              Image.asset(
                (widget.propertyTypeController.text != proprtyTypeAtIndex)
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
