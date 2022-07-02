
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roomies_app/widgets/profile_setup/complete_profile_widget.dart';
import 'package:roomies_app/widgets/profile_setup/profile_question_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../backend/database.dart';


class SetupProfilePage extends StatefulWidget {
  const SetupProfilePage({Key? key}) : super(key: key);

  @override
  State<SetupProfilePage> createState() => _SetupProfilePageState();
}

class _SetupProfilePageState extends State<SetupProfilePage> with SingleTickerProviderStateMixin {
  final minBudgetController = TextEditingController();
  final maxBudgetController = TextEditingController();

  final aboutMeController = TextEditingController();
  final workController = TextEditingController();
  final studyController = TextEditingController();
  final roomMateController = TextEditingController();
  final birthDateController = TextEditingController();

  final pageController = PageController();

  bool isLastPage = false;

  final String apiKey = "8d09db9c-0ecc-463e-a020-035728fb3f75";
  bool addressValidated = true; // change to false

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();

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
        child: Form(
          key: formKey,
          child: PageView(
            controller: pageController,
            onPageChanged: (index) {
              setState(() => isLastPage = index == 1);
            },
            children: <Widget> [
              ProfileQuestionPage(minBudgetController: minBudgetController, 
                                  maxBudgetController: maxBudgetController),
              CompleteProfilePage(aboutMeController: aboutMeController, 
                                  workController: workController, 
                                  studyController: studyController,
                                  roomMateController: roomMateController,
                                  birthDateController: birthDateController),
            ],
          ),
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
                    User? currentUser = auth.currentUser;
                    registerProfile();
                    FireStoreDataBase().createPersonalProfile(currentUser);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
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
                    if (checkControllers() && formKey.currentState!.validate()) {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 500), 
                        curve: Curves.easeInOut,
                      );
                      if (addressValidated) {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 500), 
                          curve: Curves.easeInOut,
                        );
                      } else {
                        showDialog(
                          builder: (BuildContext context) { 
                             return const AlertDialog(
                               title: Text('Wrong Address'), 
                               content: Text('Either post code or house number wrong'),
                             );
                           }, 
                          context: context
                        );
                      }
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
    if (minBudgetController.text.isNotEmpty || maxBudgetController.text.isNotEmpty) {
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

