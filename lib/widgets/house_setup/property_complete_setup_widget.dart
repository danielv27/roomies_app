import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../backend/database.dart';
import '../../models/house_profile_images.dart';
import '../gradients/blue_gradient.dart';

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
  final List uploadIcon = [
    Image.asset("assets/icons/upload-house-images.png", width: 42, height: 42.77),
    Image.asset("assets/icons/upload-building-map.png", width: 43.2, height: 37.8),
    Image.asset("assets/icons/upload-building-map.png", width: 43.2, height: 37.8),
  ];

  final List uploadDescriptionFields = [
    "Pictures",
    "Building map",
    "Features",
  ];

  final List<String> furnishedList = ['yes', 'no'];
  final List<String> amountRoomsList = ['0', '1', '2', '3', '4'];
  final List<String> availableRooms = ['0', '1', '2', '3', '4'];

  String? furnishedDropdownValue;
  String? amountRoomsDropdownValue;
  String? availableRoomsDropdownValue;

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
                  child: const Text(
                    "Cannenburgh 1, 1018 LG Amsterdam", // TODO: take information from the controllers and display it here
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
                    uploadPictures(context, uploadDescriptionFields[0], uploadIcon[0],),
                    uploadPictures(context, uploadDescriptionFields[1], uploadIcon[1],),
                    textDescription("Description"),
                    Container(
                      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        controller: widget.houseDescriptionController,
                        style: const TextStyle(color: Colors.grey),
                        cursorColor: Colors.grey,
                        textInputAction: TextInputAction.next,
                        decoration: contentFieldsDecoration("Write a complete description about the house with at least 100 words...", const AssetImage('assets/icons/person.png')),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please write a description above 100 words"; // TODO: Check that the user typed at least 100 words
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    dropDownHouseChoices(context, "Furnished", furnishedList, furnishedDropdownValue, const AssetImage('assets/icons/person.png')),
                    dropDownHouseChoices(context, "Total amount of rooms", amountRoomsList, amountRoomsDropdownValue, const AssetImage('assets/icons/rooms.png')),
                    dropDownHouseChoices(context, "Available rooms", availableRooms, availableRoomsDropdownValue, const AssetImage('assets/icons/rooms.png')),
                    uploadPictures(context, uploadDescriptionFields[2], uploadIcon[2],),
                    textDescription("Price per room"),
                    Container(
                      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        controller: widget.pricePerRoomController,
                        style: const TextStyle(color: Colors.grey),
                        cursorColor: Colors.grey,
                        textInputAction: TextInputAction.next,
                        decoration: contentFieldsDecoration("0", const AssetImage('assets/icons/coin.png')),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please fill the price per room";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20,),
                    textDescription("Contact info"),
                    Container(
                      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        controller: widget.contactNameController,
                        style: const TextStyle(color: Colors.grey),
                        cursorColor: Colors.grey,
                        textInputAction: TextInputAction.next,
                        decoration: contentFieldsDecoration("Name contact person", const AssetImage('assets/icons/Email.png')),
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
                        decoration: contentFieldsDecoration("Email", const AssetImage('assets/icons/Email.png')),
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
                        decoration: contentFieldsDecoration("Phone number", const AssetImage('assets/icons/Email.png')),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please fill the phone number of the contact person";
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
              onPressed: () async {
                if (formKey3.currentState!.validate() && !areDropDownControllersEmpty()) {
                  if (widget.houseProfileImages.imageURLS.isNotEmpty) {
                    User? currentUser = auth.currentUser;
                    bool isInitialHouseProfileComplete = await FireStoreDataBase().checkIfCurrentUserHouseComplete();
                    FireStoreDataBase().createHouseProfile(
                      currentUser,
                      widget.postalCodeController,
                      widget.houseNumberController,
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
                    );
                    if (isInitialHouseProfileComplete == true) {
                      await uploadImageUrls();
                      Navigator.of(context).pop();
                    } else {
                      await uploadImageUrls();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }
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

  Text textDescription(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color.fromRGBO(101, 101, 107, 1),
      ),
    );
  }

  Widget contentFields(String hintText, var iconImage, var controller) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.grey),
        cursorColor: Colors.grey,
        textInputAction: TextInputAction.next,
        decoration: contentFieldsDecoration(hintText, iconImage),
      ),
    );
  }

  Widget dropDownHouseChoices(BuildContext context, String dropDownDescription, List<String> dropDownList, String? dropDownChoice, var iconImage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dropDownDescription,
          style: const TextStyle(
            fontSize: 14,
            color: Color.fromRGBO(101, 101, 107, 1),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          width: MediaQuery.of(context).size.width * 0.8,
          height: 65,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(235, 235, 235, 1),
            borderRadius: BorderRadius.circular(14.0),
          ),
          child: DropdownButtonFormField<String>(
            isDense: true,
            decoration: dropDownDecoration(iconImage),
            isExpanded: true,
            hint: const Text(
              "Choose",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            value: dropDownChoice,
            items: dropDownList
              .map<DropdownMenuItem<String>>((String value) => DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value, 
                  style: const TextStyle(fontSize: 14),
                ),
              )).toList(), 
            onChanged: (String? newValue) {
              setState(() {
                if (dropDownDescription == "Furnished") {
                  widget.furnishedController.text = newValue!;
                } else if (dropDownDescription == "Total amount of rooms") {
                  widget.numRoomController.text = newValue!;
                } else if (dropDownDescription == "Available rooms") {
                  widget.availableRoomController.text = newValue!;
                }
                dropDownChoice = newValue;
              });
            },
          ),
        ),
      ],
    );
  }

  InputDecoration dropDownDecoration(iconImage) {
    return InputDecoration(
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      prefixIcon: Align(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: ImageIcon(
          iconImage, 
          size: 15, 
          color: const Color.fromRGBO(101,101,107, 1),
        ),
      ),
    );
  }

  GestureDetector uploadPictures(BuildContext context, String descriptionField, var uploadIcon) {
    return GestureDetector(
      onTap: () async {
        await selectHouseImages();
        uploadFunction(selectedHouseImages);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14.0),
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(245, 247, 251, 1),
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 30, top: 30, bottom: 30, right: 30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Upload",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w300
                      ),
                    ),
                    const SizedBox(height: 6,),
                    Text(
                      descriptionField,
                      style: const TextStyle(
                        color: Color.fromRGBO(51, 51, 51, 1),
                        fontSize: 23,
                        fontWeight: FontWeight.w600
                      ),
                    )
                  ],
                ),
              ),
              const Spacer(),
              uploadIcon,
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration contentFieldsDecoration(String hintText, var imageIcon) {
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
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Align(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: Image(
            image: imageIcon,
            height: 15,
            width: 15,
          ),
        ),
      ),
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w300),
    );
  }

  bool areDropDownControllersEmpty() {
    if (widget.furnishedController.text.isNotEmpty && widget.numRoomController.text.isNotEmpty && widget.availableRoomController.text.isNotEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> uploadFunction(List<XFile> houseImages) async {
    setState(() {
      isUploading = true;
    });
    for (int i = 0; i < houseImages.length; i++) {
      var imageUrl = await uploadFile(houseImages[i]);
      widget.houseProfileImages.imageURLS.add(imageUrl);
    }
  }

  Future<String> uploadFile(XFile houseImage) async {
    Reference reference = storageRef.ref().child("house_images").child(auth.currentUser!.uid.toString()).child(houseImage.name);
    UploadTask uploadTask = reference.putFile(File(houseImage.path));
    await uploadTask.whenComplete(() {
      setState(() {
        uploadItem++;
        if (uploadItem == selectedHouseImages.length) {
          isUploading = false;
          uploadItem = 0;
        }    
      });
    });
    var url = await reference.getDownloadURL();
    return url;
  }

  Future selectHouseImages() async{
    try {
      final List<XFile>? houseImages = await ImagePicker().pickMultiImage(
        imageQuality: 50,
      );
      if (houseImages != null) {
        selectedHouseImages.addAll(houseImages);
      }
    } catch (error) {
      debugPrint("ERROR: $error");
    }
    setState(() {
      
    });
  }

  Future<void> uploadImageUrls() async {
    try { 
      await FirebaseFirestore.instance.collection('users')
        .doc(auth.currentUser?.uid)
        .collection("house_images")
        .add({
          'urls': widget.houseProfileImages.imageURLS,
        });
    } catch (e) {
      debugPrint("Error - $e");
    }
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

}
