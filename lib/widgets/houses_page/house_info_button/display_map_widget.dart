import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:roomies_app/models/user_model.dart';

class DisplayNeighborhoodLocation extends StatefulWidget {
  const DisplayNeighborhoodLocation({
    Key? key,
    required this.houseOwner,
  }) : super(key: key);

  final HouseOwner houseOwner;

  @override
  State<DisplayNeighborhoodLocation> createState() => _DisplayNeighborhoodLocationState();
}

class _DisplayNeighborhoodLocationState extends State<DisplayNeighborhoodLocation> {
  final String googleApikey = "AIzaSyAINUiOOUSfO2E1yyYIENrDnzHwWlwgLpI";
  late GoogleMapController googleMapController;

  @override
  Widget build(BuildContext context) {
    Set<Marker>? markerList = {};

    late LatLng targetLocation;
    if (widget.houseOwner.location == null) {
      targetLocation = const LatLng(52.3676, 4.9041);
    } else {
      targetLocation = widget.houseOwner.location!;
    }

    CameraPosition initialCameraPosition = CameraPosition(target: targetLocation, zoom: 13.0);
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
        bottomLeft: Radius.circular(20),
      ),
      child: GoogleMap(
        initialCameraPosition: initialCameraPosition, 
        mapType: MapType.normal, 
        compassEnabled: false,
        mapToolbarEnabled: false,
        markers: markerList,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
      ),
    );
  }
}