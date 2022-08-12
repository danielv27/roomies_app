import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:roomies_app/backend/auth_api.dart';
import 'package:roomies_app/widgets/gradients/gradient.dart';

import '../../models/user_profile_images.dart';
import '../../models/user_profile_model.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({
    Key? key,
    required this.aboutMeController, 
    required this.workController, 
    required this.studyController, 
    required this.roomMateController, 
    required this.birthDateController,
    required this.userProfileImages, 
    required this.pageController, 
    required this.minBudgetController, 
    required this.maxBudgetController, 
    required this.latLngController,
    required this.userPersonalProfileModel,
  }) : super(key: key);

  final TextEditingController minBudgetController;
  final TextEditingController maxBudgetController;
  final TextEditingController latLngController;
  final UserSignupProfileModel userPersonalProfileModel;
  final TextEditingController aboutMeController;
  final TextEditingController workController;
  final TextEditingController studyController;
  final TextEditingController roomMateController;
  final TextEditingController birthDateController;

  final PageController pageController;

  final UserProfileImages userProfileImages;

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  String aboutMeDescription = "Write a complete description about the me with at least 100 words...";
  String workDescription = "Tell what do I do for work, why I like this job so much, how many days/hours per week and more...";
  String studyDescription = "Tell what do I do for study, why I like this study so much and more...";
  String roomMateDescription = "Tell what features you are looking in a room mate...";
  String birthDateDescription = "dd/mm/yyyy";

  final List<XFile> selectedProfileImages = [];
  bool isUploading = false;
  bool isRemoving = false;

  final FirebaseStorage storageRef = FirebaseStorage.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final formKey2 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: SingleChildScrollView(
          child: Form(
            key: formKey2,
            child: Container(
              padding: const EdgeInsets.only(left: 30.0, right: 30, top: 5),
              child: Column(
                children: <Widget> [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Pesonal profile", 
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Make your profile complete", 
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: selectedProfileImages.length + 1,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: (MediaQuery.of(context).size.width) / (MediaQuery.of(context).size.height / 1.3),
                    ), 
                    itemBuilder: (context, index) {
                      return index == selectedProfileImages.length 
                      ? GridTile(
                        child: Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 10, right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color.fromRGBO(245, 247, 251, 1),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: CustomGradient().blueGradient(),
                                ),
                                child: FloatingActionButton(
                                  heroTag: "btn1_$index",
                                  elevation: 0,
                                  onPressed: () async { 
                                    setState(() {
                                      isUploading = true;
                                    });
                                    await selectProfileImage();
                                  },
                                  backgroundColor: Colors.transparent,
                                  child: const Icon(Icons.add),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      : GridTile(
                        child: Stack(
                          children: [
                            (isUploading || isRemoving) 
                            ? const Center(child: CircularProgressIndicator())
                            : Container(
                              height: MediaQuery.of(context).size.height,
                              margin: const EdgeInsets.only(bottom: 10, right: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(
                                  File(selectedProfileImages[index].path), 
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: CustomGradient().blueGradient(),
                                ),
                                child: FloatingActionButton(
                                  heroTag: "btn2_$index",
                                  elevation: 0,
                                  onPressed: () async { 
                                    setState(() {
                                      isRemoving = true;
                                    });
                                    removeProfileImage(index);
                                  },
                                  backgroundColor: Colors.transparent,
                                  child: const Icon(Icons.remove),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  ),
                  const SizedBox(height: 30,),
                  textLabel("ABOUT ME"),
                  const SizedBox(height: 10,),
                  TextFormField(
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 10,
                    controller: widget.aboutMeController,
                    style: const TextStyle(color: Colors.grey),
                    cursorColor: Colors.grey,
                    decoration: applyInputDecoration(aboutMeDescription),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a description";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 30,),
                  textLabel("WORK"),
                  const SizedBox(height: 10,),
                  TextFormField(
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 10,
                    controller: widget.workController,
                    style: const TextStyle(color: Colors.grey),
                    cursorColor: Colors.grey,
                    decoration: applyInputDecoration(workDescription),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a description";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 30,),
                  textLabel("STUDY"),
                  const SizedBox(height: 10,),
                  TextFormField(
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 10,
                    controller: widget.studyController,
                    style: const TextStyle(color: Colors.grey),
                    cursorColor: Colors.grey,
                    decoration: applyInputDecoration(studyDescription),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a description";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 30,),
                  textLabel("WHAT DO I LIKE TO SEE IN A ROOM MATE"),
                  const SizedBox(height: 10,),
                  TextFormField(
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 10,              
                    controller: widget.roomMateController,
                    style: const TextStyle(color: Colors.grey),
                    cursorColor: Colors.grey,
                    decoration: applyInputDecoration(roomMateDescription),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a description";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 30,),
                  textLabel("MY DATE OF BIRTH"),
                  const SizedBox(height: 10,),
                  TextFormField(
                    controller: widget.birthDateController,
                    style: const TextStyle(color: Colors.grey),
                    cursorColor: Colors.grey,
                    textInputAction: TextInputAction.next,
                    decoration: applyInputDecoration(birthDateDescription),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your date of birth";
                      } else {
                        return null;
                      }
                    },
                    onTap: selectBirthDate,
                  ),
                  const SizedBox(height: 30,),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: bottomSheet(context),
    );
  }

  selectBirthDate() async {
    DateTime dateTime = DateTime.now();
    DateFormat inputFormat = DateFormat('dd/MM/yyyy');

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateTime,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(1900),
      lastDate: dateTime,
    );

    if (picked != null) {
      dateTime = picked;
      widget.birthDateController.text = inputFormat.format(dateTime);
    }
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
                if (formKey2.currentState!.validate()) {
                  if (widget.userProfileImages.imageURLS.isNotEmpty) {
                    await uploadFunction(selectedProfileImages);
                    await uploadImageUrls();
                    await AuthAPI().createPersonalProfile(
                      auth.currentUser,
                      widget.userPersonalProfileModel.radius,
                      widget.latLngController,
                      widget.minBudgetController,
                      widget.maxBudgetController,
                      widget.aboutMeController,
                      widget.workController,
                      widget.studyController,
                      widget.roomMateController,
                      widget.birthDateController,
                    );
                    if (!mounted) return;
                    Navigator.of(context).pop();
                    Navigator.of(context).maybePop();
                  }
                  else {
                    await alertImageEmpty(context);
                  }
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
    );
  }

  Widget textLabel(String textLabel) {
    return Row(
      children: <Widget>[
        Image.asset('assets/icons/GradientBlueEllipse.png', width: 11, height: 11,),
        const SizedBox(width: 5,),
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

  InputDecoration applyInputDecoration(String hint) {
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
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      prefixIcon: const Align(
        widthFactor: 2.0,
        heightFactor: 2.0,
        child: Icon(
          Icons.person_rounded,
        ),
      ),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w300),
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

  Future<String> uploadFile(XFile image) async {
    Reference reference = storageRef.ref().child("profile_images").child(auth.currentUser!.uid.toString()).child(image.name);
    await reference.putFile(File(image.path)).whenComplete(() {
      setState(() {
        isUploading = false;
      });
    });

    var url = await reference.getDownloadURL();
    widget.userProfileImages.imageURLS.add(url);

    return url;
  }

  Future<void> uploadFunction(List<XFile> profileImages) async {
    setState(() {
      isUploading = true;
    });
    for (int i = 0; i < profileImages.length; i++) {
      var imageUrl = await uploadFile(profileImages[i]);
      widget.userProfileImages.imageURLS.add(imageUrl);
    }
  }  

  Future<void> selectProfileImage() async {
    try {
      final XFile? profileImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 30,
      );
      if (profileImage != null) {
        selectedProfileImages.add(profileImage);
      }
    } catch (error) {
      debugPrint("ERROR: $error");
    }
    setState(() {
      
    });
  }

  Future removeFile(XFile image) async {
    Reference reference = storageRef.ref().child("profile_images").child(auth.currentUser!.uid.toString()).child(image.name);
    await reference.delete().whenComplete(() {
      setState(() {
        isRemoving = false;
      });
    });
  }

  removeProfileImage(int index) {
    setState(() {
      selectedProfileImages.removeAt(index);
      widget.userProfileImages.imageURLS.removeAt(index);
    });
  }
  
  Future<void> uploadImageUrls() async {
    try { 
      await FirebaseFirestore.instance.collection('users')
        .doc(auth.currentUser?.uid)
        .collection("profile_images")
        .add({
          'urls': widget.userProfileImages.imageURLS,
        });
    } catch (e) {
      debugPrint("Error - $e");
    }
  }

}
