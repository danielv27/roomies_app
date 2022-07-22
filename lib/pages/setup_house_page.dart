import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roomies_app/widgets/house_setup/property_address_setup_widget.dart';
import 'package:roomies_app/widgets/house_setup/property_information_setup_widget.dart';
import 'package:roomies_app/widgets/house_setup/property_type_setup_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../widgets/house_setup/property_condition_setup_widget.dart';
import '../widgets/house_setup/property_complete_setup_widget.dart';

class SetupHousePage extends StatefulWidget {
  const SetupHousePage({Key? key}) : super(key: key);

  @override
  State<SetupHousePage> createState() => _SetupHousePageState();
}

class _SetupHousePageState extends State<SetupHousePage> with SingleTickerProviderStateMixin {
  final postalCodeController = TextEditingController();
  final apartmentNumberController = TextEditingController();
  final houseNumberController = TextEditingController();

  final propertyTypeController = TextEditingController();

  final constructionYearController = TextEditingController();
  final livingSpaceController = TextEditingController();
  final plotAreaContoller = TextEditingController();

  final propertyConditionController = TextEditingController();


  final houseDescriptionController = TextEditingController();
  final furnishedController = TextEditingController();
  final numRoomController = TextEditingController();
  final availableRoomController = TextEditingController();
  final pricePerRoomController = TextEditingController();
  final contactNameController = TextEditingController();
  final contactEmailControler = TextEditingController();
  final contactPhoneNumberControler = TextEditingController();

  final pageController = PageController();

  bool isLastPage = false;
  int houseSetupPages = 5;

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: const BackButton(
          color: Colors.black,
        ),
        title: SmoothPageIndicator(
          controller: pageController,
          count: houseSetupPages,
          effect: const WormEffect(
            spacing: 16,
            dotHeight: 10,
            dotWidth: 10,
            dotColor: Colors.grey,
            activeDotColor: Colors.pink,
          ),
          onDotClicked: (index) {
            pageController.animateToPage(
              index, 
              duration: const Duration(milliseconds: 500), 
              curve: Curves.easeIn,
            );
          },
        ),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            isLastPage = index == houseSetupPages - 1;
          });
        },
        children: <Widget> [
          PropertyAddressSetupPage(
            postalCodeController: postalCodeController, 
            houseNumberController: houseNumberController, 
            apartmentNumberController: apartmentNumberController,
            pageController: pageController,
          ),
          PropertyTypeSetupPage(
            pageController: pageController,
            propertyTypeController: propertyTypeController,
          ),
          PropertyInformationSetupPage(
            constructionYearController: constructionYearController, 
            livingSpaceController: livingSpaceController, 
            plotAreaContoller: plotAreaContoller,
            pageController: pageController,
          ),
          PropertyConditionSetupPage(
            propertyConditionController: propertyConditionController,
            pageController: pageController,
          ),
          ProperCompleteSetupPage(
            postalCodeController: postalCodeController, 
            houseNumberController: houseNumberController, 
            apartmentNumberController: apartmentNumberController,

            propertyTypeController: propertyTypeController,

            constructionYearController: constructionYearController, 
            livingSpaceController: livingSpaceController, 
            plotAreaContoller: plotAreaContoller,

            propertyConditionController: propertyConditionController,

            houseDescriptionController: houseDescriptionController,
            furnishedController: furnishedController,
            numRoomController: numRoomController,
            availableRoomController: availableRoomController,
            pricePerRoomController: pricePerRoomController,
            contactNameController: contactNameController,
            contactEmailControler: contactEmailControler,
            contactPhoneNumberControler: contactPhoneNumberControler,

            pageController: pageController,
          ),
        ],
      ),
    );
  }
}
