import 'package:flutter/material.dart';

class PropertyAddressSetupPage extends StatefulWidget {
  const PropertyAddressSetupPage({
    Key? key,
    required this.postalCodeController,
    required this.houseNumberController,
    required this.apartmentNumberController,
  }) : super(key: key);

  final TextEditingController postalCodeController;
  final TextEditingController houseNumberController;
  final TextEditingController apartmentNumberController;

  @override
  State<PropertyAddressSetupPage> createState() => _PropertyAddressSetupPageState();
}

class _PropertyAddressSetupPageState extends State<PropertyAddressSetupPage> {
  final postCodeRegex = RegExp(r"^([0-9]{4} ?[A-Z]{2})$");
  final houseNumberRegex = RegExp(r'^[a-zA-Z0-9\- ]*$');

  // final String apiKey = "8d09db9c-0ecc-463e-a020-035728fb3f75";
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
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
              controller: widget.postalCodeController,
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
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                prefixIcon: const Icon(
                  Icons.person,
                  size: 20,
                  color: Colors.grey,
                ),
                labelText: "Postal code",
                labelStyle: const TextStyle(color: Colors.grey),
              ),
              validator: (value) {
                if (value!.isEmpty || !postCodeRegex.hasMatch(value)) {
                  return "example 1234 AB or 1234AB";
                } else {
                  return null;
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 30.0, right: 30, top: 20),
            child: TextFormField(
              controller: widget.houseNumberController,
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
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                prefixIcon: const Icon(
                  Icons.person,
                  size: 20,
                  color: Colors.grey,
                ),
                labelText: "House number",
                labelStyle: const TextStyle(color: Colors.grey),
              ),
              validator: (value) {
                if (value!.isEmpty || !houseNumberRegex.hasMatch(value)) {
                  return "Enter only numbers or alphabet letters";
                } else {
                  return null;
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 30.0, right: 30, top: 20),
            child: TextFormField(
              controller: widget.apartmentNumberController,
              style: const TextStyle(color: Colors.grey),
              cursorColor: Colors.grey,
              textInputAction: TextInputAction.done,
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
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
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
      ),
    );
  }
}
