import 'package:flutter/material.dart';

class AddressQuestionPage extends StatelessWidget {
  const AddressQuestionPage({
    Key? key,
    required this.postalCodeController,
    required this.houseNumberController,
    required this.apartmentNumberController,
  }) : super(key: key);

  final TextEditingController postalCodeController;
  final TextEditingController houseNumberController;
  final TextEditingController apartmentNumberController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget> [
        Container(
          padding: const EdgeInsets.only(left: 30.0, right: 30, top: 5),
          alignment: Alignment.centerLeft,
          child: const Text(
            "List house", 
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
            "What is your address?", 
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 24,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.only(left: 30.0, right: 30, top: 20),
          child: TextFormField(
            controller: postalCodeController,
            style: const TextStyle(color: Colors.grey),
            cursorColor: Colors.grey,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromRGBO(245, 247, 251, 1),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              prefixIcon: const Icon(
                Icons.person,
                size: 20,
                color: Colors.grey,
              ),
              labelText: "Postal code",
              labelStyle: const TextStyle(color: Colors.grey),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 30.0, right: 30, top: 20),
          child: TextFormField(
            controller: houseNumberController,
            style: const TextStyle(color: Colors.grey),
            cursorColor: Colors.grey,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromRGBO(245, 247, 251, 1),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              prefixIcon: const Icon(
                Icons.person,
                size: 20,
                color: Colors.grey,
              ),
              labelText: "House number",
              labelStyle: const TextStyle(color: Colors.grey),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 30.0, right: 30, top: 20),
          child: TextFormField(
            controller: apartmentNumberController,
            style: const TextStyle(color: Colors.grey),
            cursorColor: Colors.grey,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromRGBO(245, 247, 251, 1),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              prefixIcon: const Icon(
                Icons.person,
                size: 20,
                color: Colors.grey,
              ),
              labelText: "Apartment number",
              labelStyle: const TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}