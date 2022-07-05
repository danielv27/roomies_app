import 'package:flutter/material.dart';

import '../circle_ring.dart';

class PropertyContentSetupPage extends StatefulWidget {
  const PropertyContentSetupPage({
    Key? key, 
    required this.pricePerRoomController,
  }) : super(key: key);

  final TextEditingController pricePerRoomController;

  @override
  State<PropertyContentSetupPage> createState() => _PropertyContentSetupPageState();
}

class _PropertyContentSetupPageState extends State<PropertyContentSetupPage> {
  final List uploadIcon = [
    Image.asset("assets/icons/upload-house-images.png", width: 42, height: 42.77),
    Image.asset("assets/icons/upload-building-map.png", width: 43.2, height: 37.8),
    Image.asset("assets/icons/upload-building-map.png", width: 43.2, height: 37.8),
  ];

  final List uploadDescriptionFields = [
    "Pictures",
    "Building map",
    "Features",
  ];

  final List<String> furnishedList = ['yes', 'no'];
  final List<String> amountRoomsList = ['0', '1', '2', '3', '4'];
  final List<String> availableRooms = ['0', '1', '2', '3', '4'];

  String? furnishedDropdownValue;
  String? amountRoomsDropdownValue;
  String? availableRoomsDropdownValue;

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
              uploadPictures(context, uploadDescriptionFields[0], uploadIcon[0],),
              uploadPictures(context, uploadDescriptionFields[1], uploadIcon[1],),
              furnishedChoice(context, "Furnished", furnishedList, furnishedDropdownValue),
              furnishedChoice(context, "Total amount of rooms", amountRoomsList, amountRoomsDropdownValue),
              furnishedChoice(context, "Available rooms", availableRooms, availableRoomsDropdownValue),
              // uploadPictures(context, uploadDescriptionFields[2], uploadIcon[2],),
              pricePerRoomField(),
            ],
          ),
        ],
      ),
    );
  }

  Widget pricePerRoomField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Price per room",
            style: TextStyle(
              fontSize: 14,
              color: Color.fromRGBO(101, 101, 107, 1),
            ),
          ),
          TextFormField(
            controller: widget.pricePerRoomController,
            style: const TextStyle(color: Colors.grey),
            cursorColor: Colors.grey,
            textInputAction: TextInputAction.next,
            decoration: applyInputDecoration(),
          ),
        ],
      ),
    );
  }

  Widget furnishedChoice(BuildContext context, String dropDownDescription, List<String> dropDownList, String? dropDownChoice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dropDownDescription,
          style: const TextStyle(
            fontSize: 14,
            color: Color.fromRGBO(101, 101, 107, 1),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(top: 10.0, bottom: 14.0),
          width: MediaQuery.of(context).size.width * 0.8,
          height: 65,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(235, 235, 235, 1),
            borderRadius: BorderRadius.circular(14.0),
          ),
          child: DropdownButtonFormField<String>(
            isDense: true,
            decoration: const InputDecoration(
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              prefixIcon: Icon(Icons.person),
            ),
            isExpanded: true,
            hint: const Text(
              "Choose",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            value: dropDownChoice,
            items: dropDownList
              .map<DropdownMenuItem<String>>((String value) => DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value, 
                  style: const TextStyle(fontSize: 14),
                ),
              )).toList(), 
            onChanged: (String? newValue) {
              setState(() {
                dropDownChoice = newValue;
              });
            },
          ),
        ),
      ],
    );
  }

  GestureDetector uploadPictures(BuildContext context, String descriptionField, var uploadIcon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (descriptionField == "Pictures") {
            print("upload house pictures");
          } else {
            print("Upload building map");
          }
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

  InputDecoration applyInputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: const Color.fromRGBO(245, 247, 251, 1),
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 0,
          style: BorderStyle.none,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      prefixIcon: const Align(
        widthFactor: 2.0,
        heightFactor: 2.0,
        child: Image(
          image: AssetImage('assets/icons/coin.png'),
          height: 18,
          width: 18,
        ),
      ),
      hintText: "0",
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w300),
    );
  }

}
