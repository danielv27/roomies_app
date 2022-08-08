import 'package:dropdown_button2/dropdown_button2.dart';
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
  final AssetImage iconImage;
  String? dropDownChoice;

  @override
  State<DropDownChoices> createState() => _DropDownChoicesState();
}

class _DropDownChoicesState extends State<DropDownChoices> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      margin: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField2(
          decoration: const InputDecoration(
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
          ),
          isDense: true,
          isExpanded: true,
          hint: Row(
            children: [
              ImageIcon(
                widget.iconImage,
                size: 15, 
                color: const Color.fromRGBO(101,101,107, 1),
              ),
              const SizedBox(width: 10,),
              const Text(
                "Choose",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          validator: (value) => value == null ? "Please select if the place is furnished" : null,
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
          icon: const Icon(Icons.keyboard_arrow_down_sharp),
          iconSize: 30,
          scrollbarRadius: const Radius.circular(20),
          dropdownElevation: 8,
          buttonPadding: const EdgeInsets.only(right: 20, left: 20, bottom: 20, top: 20),
          buttonHeight: 65,
          buttonWidth: MediaQuery.of(context).size.width * 0.8,
          buttonDecoration: BoxDecoration(
            color: const Color.fromARGB(73, 160, 160, 160),
            borderRadius: BorderRadius.circular(14.0),
          ),
        ),
      ),
    );
  }
}