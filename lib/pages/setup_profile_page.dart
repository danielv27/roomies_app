
import 'package:flutter/material.dart';
import 'package:roomies_app/widgets/profile_setup/profile_complete_setup_widget.dart';
import 'package:roomies_app/widgets/profile_setup/profile_question_setup_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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

  final pageController = PageController();
  
  UserSignupProfileModel userPersonalProfileModel = UserSignupProfileModel(about: '', birthdate: '', maxBudget: '', minBudget: '', roommate: '', study: '', work: '');
  UserProfileImages userProfileImages = UserProfileImages(imageURLS: []);

  bool isLastPage = false;
  int profileSetupPages = 2;

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
          count: profileSetupPages,
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
            isLastPage = index == profileSetupPages - 1;
          });
        },
        children: <Widget> [
          ProfileQuestionPage(
            minBudgetController: minBudgetController, 
            maxBudgetController: maxBudgetController,
            userPersonalProfileModel: userPersonalProfileModel,
            pageController: pageController,
          ),
          CompleteProfilePage(
            minBudgetController: minBudgetController, 
            maxBudgetController: maxBudgetController,
            userPersonalProfileModel: userPersonalProfileModel,
            aboutMeController: aboutMeController, 
            workController: workController, 
            studyController: studyController,
            roomMateController: roomMateController,
            birthDateController: birthDateController,
            userProfileImages: userProfileImages,
            pageController: pageController,
          ),
        ],
      ),
    );
  }
}

