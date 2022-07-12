import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:roomies_app/models/user_profile_model.dart';

import '../../models/user_profile_images.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({
    Key? key,
    required this.aboutMeController, 
    required this.workController, 
    required this.studyController, 
    required this.roomMateController, 
    required this.birthDateController,
    required this.userProfileImages,
  }) : super(key: key);

  final TextEditingController aboutMeController;
  final TextEditingController workController;
  final TextEditingController studyController;
  final TextEditingController roomMateController;
  final TextEditingController birthDateController;
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
  final FirebaseStorage storageRef = FirebaseStorage.instance;
  final List<String> arrImageUrls = [];
  int uploadItem = 0;
  bool isUploading = false;

  final FirebaseAuth auth = FirebaseAuth.instance;

  final List<Map> myProfileImage = List.generate(6, (index) => {"profile_image_": index, "name": "ProfileImage $index"}).toList();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                          decoration: applyBlueGradient(),
                          child: FloatingActionButton(
                            elevation: 0,
                            onPressed: () async { 
                              await selectProfileImage();
                              uploadFunction(selectedProfileImages);
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
                          decoration: applyBlueGradient(),
                          child: FloatingActionButton(
                            elevation: 0,
                            onPressed: () { 
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
              decoration: applyInputDecoration(aboutMeDescription)
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
              decoration: applyInputDecoration(workDescription)
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
              decoration: applyInputDecoration(studyDescription)
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
              decoration: applyInputDecoration(roomMateDescription)
            ),
            const SizedBox(height: 30,),
            textLabel("MY DATE OF BIRTH"),
            const SizedBox(height: 10,),
            TextField(
              controller: widget.birthDateController,
              style: const TextStyle(color: Colors.grey),
              cursorColor: Colors.grey,
              textInputAction: TextInputAction.next,
              decoration: applyInputDecoration(birthDateDescription)
            ),
            const SizedBox(height: 30,),
          ],
        ),
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

  BoxDecoration applyBlueGradient() {
    return const BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color.fromRGBO(0, 53, 190, 1), Color.fromRGBO(57, 103, 224, 1), Color.fromRGBO(117, 154, 255, 1)]
      )
    );
  }

  Widget showLoading() {
    return Center(
      child: Column(
        children: const [
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  void uploadFunction(List<XFile> _images) {
    setState(() {
      isUploading = true;
    });
    for (int i = 0; i < _images.length; i++) {
      var imageUrl = uploadFile(_images[i]);
      arrImageUrls.add(imageUrl.toString());
    }
  }

  Future<String> uploadFile(XFile _image) async {
    Reference reference = storageRef.ref().child("profile_images").child(auth.currentUser!.uid.toString()).child(_image.name);
    UploadTask uploadTask = reference.putFile(File(_image.path));
    await uploadTask.whenComplete(() {
      setState(() {
        uploadItem++;
        if (uploadItem == selectedProfileImages.length) {
          isUploading = false;
          uploadItem = 0;
        }    
      });
    });

    var url = await reference.getDownloadURL();
    widget.userProfileImages.imageURLS.add(url);

    return url;
  }

  Future<void> selectProfileImage() async {
    try {
      final XFile? profileImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (profileImage != null) {
        selectedProfileImages.add(profileImage);
      }
    } catch (e) {
      print("error" + e.toString());
    }
    setState(() {
      
    });
  }

  removeProfileImage(int index) {
    setState(() {
      selectedProfileImages.removeAt(index);
    });
  }

}
