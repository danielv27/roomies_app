import 'package:flutter/material.dart';

import '../circle_ring.dart';

class PropertyContentSetupPage extends StatefulWidget {
  const PropertyContentSetupPage({
    Key? key, 
    required this.houseDescriptionController,
    required this.pricePerRoomController,
    required this.contactNameController,
    required this.contactEmailControler,
    required this.contactPhoneNumberControler,
  }) : super(key: key);

  final TextEditingController houseDescriptionController;
  final TextEditingController pricePerRoomController;
  final TextEditingController contactNameController;
  final TextEditingController contactEmailControler;
  final TextEditingController contactPhoneNumberControler;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              uploadPictures(context, uploadDescriptionFields[0], uploadIcon[0],),
              uploadPictures(context, uploadDescriptionFields[1], uploadIcon[1],),
              textDescription("Description"),
              contentFields("Write a complete description about the house with at least 100 words...", const AssetImage('assets/icons/person.png'), widget.houseDescriptionController),
              dropDownHouseChoices(context, "Furnished", furnishedList, furnishedDropdownValue, const AssetImage('assets/icons/person.png')),
              dropDownHouseChoices(context, "Total amount of rooms", amountRoomsList, amountRoomsDropdownValue, const AssetImage('assets/icons/rooms.png')),
              dropDownHouseChoices(context, "Available rooms", availableRooms, availableRoomsDropdownValue, const AssetImage('assets/icons/rooms.png')),
              uploadPictures(context, uploadDescriptionFields[2], uploadIcon[2],),
              textDescription("Price per room"),
              contentFields("0", const AssetImage('assets/icons/coin.png'), widget.pricePerRoomController),
              const SizedBox(height: 20,),
              textDescription("Contact info"),
              contentFields("Name contact person", const AssetImage('assets/icons/email.png'), widget.contactNameController),
              contentFields("Email", const AssetImage('assets/icons/email.png'), widget.contactEmailControler),
              contentFields("Phone number", const AssetImage('assets/icons/email.png'), widget.contactPhoneNumberControler),
            ],
          ),
        ],
      ),
    );
  }

  Text textDescription(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color.fromRGBO(101, 101, 107, 1),
      ),
    );
  }

  Widget contentFields(String hintText, var iconImage, var controller) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.grey),
        cursorColor: Colors.grey,
        textInputAction: TextInputAction.next,
        decoration: contentFieldsDecoration(hintText, iconImage),
      ),
    );
  }

  Widget dropDownHouseChoices(BuildContext context, String dropDownDescription, List<String> dropDownList, String? dropDownChoice, var iconImage) {
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
          margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          width: MediaQuery.of(context).size.width * 0.8,
          height: 65,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(235, 235, 235, 1),
            borderRadius: BorderRadius.circular(14.0),
          ),
          child: DropdownButtonFormField<String>(
            isDense: true,
            decoration: dropDownDecoration(iconImage),
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

  InputDecoration dropDownDecoration(iconImage) {
    return InputDecoration(
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      prefixIcon: Align(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: ImageIcon(
          iconImage, 
          size: 15, 
          color: const Color.fromRGBO(101,101,107, 1),
        ),
      ),
    );
  }

  GestureDetector uploadPictures(BuildContext context, String descriptionField, var uploadIcon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          print("Upload $descriptionField");
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

  InputDecoration contentFieldsDecoration(String hintText, var imageIcon) {
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
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Align(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: Image(
            image: imageIcon,
            height: 15,
            width: 15,
          ),
        ),
      ),
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w300),
    );
  }

}
