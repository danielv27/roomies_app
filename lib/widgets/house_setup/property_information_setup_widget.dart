import 'package:flutter/material.dart';
import 'package:roomies_app/widgets/gradients/gradient.dart';

class PropertyInformationSetupPage extends StatefulWidget {
  const PropertyInformationSetupPage({
    Key? key,
    required this.constructionYearController,
    required this.livingSpaceController,
    required this.plotAreaContoller, 
    required this.pageController,
  }) : super(key: key);

  final TextEditingController constructionYearController;
  final TextEditingController livingSpaceController;
  final TextEditingController plotAreaContoller;

  final PageController pageController;

  @override
  State<PropertyInformationSetupPage> createState() => _PropertyInformationSetupPageState();
}

class _PropertyInformationSetupPageState extends State<PropertyInformationSetupPage> {
  final formKey2 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: SingleChildScrollView(
          child: Form(
            key: formKey2,
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 30.0, right: 30, top: 5),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Cannenburgh 1, 1018 LG Amsterdam",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 30.0, right: 30, top: 5),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Property Information",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.only(left: 30.0, right: 30, top: 20),
                  child: TextFormField(
                    controller: widget.constructionYearController,
                    style: const TextStyle(color: Colors.grey),
                    cursorColor: Colors.grey,
                    decoration: applyInputDecoration("Year of contruction"),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please fill the year of construction";
                      } else if (int.tryParse(value) == null) {
                        return "Please enter only numbers";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 30.0, right: 30, top: 20),
                  child: TextFormField(
                    controller: widget.livingSpaceController,
                    style: const TextStyle(color: Colors.grey),
                    cursorColor: Colors.grey,
                    textInputAction: TextInputAction.next,
                    decoration: applyInputDecoration("Living Space (m\u00B2)"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please fill the size of living space";
                      } else if (int.tryParse(value) == null) {
                        return "Please enter only numbers";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 30.0, right: 30, top: 20),
                  child: TextFormField(
                    controller: widget.plotAreaContoller,
                    style: const TextStyle(color: Colors.grey),
                    cursorColor: Colors.grey,
                    textInputAction: TextInputAction.done,
                    decoration: applyInputDecoration("Plot Area (m\u00B2)"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please fill the plot area";
                      } else if (int.tryParse(value) == null) {
                        return "Please enter only numbers";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: bottomSheet(context),
    );
  }

  SizedBox bottomSheet(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: CustomGradient().blueGradient(),
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
                if (formKey2.currentState!.validate()) {
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

  InputDecoration applyInputDecoration(String labelText) {
    return InputDecoration(
      filled: true,
      fillColor: const Color.fromRGBO(245, 247, 251, 1),
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 0,
          style: BorderStyle.none,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      prefixIcon: const Align(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: Image(
          image: AssetImage('assets/icons/person.png'),
          height: 15,
          width: 15,
        ),
      ),
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.grey),
    );
  }
}
