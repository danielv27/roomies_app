import 'package:flutter/material.dart';

class ListedOwnerHouse extends StatefulWidget {
  ListedOwnerHouse({Key? key}) : super(key: key);

  @override
  State<ListedOwnerHouse> createState() => _OwnerHouseState();
}

class _OwnerHouseState extends State<ListedOwnerHouse> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14.0),
        height: 100,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(238, 238, 238, 1),
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                height: 68,
                width: 68,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.0),
                  color: Colors.white,
                ),
                child: Image.asset("assets/icons/Grey-house-selected.png",
                  height: 20,
                  width: 20,
                ),
              ),
              const SizedBox(
                width: 14,
              ),
              Text(
                "Address",
                style: TextStyle(
                  color:const Color.fromRGBO(101, 101, 107, 1),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              const Icon(Icons.arrow_forward_ios)
            ],
          ),
        ),
      ),
    );
  }
}