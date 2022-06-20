import 'package:flutter/material.dart';
import 'package:roomies_app/pages/auth_page.dart';
import 'package:roomies_app/widgets/house_setup/address_question_widget.dart';
import 'package:roomies_app/widgets/house_setup/check_info_widget.dart';
import 'package:roomies_app/widgets/house_setup/property_question_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SetupHousePage extends StatefulWidget {
  const SetupHousePage({Key? key}) : super(key: key);

  @override
  State<SetupHousePage> createState() => _SetupHousePageState();
}

class _SetupHousePageState extends State<SetupHousePage> with SingleTickerProviderStateMixin {
  final postalCodeController = TextEditingController();
  final apartmentNumberController = TextEditingController();
  final houseNumberController = TextEditingController();
  final pageController = PageController();

  final constructionYearController = TextEditingController();

  bool isLastPage = false;

  final String apiKey = "8d09db9c-0ecc-463e-a020-035728fb3f75";
  bool addressValidated = true; // change to false

  @override
  void dispose() {
    pageController.dispose();
    postalCodeController.dispose();
    apartmentNumberController.dispose();
    houseNumberController.dispose();
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
          count: 3,
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
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            onPageChanged: (index) {
              setState(() => isLastPage = index == 2);
            },
            children: <Widget> [
              AddressQuestionPage(postalCodeController: postalCodeController, houseNumberController: houseNumberController, apartmentNumberController: apartmentNumberController),
              PropertyQuestionPage(),
              CheckInfoPage(constructionYearController: constructionYearController),
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
                    registerHouse();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: ((context) => AuthPage()))
                    );
                  }, 
                  child: const Text(
                    "Complete house",
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
                      // setState(() {
                      //   addressValidated = false;
                      // });
                      // validateAddress(postalCodeController, houseNumberController, apiKey);
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

  // validateAddress(TextEditingController postalCodeController, TextEditingController houseNumberController, String apiKey) async {
  //   var postCode = postalCodeController.text;
  //   var houseNum = houseNumberController.text;
      
  //   final response = await http.get(
  //     Uri.parse('https://json.api-postcode.nl?postcode=' + postCode + '&number=' + houseNum), 
  //     headers: {'token': apiKey},
  //   );
  //   if (response.statusCode == 200) {
  //     print("Successfully checked address");
  //     setState(() {
  //       addressValidated = true;
  //     });
  //   } else {
  //     print("Incorrect address");
  //     setState(() {
  //       addressValidated = false;
  //     });
  //   }
  // }

}

/*
  implement register function to save all the filled text fields and associate it with the house
*/
void registerHouse() {
  print("house registered");
}
