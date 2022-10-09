import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:roomies_app/models/user_profile_model.dart';

import '../backend/auth_api.dart';
import '../widgets/gradients/gradient.dart';
import '../widgets/profile_setup/profile_google_widget.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key, 
    required this.currentUser,
  }) : super(key: key);

  final UserProfileModel currentUser;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final priceRegex = RegExp(r'^[a-zA-Z0-9\- ]*$');
  final formKey1 = GlobalKey<FormState>();

  var radiusWidth = 40;
  var radiusExpandedWidth = 65;
  List radiusDistnace = [1, 2, 3, 4, 5, 10];

  final TextEditingController minBudgetController = TextEditingController();
  final TextEditingController maxBudgetController = TextEditingController();
  final TextEditingController latLngController = TextEditingController();
  final TextEditingController streetNameController = TextEditingController();
  final TextEditingController cityNameController = TextEditingController();

  final TextEditingController aboutMeController = TextEditingController();
  final TextEditingController workController = TextEditingController();
  final TextEditingController studyController = TextEditingController();
  final TextEditingController roomMateController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  bool isUploading = false;
  bool isRemoving = false;

  final FirebaseStorage storageRef = FirebaseStorage.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    minBudgetController.text = widget.currentUser.userModel.userSignupProfileModel.minBudget;
    maxBudgetController.text = widget.currentUser.userModel.userSignupProfileModel.maxBudget;
    latLngController.text = widget.currentUser.userModel.userSignupProfileModel.latLng;
    streetNameController.text = widget.currentUser.userModel.userSignupProfileModel.streetName;
    cityNameController.text = widget.currentUser.userModel.userSignupProfileModel.cityName;

    aboutMeController.text = widget.currentUser.userModel.userSignupProfileModel.about;
    workController.text = widget.currentUser.userModel.userSignupProfileModel.work;
    studyController.text = widget.currentUser.userModel.userSignupProfileModel.study;
    roomMateController.text = widget.currentUser.userModel.userSignupProfileModel.roommate;
    birthDateController.text = widget.currentUser.userModel.userSignupProfileModel.birthdate;

    return  Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: BackButton(
          color: Colors.black,
          onPressed: () async {
            if (formKey1.currentState!.validate()) {
              if (widget.currentUser.imageURLS.isNotEmpty) {
                await AuthAPI().updatePersonalProfile(
                  auth.currentUser,
                  widget.currentUser.userModel.userSignupProfileModel.radius,
                  latLngController,
                  streetNameController,
                  cityNameController,
                  minBudgetController,
                  maxBudgetController,
                  aboutMeController,
                  workController,
                  studyController,
                  roomMateController,
                  birthDateController,
                );
                if (!mounted) return;
                Navigator.of(context).pop();
              } else {
                showAlertImageDialog(context);  
              }
            }
          },
        ),
      ),
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
                      "Profile Page",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.currentUser.imageURLS.length + 1,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: (MediaQuery.of(context).size.width) / (MediaQuery.of(context).size.height / 1.3),
                    ), 
                    itemBuilder: (context, index) {
                      return index == widget.currentUser.imageURLS.length 
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
                                    await addProfileImage(widget.currentUser.imageURLS);
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
                            Container(
                              height: MediaQuery.of(context).size.height,
                              margin: const EdgeInsets.only(bottom: 10, right: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  (widget.currentUser.imageURLS[index]), 
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
                                    removeProfileImage(index, widget.currentUser.imageURLS);
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
                    controller: aboutMeController,
                    style: const TextStyle(color: Colors.grey),
                    cursorColor: Colors.grey,
                    decoration: applyInputDecoration(""),
                    onChanged: (value) => setState(() => aboutMeController.text = value),
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
                    controller: workController,
                    style: const TextStyle(color: Colors.grey),
                    cursorColor: Colors.grey,
                    decoration: applyInputDecoration(""),
                    onChanged: (value) => setState(() => workController.text = value),
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
                    controller: studyController,
                    style: const TextStyle(color: Colors.grey),
                    cursorColor: Colors.grey,
                    decoration: applyInputDecoration(""),
                    onChanged: (value) => setState(() => studyController.text = value),
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
                    controller: roomMateController,
                    style: const TextStyle(color: Colors.grey),
                    cursorColor: Colors.grey,
                    decoration: applyInputDecoration(""),
                    onChanged: (value) => setState(() => roomMateController.text = value),
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
                    controller: birthDateController,
                    style: const TextStyle(color: Colors.grey),
                    cursorColor: Colors.grey,
                    textInputAction: TextInputAction.next,
                    decoration: applyInputDecoration(""),
                    onChanged: (value) => setState(() => birthDateController.text = value),
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
                  GoogleApiContainer(
                    latLngController: latLngController, 
                    cityNameController: cityNameController, 
                    streetNameController: streetNameController, 
                  ),
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
                    controller: minBudgetController,
                    style: const TextStyle(color: Colors.grey),
                    cursorColor: Colors.grey,
                    textInputAction: TextInputAction.next,
                    decoration: inputDecoCoin("0"),
                    onChanged: (value) => setState(() => minBudgetController.text = value),
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
                    controller: maxBudgetController,
                    style: const TextStyle(color: Colors.grey),
                    cursorColor: Colors.grey,
                    textInputAction: TextInputAction.next,
                    decoration: inputDecoCoin("0"),
                    onChanged: (value) => setState(() => maxBudgetController.text = value),
                    validator: (value) {
                      final minimumBudget = minBudgetController.text;
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
      birthDateController.text = inputFormat.format(dateTime);
    }
  }

  Widget radiusCard(String radius) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(0, 0, 0, 0.2)),
        borderRadius: BorderRadius.circular(14.0),
        color: (widget.currentUser.userModel.userSignupProfileModel.radius != radius)
            ? const Color.fromRGBO(245, 247, 251, 1)
            : const Color.fromRGBO(190, 212, 255, 1),
      ),
      child: Stack(
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            child: SizedBox(
              width: (widget.currentUser.userModel.userSignupProfileModel.radius != radius) ? radiusWidth.toDouble() : radiusExpandedWidth.toDouble(),
              height: 40,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Center(
                  child: Text(
                    "+$radius",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      leadingDistribution: TextLeadingDistribution.even,
                      foreground: (widget.currentUser.userModel.userSignupProfileModel.radius != radius)
                          ? (Paint()..color = const Color.fromRGBO(101, 101, 107, 1))
                          : (Paint()..shader = CustomGradient().blueGradient().createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0))),
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    widget.currentUser.userModel.userSignupProfileModel.radius = radius;
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

  InputDecoration inputDecoCoin(String hint) {
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
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w300),
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

  showAlertImageDialog(BuildContext context) {  
    Widget okButton = ElevatedButton(  
      child: const Text("OK"),  
      onPressed: () {  
        Navigator.of(context).pop();  
      },  
    );  
    
    AlertDialog alert = AlertDialog(  
      title: const Text("Upload Images"),  
      content: const Text("Please Upload at least 1 profile image"),  
      actions: [  
        okButton,  
      ],  
    );
    
    showDialog(  
      context: context,  
      builder: (BuildContext context) {  
        return alert;  
      },  
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
    return url;
  }

  Future<void> uploadImage(String imageUrl) async {
    try { 
      await FirebaseFirestore.instance.collection('users')
        .doc(auth.currentUser?.uid)
        .collection("profile_images")
        .doc(auth.currentUser?.uid)
        .update({
          'urls': FieldValue.arrayUnion([imageUrl]),
        });
    } catch (e) {
      debugPrint("Error - $e");
    }
  }

  Future<void> addProfileImage(List<dynamic> imageURLS) async {
    try {
      final XFile? profileImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 30,
      );
      if (profileImage != null) {
        String imageUrl = await uploadFile(profileImage);
        await uploadImage(imageUrl);
        imageURLS.add(imageUrl);
      }
    } catch (error) {
      debugPrint("ERROR: $error");
    }
    setState(() {
      
    });
  }

  Future removeFile(String image) async {
    Reference ref = FirebaseStorage.instance.refFromURL(image);
    await ref.storage.refFromURL(image).delete().whenComplete(() {
      setState(() {
        isRemoving = false;
      });
    });
  }

  Future<void> removeUploadedImage(String imageUrl) async {
    try { 
      await FirebaseFirestore.instance.collection('users')
        .doc(auth.currentUser?.uid)
        .collection("profile_images")
        .doc(auth.currentUser?.uid)
        .update({
          'urls': FieldValue.arrayRemove([imageUrl]),
        });
    } catch (e) {
      debugPrint("Error - $e");
    }
  }

  removeProfileImage(int index, List<dynamic> imageUrls) {
    setState(() {
      removeFile(imageUrls[index]);
      removeUploadedImage(imageUrls[index]);
      imageUrls.removeAt(index);
    });
  }

}