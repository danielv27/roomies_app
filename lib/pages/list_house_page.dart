import 'package:flutter/material.dart';
import 'package:roomies_app/widgets/setup/address_question_page.dart';
import 'package:roomies_app/widgets/setup/check_info_page.dart';
import 'package:roomies_app/widgets/setup/property_question_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ListHousePage extends StatefulWidget {
  const ListHousePage({Key? key}) : super(key: key);

  @override
  State<ListHousePage> createState() => _ListHousePageState();
}

class _ListHousePageState extends State<ListHousePage> with SingleTickerProviderStateMixin {
  final postalCodeController = TextEditingController();
  final apartmentNumberController = TextEditingController();
  final houseNumberController = TextEditingController();

  final pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
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
          count: 3,
          effect: const WormEffect(
            spacing: 16,
            dotHeight: 10,
            dotWidth: 10,
            dotColor: Colors.grey,
            activeDotColor: Colors.pink,
          ),
          onDotClicked: (index) => pageController.animateToPage(
            index, 
            duration: const Duration(milliseconds: 500), 
            curve: Curves.easeIn)
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: pageController,
          children: <Widget> [
            AddressQuestionPage(postalCodeController: postalCodeController, houseNumberController: houseNumberController, apartmentNumberController: apartmentNumberController),
            PropertyQuestionPage(),
            CheckInfoPage(postalCodeController: postalCodeController),
          ],
        ),
      ),
      bottomSheet: SizedBox(
        height: 80,
        child: Row(
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
                onPressed: () { 
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 500), 
                    curve: Curves.easeInOut,
                  );
                }, 
                child: const Text(
                  "Next",
                  style: TextStyle(fontSize: 20, color:Colors.white)
                ),
              ),
            ),
          ],
        ),
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