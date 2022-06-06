import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ListHousePage extends StatefulWidget {
  const ListHousePage({Key? key}) : super(key: key);

  @override
  State<ListHousePage> createState() => _ListHousePageState();
}

class _ListHousePageState extends State<ListHousePage> {
    final postalCodeController = TextEditingController();
    final apartmentNumberController = TextEditingController();
    final houseNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const BackButton(
          color: Colors.black,
        ),
      ),
      body: Column(
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
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: applyBlueGradient(),
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
                  onPressed: () {}, 
                  child: const Text(
                    "Next",
                    style: TextStyle(fontSize: 20, color:Colors.white)
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  BoxDecoration applyBlueGradient() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color.fromRGBO(0, 53, 190, 1), Color.fromRGBO(57, 103, 224, 1), Color.fromRGBO(117, 154, 255, 1)]
      )
    );
  }


}