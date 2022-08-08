import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:roomies_app/pages/setup_house_page.dart';
import 'package:roomies_app/pages/setup_profile_page.dart';
import 'package:roomies_app/widgets/gradients/gradient.dart';

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
        decoration: BoxDecoration(
          gradient: CustomGradient().redGradient(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 35.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:<Widget>[
                    Transform.translate(
                      offset: const Offset(10, 0),
                      child: Image.asset('assets/images/setup-circle.png', width: 120, height : 120),
                    ),                    
                    Transform.translate(
                      offset: const Offset(-10, 0),
                      child: Image.asset('assets/images/setup-circle.png', width: 120, height : 120),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              child: Text(
                "SET UP YOUR PROFILE",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              child: const Text(
                "Are you looking for a roommate or a house, or do you want to rent/list your houses?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton (
                onPressed: () { 
                  Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: const SetupProfilePage()));
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.red,
                  padding: const EdgeInsets.only(left: 40, bottom: 20, top: 20, right: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:const [
                    Text(
                      "Set up personal profile",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.person_add,
                    ),
                  ],
                ),
              )
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton (
                onPressed: () { 
                  Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: const SetupHousePage()));
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white.withOpacity(0.4),
                  onPrimary: Colors.white,
                  padding: const EdgeInsets.only(left: 40, bottom: 20, top: 20, right: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:const [
                    Text(
                      "List houses",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.add_home_rounded
                    ),
                  ],
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