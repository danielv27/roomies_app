import 'package:flutter/material.dart';

class PropertyInformationSetupPage extends StatefulWidget {
  const PropertyInformationSetupPage({
    Key? key,
    required this.constructionYearController,
    required this.livingSpaceController,
    required this.plotAreaContoller,
  }) : super(key: key);

  final TextEditingController constructionYearController;
  final TextEditingController livingSpaceController;
  final TextEditingController plotAreaContoller;

  @override
  State<PropertyInformationSetupPage> createState() => _PropertyInformationSetupPageState();
}

class _PropertyInformationSetupPageState extends State<PropertyInformationSetupPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 30.0, right: 30, top: 5),
            alignment: Alignment.centerLeft,
            child: const Text(
              "Cannenburgh 1, 1018 LG Amsterdam",
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
              "Is this information correct?",
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
              controller: widget.constructionYearController,
              style: const TextStyle(color: Colors.grey),
              cursorColor: Colors.grey,
              decoration: applyInputDecoration("Year of contruction"),
              textInputAction: TextInputAction.next,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 30.0, right: 30, top: 20),
            child: TextFormField(
              controller: widget.livingSpaceController,
              style: const TextStyle(color: Colors.grey),
              cursorColor: Colors.grey,
              textInputAction: TextInputAction.next,
              decoration: applyInputDecoration("Living Space"),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 30.0, right: 30, top: 20),
            child: TextFormField(
              controller: widget.plotAreaContoller,
              style: const TextStyle(color: Colors.grey),
              cursorColor: Colors.grey,
              textInputAction: TextInputAction.done,
              decoration: applyInputDecoration("Plot Area"),
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
