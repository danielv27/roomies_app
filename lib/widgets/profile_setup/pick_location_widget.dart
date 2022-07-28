import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

import '../gradients/blue_gradient.dart';

class PickLocation extends StatefulWidget {
  const PickLocation({
    Key? key,
    required this.startingLocation,
  }) : super(key: key);

  final LatLng startingLocation;

  @override
  State<PickLocation> createState() => _PickLocationState();
}

class _PickLocationState extends State<PickLocation> {
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  final String googleApikey = "AIzaSyAINUiOOUSfO2E1yyYIENrDnzHwWlwgLpI";
  final Mode mode = Mode.overlay;
  late GoogleMapController googleMapController;
  Set<Marker> markerList = {};

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(target: widget.startingLocation, zoom: 14.0);

    return Scaffold(
      key: homeScaffoldKey,
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
            markers: markerList,
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
            },
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 75.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.6,
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
                  child: const Text("Search a neighborhood"),
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

    displayPrediction(p!, homeScaffoldKey.currentState);
  }

  void _onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  }

  Future<void> displayPrediction(Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
      apiKey: googleApikey,
      apiHeaders: await const GoogleApiHeaders().getHeaders()
    );

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    markerList.clear();
    markerList.add(Marker(
      markerId: const MarkerId("0"), 
      position: LatLng(lat, lng), 
      infoWindow: InfoWindow(title: detail.result.name),
    ));

    setState(() {
      
    });

    googleMapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
  }

}