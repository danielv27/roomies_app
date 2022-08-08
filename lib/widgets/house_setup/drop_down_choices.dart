import 'package:flutter/material.dart';

class DropDownChoices extends StatefulWidget {
  DropDownChoices({
    Key? key,
    required this.furnishedController,
    required this.iconImage,
    required this.dropDownList,
    required this.dropDownChoice,
  }) : super(key: key);

  final TextEditingController furnishedController;
  final List<String> dropDownList;
  String? dropDownChoice;
  final AssetImage iconImage;

  @override
  State<DropDownChoices> createState() => _DropDownChoicesState();
}

class _DropDownChoicesState extends State<DropDownChoices> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
        decoration: dropDownDecoration(widget.iconImage),
        isExpanded: true,
        hint: const Text(
          "Choose",
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        value: widget.dropDownChoice,
        items: widget.dropDownList
          .map<DropdownMenuItem<String>>((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(
              value, 
              style: const TextStyle(fontSize: 14),
            ),
          )).toList(),
        onChanged: (String? newValue) {
          setState(() {
            widget.furnishedController.text = newValue!;
            widget.dropDownChoice = widget.furnishedController.text;
          });
        },
      ),
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
}