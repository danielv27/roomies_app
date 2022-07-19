import 'package:flutter/material.dart';
import 'package:roomies_app/widgets/gradients/blue_gradient.dart';
import 'package:roomies_app/widgets/owner_page/owner_house.dart';

import '../widgets/owner_page/owner_bar.dart';

class OwnerPage extends StatefulWidget {
  const OwnerPage({Key? key}) : super(key: key);

  @override
  State<OwnerPage> createState() => _OwnerPageState();
}

class _OwnerPageState extends State<OwnerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: Container(
          padding: const EdgeInsets.only(left: 15.0, right: 30, top: 5),
          decoration: BoxDecoration(
            gradient: blueGradient()
          ),
          child: const OwnerBar(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 30.0, right: 30, top: 5),
          height: MediaQuery.of(context).size.height * 0.72,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 30),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Your contact info",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                    ),
                  ),
                ),
                contentFields("Phone number", const AssetImage('assets/icons/Email.png')),
                Container(
                  padding: const EdgeInsets.only(bottom: 30),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Houses",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                    ),
                  ),
                ),
                ListedOwnerHouse(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.72,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: blueGradient(),
        ),
        child: FloatingActionButton(
          splashColor: Colors.white.withOpacity(0.25),
          onPressed: () { 
            
          },
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.transparent,
          child: Row(
            children: const [
              Spacer(),
              Text("List new house",
                style: TextStyle(
                  fontWeight: FontWeight.w600
                ),
              ),
              SizedBox(width: 10,),
              ImageIcon(
                AssetImage("assets/icons/Home-selected.png"),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }


  Widget contentFields(String hintText, var iconImage,) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14.0),
        height: MediaQuery.of(context).size.height * 0.1,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(245, 247, 251, 1),
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Image.asset("assets/icons/Email.png",
                height: 20,
                width: 20,
              ),
              const SizedBox(
                width: 14,
              ),
              Text(
                "Test",
                style: TextStyle(
                  color:const Color.fromRGBO(101, 101, 107, 1),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}