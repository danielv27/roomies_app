import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'pick_location_widget.dart';

class GoogleApiContainer extends StatefulWidget {
  const GoogleApiContainer({
    Key? key,
    required this.latLngController,
  }) : super(key: key);

  final TextEditingController latLngController;

  @override
  State<GoogleApiContainer> createState() => _GoogleApiContainerState();
}

class _GoogleApiContainerState extends State<GoogleApiContainer> {
  LatLng startLocation = const LatLng(52.3676, 4.9041); 
  Set<Marker> markerList = {};

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        bool isPremissionGranted = await askPermission();
        if (isPremissionGranted) {
          showPlacePicker(startLocation);
        } else {
          await askPermission();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15.0),
        child: Container(
          margin: const EdgeInsets.only(bottom: 15.0),
          height: 100,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(238, 238, 238, 1),
            borderRadius: BorderRadius.circular(14.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.0),
                    color: Colors.white,
                  ),
                  child: Image.asset("assets/icons/Blue-location.png",
                    height: 15,
                    width: 15,
                  ),
                ),
                const SizedBox(width: 14,),
                const Expanded(
                  child: Text(
                    "Zoek naar plaatsen, buurten etc.",
                    style: TextStyle(
                      color:Colors.black,
                      height: 1.5,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 3,
                  ),
                ),
                const SizedBox(width: 10,),
                const Icon(Icons.arrow_forward_ios)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showPlacePicker(startingLocation) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return PickLocation(startingLocation: startingLocation, latLngController: widget.latLngController, markerList: markerList);
        }
      ),
    );
  }

  Future<bool> askPermission() async{
    PermissionStatus status = await Permission.location.request();
    if(status.isDenied) {
      if (await Permission.location.isPermanentlyDenied) {
        openAppSettings();
      }
      return false;
    } else {
      return true;
    }
  }

}