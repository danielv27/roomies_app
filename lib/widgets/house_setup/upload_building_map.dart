import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:roomies_app/models/house_profile_images.dart';

class UploadBuildingMap extends StatefulWidget {
  UploadBuildingMap({
    Key? key,
    required this.houseMapFiles,
    required this.currentUserID,
  }) : super(key: key);

  final HouseMapFiles houseMapFiles;
  final String currentUserID;

  @override
  State<UploadBuildingMap> createState() => _UploadBuildingMapState();
}

class _UploadBuildingMapState extends State<UploadBuildingMap> {
  final List<XFile> selectedHouseMaps = [];
  int uploadItem = 0;
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await selectHouseMaps();
        await uploadFunction(selectedHouseMaps);
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
                      "Building Map",
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
              Image.asset("assets/icons/upload-building-map.png", width: 42, height: 42.77),
            ],
          ),
        ),
      ),
    );
  }

  Future selectHouseMaps() async{
    try {
      final List<XFile>? houseMaps = await ImagePicker().pickMultiImage(
        imageQuality: 50,
      );
      if (houseMaps != null) {
        selectedHouseMaps.addAll(houseMaps);
      }
    } catch (error) {
      debugPrint("ERROR: $error");
    }
    setState(() {
      
    });
  }

  Future<void> uploadFunction(List<XFile> houseMaps) async {
    setState(() {
      isUploading = true;
    });
    for (int i = 0; i < houseMaps.length; i++) {
      var fileUrl = await uploadFile(houseMaps[i]);
      widget.houseMapFiles.mapURLS!.add(fileUrl);
    }
  }

  Future<String> uploadFile(XFile houseMap) async {
    Reference reference = FirebaseStorage.instance.ref().child("house_map").child(widget.currentUserID).child(houseMap.name);
    UploadTask uploadTask = reference.putFile(File(houseMap.path));
    await uploadTask.whenComplete(() {
      setState(() {
        uploadItem++;
        if (uploadItem == selectedHouseMaps.length) {
          isUploading = false;
          uploadItem = 0;
        }    
      });
    });
    var url = await reference.getDownloadURL();
    return url;
  }


}