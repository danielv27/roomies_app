import 'package:flutter/material.dart';

class CheckInfoPage extends StatelessWidget {
  const CheckInfoPage({
    Key? key,
    required this.constructionYearController,
  }) : super(key: key);

  final TextEditingController constructionYearController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget> [
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
            controller: constructionYearController,
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
                borderRadius: BorderRadius.circular(14),
              ),
              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              prefixIcon: const Icon(
                Icons.person,
                size: 20,
                color: Colors.grey,
              ),
              labelText: "Year of construction",
              labelStyle: const TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}