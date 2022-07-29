import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

import '../gradients/blue_gradient.dart';

class PickLocation extends StatefulWidget {
  PickLocation({
    Key? key,
    required this.startingLocation,
    required this.latLngController,
    required this.markerList,
  }) : super(key: key);

  final LatLng startingLocation;
  final TextEditingController latLngController;
  late final Set<Marker>? markerList;

  @override
  State<PickLocation> createState() => _PickLocationState();
}

class _PickLocationState extends State<PickLocation> {
  final String googleApikey = "AIzaSyAINUiOOUSfO2E1yyYIENrDnzHwWlwgLpI";
  final Mode mode = Mode.overlay;
  late GoogleMapController googleMapController;

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(target: widget.startingLocation, zoom: 14.0);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: Container(
          decoration: BoxDecoration(
            gradient: blueGradient()
          ),
          child: AppBar(
            title: const Text("Pick a location"),
            systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            toolbarHeight: 75,
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialCameraPosition, 
            mapType: MapType.normal, 
            markers: widget.markerList!,
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
            },
            onTap: addMarker,
            onLongPress: addMarker,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 130.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                  gradient: blueGradient(),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: ElevatedButton(
                  onPressed: pickPlace,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ), 
                  child: const Text("Pick a location"),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 75.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                  gradient: blueGradient(),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    if (widget.markerList!.isNotEmpty) {
                      Navigator.of(context).pop();
                    } else {
                      await alertLocationNotPicked(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ), 
                  child: const Text("Continue"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> pickPlace() async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context, 
      apiKey: googleApikey, 
      mode: mode, 
      language: 'en', 
      onError: _onError,
      types: [""],
      strictbounds: false,
      decoration: InputDecoration(
        hintText: "Search", 
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20), 
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
      components: [Component(Component.country, "nl")],
    );

    displayPrediction(p!);
  }

  void _onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  }

  Future<void> displayPrediction(Prediction p) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
      apiKey: googleApikey,
      apiHeaders: await const GoogleApiHeaders().getHeaders()
    );

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    widget.markerList!.clear();
    widget.markerList!.add(Marker(
      markerId: const MarkerId("0"), 
      position: LatLng(lat, lng), 
      infoWindow: InfoWindow(title: detail.result.name),
    ));

    setState(() {
      widget.latLngController.text = "$lat, $lng";
    });

    googleMapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
  }

  void addMarker(LatLng argument) {
    widget.markerList!.clear();
    widget.markerList!.add(Marker(
      markerId: const MarkerId("0"), 
      position: LatLng(argument.latitude, argument.longitude), 
    ));

    setState(() {
      widget.latLngController.text = "${argument.latitude}, ${argument.longitude}";
    });

    googleMapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(argument.latitude, argument.longitude), 14.0));
  }

  Future<dynamic> alertLocationNotPicked(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context){
        return const AlertDialog(
          title: Text("Location not picked"),
          content: Text("Please pick a location to continue"),
        );
      }
    );
  }

}