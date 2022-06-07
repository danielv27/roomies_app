import 'package:flutter/material.dart';
import 'package:roomies_app/pages/auth_page.dart';
import 'package:roomies_app/widgets/profile_setup/complete_profile_widget.dart';
import 'package:roomies_app/widgets/profile_setup/profile_question_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SetupProfilePage extends StatefulWidget {
  const SetupProfilePage({Key? key}) : super(key: key);

  @override
  State<SetupProfilePage> createState() => _SetupProfilePageState();
}

class _SetupProfilePageState extends State<SetupProfilePage> with SingleTickerProviderStateMixin {
  final postalCodeController = TextEditingController();
  final apartmentNumberController = TextEditingController();
  final houseNumberController = TextEditingController();
  final pageController = PageController();

  final ConstructionYearController = TextEditingController();

  bool isLastPage = false;

  @override
  void dispose() {
    pageController.dispose();
    postalCodeController.dispose();
    apartmentNumberController.dispose();
    houseNumberController.dispose();
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
          count: 2,
          effect: const WormEffect(
            spacing: 16,
            dotHeight: 10,
            dotWidth: 10,
            dotColor: Colors.grey,
            activeDotColor: Colors.pink,
          ),
          onDotClicked: (index) {
            if (checkControllers()) {
              pageController.animateToPage(
                index, 
                duration: const Duration(milliseconds: 500), 
                curve: Curves.easeIn,
              );
            }
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: pageController,
          onPageChanged: (index) {
            setState(() => isLastPage = index == 1);
          },
          children: <Widget> [
            ProfileQuestionPage(postalCodeController: postalCodeController, houseNumberController: houseNumberController, apartmentNumberController: apartmentNumberController),
            CompleteProfilePage(constructionYearController: ConstructionYearController),
          ],
        ),
      ),
      bottomSheet: isLastPage ?
        SizedBox(
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
                  onPressed: () async {
                    registerProfile();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: ((context) => AuthPage()))
                    );
                  }, 
                  child: const Text(
                    "Complete profile",
                    style: TextStyle(fontSize: 20, color:Colors.white)
                  ),
                ),
              ),
            ],
          ),
        )
        : 
        SizedBox(
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
                    if (checkControllers()) {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 500), 
                        curve: Curves.easeInOut,
                      );
                    }
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

  bool checkControllers() {
    if (postalCodeController.text.isNotEmpty || houseNumberController.text.isNotEmpty || apartmentNumberController.text.isNotEmpty) {
      return true;
    }
    return false;
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

/*
  implement register function to save all the filled text fields and associate it with the user
*/
void registerProfile() {
  print("user registered");
}