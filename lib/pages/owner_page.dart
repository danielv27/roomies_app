import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:roomies_app/backend/providers/current_house_provider.dart';
import 'package:roomies_app/pages/setup_house_page.dart';
import 'package:roomies_app/widgets/gradients/gradient.dart';
import 'package:roomies_app/widgets/owner_page/owner_house.dart';

import '../widgets/owner_page/owner_bar.dart';
import '../widgets/owner_page/owner_info.dart';

class OwnerPage extends StatefulWidget {
  const OwnerPage({Key? key}) : super(key: key);

  @override
  State<OwnerPage> createState() => _OwnerPageState();
}

class _OwnerPageState extends State<OwnerPage> {
  @override
  void initState() {
    Provider.of<CurrentHouseProvider>(context, listen: false).initialize();
    Provider.of<CurrentHouseProvider>(context, listen: false).getHouseOwnerHouses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final houseProvider = context.watch<CurrentHouseProvider>();

    return (houseProvider.currentUser == null) 
    ? const Center(child: CircularProgressIndicator(color: Colors.red)) 
    : Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: Container(
          padding: const EdgeInsets.only(left: 15.0, right: 30, top: 5),
          decoration: BoxDecoration(
            gradient: CustomGradient().blueGradient()
          ),
          child: OwnerBar(houseProvider: houseProvider),
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
                HouseOwnerContactInformation(houseProvider: houseProvider),
                Container(
                  padding: const EdgeInsets.only(bottom: 15),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Houses",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                    ),
                  ),
                ),
                ListedOwnerHouse(houseProvider: houseProvider),
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
          gradient: CustomGradient().redGradient(),
        ),
        child: FloatingActionButton(
          splashColor: Colors.white.withOpacity(0.25),
          onPressed: () { 
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: const SetupHousePage(),
                isIos: true,
                duration: const Duration(milliseconds: 500),
              )
            );
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
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
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

}