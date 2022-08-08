import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:roomies_app/models/house_profile_images.dart';

class UploadHousePictures extends StatefulWidget {
  UploadHousePictures({
    Key? key,
    required this.houseProfileImages,
    required this.currentUserID,
  }) : super(key: key);

  final HouseProfileImages houseProfileImages;
  final String currentUserID;

  @override
  State<UploadHousePictures> createState() => _UploadHousePicturesState();
}

class _UploadHousePicturesState extends State<UploadHousePictures> {
  final List<XFile> selectedHouseImages = [];
  int uploadItem = 0;
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await selectHouseImages();
        await uploadFunction(selectedHouseImages);
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
                  children: const [
                    Text(
                      "Upload",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w300
                      ),
                    ),
                    SizedBox(height: 6,),
                    Text(
                      "Pictures",
                      style: TextStyle(
                        color: Color.fromRGBO(51, 51, 51, 1),
                        fontSize: 23,
                        fontWeight: FontWeight.w600
                      ),
                    )
                  ],
                ),
              ),
              const Spacer(),
              Image.asset("assets/icons/upload-house-images.png", width: 42, height: 42.77),
            ],
          ),
        ),
      ),
    );
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
    Reference reference = FirebaseStorage.instance.ref().child("house_images").child(widget.currentUserID).child(houseImage.name);
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


}