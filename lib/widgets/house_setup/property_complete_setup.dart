import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:roomies_app/backend/auth_api.dart';
import 'package:roomies_app/widgets/gradients/gradient.dart';
import 'package:roomies_app/widgets/house_setup/drop_down_choices.dart';
import 'package:roomies_app/widgets/house_setup/house_input_decorations.dart';
import 'package:roomies_app/widgets/house_setup/upload_building_map.dart';
import 'package:roomies_app/widgets/house_setup/upload_house_pictures.dart';

import '../../models/house_profile_images.dart';

class ProperCompleteSetupPage extends StatefulWidget {
  const ProperCompleteSetupPage({
    Key? key, 
    required this.houseDescriptionController,
    required this.pricePerRoomController,
    required this.contactNameController,
    required this.contactEmailControler,
    required this.contactPhoneNumberControler, 
    required this.pageController, 
    required this.postalCodeController, 
    required this.houseNumberController, 
    required this.apartmentNumberController, 
    required this.constructionYearController, 
    required this.livingSpaceController, 
    required this.plotAreaContoller, 
    required this.propertyTypeController,
    required this.propertyConditionController, 
    required this.furnishedController,
    required this.numRoomController, 
    required this.availableRoomController,
    required this.houseProfileImages,
  }) : super(key: key);

  final TextEditingController postalCodeController;
  final TextEditingController houseNumberController;
  final TextEditingController apartmentNumberController;
  final TextEditingController propertyTypeController;
  final TextEditingController constructionYearController;
  final TextEditingController livingSpaceController;
  final TextEditingController plotAreaContoller;
  final TextEditingController propertyConditionController;
  final TextEditingController houseDescriptionController;
  final TextEditingController furnishedController;
  final TextEditingController numRoomController;
  final TextEditingController availableRoomController;
  final TextEditingController pricePerRoomController;
  final TextEditingController contactNameController;
  final TextEditingController contactEmailControler;
  final TextEditingController contactPhoneNumberControler;

  final PageController pageController;

  final HouseProfileImages houseProfileImages;

  @override
  State<ProperCompleteSetupPage> createState() => _ProperCompleteSetupPageState();
}

class _ProperCompleteSetupPageState extends State<ProperCompleteSetupPage> {
  final List<String> furnishedList = ['yes', 'no'];
  String? furnishedDropdownValue;

  final List<XFile> selectedHouseImages = [];
  int uploadItem = 0;
  bool isUploading = false;

  final FirebaseStorage storageRef = FirebaseStorage.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final formKey3 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return isUploading
    ? const Center(child: CircularProgressIndicator())
    : Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: SingleChildScrollView(
          child: Form(
            key: formKey3,
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 30.0, right: 30, top: 5),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${widget.postalCodeController.text}, ${widget.apartmentNumberController.text}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 30.0, right: 30, top: 5),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Content for the house",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UploadHousePictures(houseProfileImages: widget.houseProfileImages, currentUserID: auth.currentUser!.uid),
                    UploadBuildingMap(houseProfileImages: widget.houseProfileImages, currentUserID: auth.currentUser!.uid),
                    CustomHouseDecorations().textDescription("Description"),
                    Container(
                      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 10,
                        controller: widget.houseDescriptionController,
                        style: const TextStyle(color: Colors.grey),
                        cursorColor: Colors.grey,
                        decoration: CustomHouseDecorations().lastSetupPageDecoration("Write a complete description about the house", const AssetImage('assets/icons/person.png')),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please write a description above 100 words";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    CustomHouseDecorations().textDescription("Furnished"),
                    DropDownChoices(
                      dropDownList: furnishedList, 
                      furnishedController: widget.furnishedController, 
                      iconImage: const AssetImage('assets/icons/person.png'),
                      dropDownChoice: furnishedDropdownValue,
                    ),
                    CustomHouseDecorations().textDescription("Total Number Rooms"),
                    Container(
                      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        controller: widget.numRoomController,
                        style: const TextStyle(color: Colors.grey),
                        cursorColor: Colors.grey,
                        textInputAction: TextInputAction.next,
                        decoration: CustomHouseDecorations().lastSetupPageDecoration("0", const AssetImage('assets/icons/rooms.png')),
                        validator: (value) {
                          final availableNumberRoomes = widget.availableRoomController.text;
                          if (value!.isEmpty) {
                            return "Please fill the number of rooms";
                          } else if (int.tryParse(value) == null) {
                            return "Please enter only numbers";
                          } else if (availableNumberRoomes.isNotEmpty) {
                            if (int.tryParse(availableNumberRoomes)! > int.parse(value)) {
                              return "total can't be less than available";
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                    CustomHouseDecorations().textDescription("Available Number Rooms"),
                    Container(
                      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        controller: widget.availableRoomController,
                        style: const TextStyle(color: Colors.grey),
                        cursorColor: Colors.grey,
                        textInputAction: TextInputAction.next,
                        decoration: CustomHouseDecorations().lastSetupPageDecoration("0", const AssetImage('assets/icons/rooms.png')),
                        validator: (value) {
                          final totalNumberRoomes = widget.numRoomController.text;
                          if (value!.isEmpty) {
                            return "Please fill the number of available rooms";
                          } else if (int.tryParse(value) == null) {
                            return "Please enter only numbers";
                          } else if (totalNumberRoomes.isNotEmpty) {
                            if (int.tryParse(totalNumberRoomes)! < int.parse(value)) {
                              return "available can't be more than total";
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                    CustomHouseDecorations().textDescription("Price per room"),
                    Container(
                      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        controller: widget.pricePerRoomController,
                        style: const TextStyle(color: Colors.grey),
                        cursorColor: Colors.grey,
                        textInputAction: TextInputAction.next,
                        decoration: CustomHouseDecorations().lastSetupPageDecoration("0", const AssetImage('assets/icons/coin.png')),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please fill the price per room";
                          } else if (int.tryParse(value) == null) {
                            return "Please enter only numbers";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20,),
                    CustomHouseDecorations().textDescription("Contact info"),
                    Container(
                      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        controller: widget.contactNameController,
                        style: const TextStyle(color: Colors.grey),
                        cursorColor: Colors.grey,
                        textInputAction: TextInputAction.next,
                        decoration: CustomHouseDecorations().lastSetupPageDecoration("Name contact person", const AssetImage('assets/icons/Email.png')),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please fill the name of the contact person";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        controller: widget.contactEmailControler,
                        style: const TextStyle(color: Colors.grey),
                        cursorColor: Colors.grey,
                        textInputAction: TextInputAction.next,
                        decoration: CustomHouseDecorations().lastSetupPageDecoration("Email", const AssetImage('assets/icons/Email.png')),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please fill the email of the contact person";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        controller: widget.contactPhoneNumberControler,
                        style: const TextStyle(color: Colors.grey),
                        cursorColor: Colors.grey,
                        textInputAction: TextInputAction.next,
                        decoration: CustomHouseDecorations().lastSetupPageDecoration("Phone number", const AssetImage('assets/icons/Email.png')),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please fill the phone number of the contact person";
                          }  else if (!isMobileNumberValid(value)) {
                            return "Please input a valid phone number";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ],
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
              onPressed: () async {
                if (formKey3.currentState!.validate()) {
                  if (widget.houseProfileImages.imageURLS.isNotEmpty) {
                    User? currentUser = auth.currentUser;
                    await AuthAPI().createHouseProfile(
                      currentUser,
                      widget.postalCodeController,
                      widget.houseNumberController,
                      widget.apartmentNumberController,
                      widget.propertyTypeController,
                      widget.constructionYearController,
                      widget.livingSpaceController,
                      widget.plotAreaContoller,
                      widget.propertyConditionController,
                      widget.houseDescriptionController,
                      widget.furnishedController,
                      widget.numRoomController,
                      widget.availableRoomController,
                      widget.pricePerRoomController,
                      widget.contactNameController,
                      widget.contactEmailControler,
                      widget.contactPhoneNumberControler,
                      widget.houseProfileImages.imageURLS,
                    );
                    if (!mounted) return;
                    Navigator.of(context).pop();
                    Navigator.of(context).maybePop();
                  } else {
                    await alertImageEmpty(context);
                  }
                }
              }, 
              child: const Text(
                "Complete house",
                style: TextStyle(fontSize: 20, color:Colors.white)
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> alertImageEmpty(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context){
        return const AlertDialog(
          title: Text("Upload Images"),
          content: Text("Please Upload at least 1 house image"),
        );
      }
    );
  }

  bool isMobileNumberValid(String phoneNumber) {
    String regexPattern = r'^(?:[+0][1-9])?[0-9]{10,12}$';
    var regExp = RegExp(regexPattern);

    if (phoneNumber.isEmpty) {
      return false;
    } else if (regExp.hasMatch(phoneNumber)) {
      return true;
    }
    return false;
  }

}