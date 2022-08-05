import 'package:flutter/material.dart';
import 'package:roomies_app/models/user_profile_model.dart';
import 'package:roomies_app/widgets/gradients/blue_gradient.dart';

import 'package:roomies_app/widgets/profile_setup/profile_google_widget.dart';

class ProfileQuestionPage extends StatefulWidget {
  ProfileQuestionPage({
    Key? key,
    required this.minBudgetController,
    required this.maxBudgetController, 
    required this.latLngController,
    required this.userPersonalProfileModel, 
    required this.pageController,
  }) : super(key: key);

  final TextEditingController minBudgetController;
  final TextEditingController maxBudgetController;
  final TextEditingController latLngController;
  final PageController pageController;
  UserSignupProfileModel userPersonalProfileModel;

  @override
  State<ProfileQuestionPage> createState() => _ProfileQuestionPageState();
}

class _ProfileQuestionPageState extends State<ProfileQuestionPage> {
  final priceRegex = RegExp(r'^[a-zA-Z0-9\- ]*$');
  final formKey1 = GlobalKey<FormState>();

  var radiusWidth = 40;
  var radiusExpandedWidth = 65;

  List radiusDistnace = [1, 2, 3, 4, 5, 10];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: SingleChildScrollView(
          child: Form(
            key: formKey1,
            child: Container(
              padding: const EdgeInsets.only(left: 30.0, right: 30, top: 5),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Personal profile",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Where do you want to live?",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GoogleApiContainer(latLngController: widget.latLngController),
                  const SizedBox(
                    height: 10,
                  ),
                  textLabel("Radius in KM (optional)"),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      radiusCard(radiusDistnace[0].toString()),
                      const Spacer(),
                      radiusCard(radiusDistnace[1].toString()),
                      const Spacer(),
                      radiusCard(radiusDistnace[2].toString()),
                      const Spacer(),
                      radiusCard(radiusDistnace[3].toString()),
                      const Spacer(),
                      radiusCard(radiusDistnace[4].toString()),
                      const Spacer(),
                      radiusCard(radiusDistnace[5].toString()),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  textLabel("Minimum Budget"),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: widget.minBudgetController,
                    style: const TextStyle(color: Colors.grey),
                    cursorColor: Colors.grey,
                    textInputAction: TextInputAction.next,
                    decoration: applyInputDecoration(),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your minimum budget";
                      } else if (int.tryParse(value) == null) {
                        return "Please enter only numbers";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  textLabel("Maximum Budget"),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: widget.maxBudgetController,
                    style: const TextStyle(color: Colors.grey),
                    cursorColor: Colors.grey,
                    textInputAction: TextInputAction.next,
                    decoration: applyInputDecoration(),
                    validator: (value) {
                      final minimumBudget = widget.minBudgetController.text;
                      if (value!.isEmpty) {
                        return "Please enter your maximum budget";
                      } else if (int.tryParse(value) == null) {
                        return "Please enter only numbers";
                      } else if (minimumBudget.isNotEmpty) {
                        if (int.tryParse(minimumBudget)! > int.parse(value)) {
                          return "Maximum budget has to be larger than minimum";
                        }
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: bottomSheet(context),
    );
  }

  Widget bottomSheet(BuildContext context) {
    return SizedBox(
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
                  widget.pageController.nextPage(
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
    );
  }

  Widget radiusCard(String radius) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(0, 0, 0, 0.2)),
        borderRadius: BorderRadius.circular(14.0),
        color: (widget.userPersonalProfileModel.radius != radius)
            ? const Color.fromRGBO(245, 247, 251, 1)
            : const Color.fromRGBO(190, 212, 255, 1),
      ),
      child: Stack(
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            child: SizedBox(
              width: (widget.userPersonalProfileModel.radius != radius) ? radiusWidth.toDouble() : radiusExpandedWidth.toDouble(),
              height: 40,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Center(
                  child: Text(
                    "+$radius",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      leadingDistribution: TextLeadingDistribution.even,
                      foreground: (widget.userPersonalProfileModel.radius != radius)
                          ? (Paint()..color = const Color.fromRGBO(101, 101, 107, 1))
                          : (Paint()..shader = blueGradient().createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0))),
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    widget.userPersonalProfileModel.radius = radius;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget textLabel(String textLabel) {
    return Row(
      children: <Widget>[
        Image.asset(
          'assets/icons/GradientBlueEllipse.png',
          width: 11,
          height: 11,
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: Text(
            textLabel,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Color.fromRGBO(101, 101, 107, 1),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration applyInputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: const Color.fromRGBO(245, 247, 251, 1),
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 0,
          style: BorderStyle.none,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      prefixIcon: const Align(
        widthFactor: 2.0,
        heightFactor: 2.0,
        child: Image(
          image: AssetImage('assets/icons/coin.png'),
          height: 18,
          width: 18,
        ),
      ),
      hintText: "0",
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w300),
    );
  }
}
