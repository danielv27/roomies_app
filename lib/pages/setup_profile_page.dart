
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roomies_app/widgets/gradients/blue_gradient.dart';
import 'package:roomies_app/widgets/profile_setup/profile_complete_setup_widget.dart';
import 'package:roomies_app/widgets/profile_setup/profile_question_setup_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../backend/database.dart';
import '../models/user_profile_images.dart';
import '../models/user_profile_model.dart';


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
  
  UserSignupProfileModel userPersonalProfileModel = UserSignupProfileModel(about: '', birthdate: '', maxBudget: '', minBudget: '', roommate: '', study: '', work: '');
  UserProfileImages userProfileImages = UserProfileImages(imageURLS: []);

  final pageController = PageController();

  bool isLastPage = false;
  int profileSetupPages = 2;

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();

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
          count: profileSetupPages,
          effect: const WormEffect(
            spacing: 16,
            dotHeight: 10,
            dotWidth: 10,
            dotColor: Colors.grey,
            activeDotColor: Colors.pink,
          ),
          onDotClicked: (index) {
            if (formKey1.currentState!.validate()) {
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
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              isLastPage = index == profileSetupPages - 1;
            });
          },
          children: <Widget> [
            Form(
              key: formKey1,
              child: ProfileQuestionPage(
                minBudgetController: minBudgetController, 
                maxBudgetController: maxBudgetController,
                userPersonalProfileModel: userPersonalProfileModel,
              ),
            ),
            Form(
              key: formKey2,
              autovalidateMode: AutovalidateMode.always,
                child: CompleteProfilePage(
                  aboutMeController: aboutMeController, 
                  workController: workController, 
                  studyController: studyController,
                  roomMateController: roomMateController,
                  birthDateController: birthDateController,
                  userProfileImages: userProfileImages,
                ),
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage 
          ? SizedBox(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: blueGradient()
                    ),
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
                        if (formKey2.currentState!.validate() && checkControllers()) { // TODO: Bug --> valdiate is awlways true
                          if (userProfileImages.imageURLS.isNotEmpty) {
                            User? currentUser = auth.currentUser;
                            await FireStoreDataBase().createPersonalProfile(
                              currentUser,
                              userPersonalProfileModel.radius,
                              minBudgetController,
                              maxBudgetController,
                              aboutMeController,
                              workController,
                              studyController,
                              roomMateController,
                              birthDateController,
                            );
                            await uploadImageUrls();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          } 
                          else {
                            alertImageEmpty(context);
                          }
                        } else {
                          alertFieldEmpty(context);
                        }
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
          : SizedBox(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: blueGradient(),
                    ),
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
                        if (formKey1.currentState!.validate()) {
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

  Future<dynamic> alertImageEmpty(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context){
        return const AlertDialog(
          title: Text("Upload Images"),
          content: Text("Please Upload at least 1 profile image"),
        );
      }
    );
  }

  Future<dynamic> alertFieldEmpty(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context){
        return const AlertDialog(
          title: Text("Empty Fields"),
          content: Text("Please make sure to fill all the required fields"),
        );
      }
    );
  }
  
  Future<void> uploadImageUrls() async {
    try { 
      await FirebaseFirestore.instance.collection('users')
        .doc(auth.currentUser?.uid)
        .collection("profile_images")
        .add({
          'urls': userProfileImages.imageURLS,
        });
    } catch (e) {
      debugPrint("Error - $e");
    }
  }
  
  bool checkControllers() {
    if (aboutMeController.text.isEmpty) {
      return false;
    } else if (workController.text.isEmpty) {
      return false;
    } else if (studyController.text.isEmpty) {
      return false;
    } else if (roomMateController.text.isEmpty) {
      return false;
    } else if (birthDateController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
    
  }

}

