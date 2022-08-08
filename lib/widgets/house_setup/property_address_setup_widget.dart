import 'package:flutter/material.dart';

import '../gradients/blue_gradient.dart';

class PropertyAddressSetupPage extends StatefulWidget {
  const PropertyAddressSetupPage({
    Key? key,
    required this.postalCodeController,
    required this.houseNumberController,
    required this.apartmentNumberController, 
    required this.pageController,
  }) : super(key: key);

  final TextEditingController postalCodeController;
  final TextEditingController houseNumberController;
  final TextEditingController apartmentNumberController;

  final PageController pageController;

  @override
  State<PropertyAddressSetupPage> createState() => _PropertyAddressSetupPageState();
}

class _PropertyAddressSetupPageState extends State<PropertyAddressSetupPage> {
  final postCodeRegex = RegExp(r"^([0-9]{4} ?[A-Z]{2})$");
  final houseNumberRegex = RegExp(r'^[a-zA-Z0-9\- ]*$');
  final formKey1 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: SingleChildScrollView(
          child: Form(
            key: formKey1,
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
                    decoration: applyInputDecoration("Postal code"),
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
                    decoration: applyInputDecoration("House number"),
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
                    decoration: applyInputDecoration("Apartment Number (Optional)")
                  ),
                ),
              ],
            ),
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
              gradient: blueGradient(),
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
                if (formKey1.currentState!.validate()) {
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

  InputDecoration applyInputDecoration(String labelText) {
    return InputDecoration(
      filled: true,
      fillColor: const Color.fromRGBO(245, 247, 251, 1),
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 0,
          style: BorderStyle.none,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      prefixIcon: const Align(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: Image(
          image: AssetImage('assets/icons/person.png'),
          height: 15,
          width: 15,
        ),
      ),
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.grey),
    );
  }
}
