import 'package:flutter/material.dart';
import 'package:roomies_app/pages/setup_house_page.dart';
import 'package:roomies_app/pages/setup_profile_page.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({Key? key}) : super(key: key);

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.height / 2,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(239, 85, 100, 1),
              Color.fromRGBO(195, 46, 66, 1),
              Color.fromRGBO(190, 40, 62, 1),
              Color.fromRGBO(210, 66, 78, 1),
              Color.fromRGBO(244, 130, 114, 1),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Spacer(),
            const SizedBox(
              child: Text(
                "SET UP YOUR PROFILE",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  // fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              child: const Text(
                "Are you looking for a roommate or a house, or do you want to rent/list your houses?",
                style: TextStyle(
                  // fontFamily: 'Inter',
                  // fontWeight: FontWeight.w400,
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                
              ],
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton (
                onPressed: () { 
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SetupProfilePage()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:const [
                    Text(
                      "Set up personal profile",
                      style: TextStyle(
                        // fontFamily: 'Inter',
                        // fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.person_add,
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.red,
                  padding: const EdgeInsets.only(left: 40, bottom: 20, top: 20, right: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              )
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton (
                onPressed: () { 
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SetupHousePage()),
                  );
                 },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:const [
                    Text(
                      "List houses",
                      style: TextStyle(
                        fontSize: 16,
                        // fontFamily: 'Inter',
                        // fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.add_home_rounded
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white.withOpacity(0.4),
                  onPrimary: Colors.white,
                  padding: const EdgeInsets.only(left: 40, bottom: 20, top: 20, right: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              )
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 8),
          ], 
        ),
      ),
    );
  }

}