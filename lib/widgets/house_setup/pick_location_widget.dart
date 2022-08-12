import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:roomies_app/widgets/gradients/gradient.dart';

class PickLocation extends StatefulWidget {
  const PickLocation({
    Key? key,
    required this.startingLocation,
    required this.latLngController,
    required this.postalCodeController,
    required this.houseNumberController,
    required this.streetNameController,
    required this.cityNameController,
    required this.markerList,
  }) : super(key: key);

  final LatLng startingLocation;

  final TextEditingController latLngController;
  final TextEditingController postalCodeController;
  final TextEditingController houseNumberController;
  final TextEditingController streetNameController;
  final TextEditingController cityNameController;

  final Set<Marker>? markerList;

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
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: Container(
          decoration: BoxDecoration(
            gradient: CustomGradient().blueGradient(),
          ),
          child: AppBar(
            title: const Text("Pick a location"),
            titleSpacing: 0,
            systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            toolbarHeight: 75,
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.search,
                    size: 40,
                  ),
                  onPressed: pickPlace,
                ),
              ),
            ],
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
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 75.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                  gradient: widget.markerList!.isNotEmpty? CustomGradient().blueGradient() : null,
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
                    primary: widget.markerList!.isNotEmpty? Colors.transparent : Colors.grey,
                    shadowColor: widget.markerList!.isNotEmpty? Colors.transparent : Colors.grey,
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
      logo: const Text(""),
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
    ));

    String? houseNumber;
    String? streetName;
    String? cityName;
    String? zipCode;
    final locationDetails = detail.result.addressComponents;
    for (var locationType in locationDetails) {
      switch (locationType.toJson()['types'][0].toString()) {
        case "street_number":
          houseNumber = locationType.toJson()['long_name'];
          break;
        case "postal_code":
          zipCode = locationType.toJson()['long_name'];
          break;
        case "route":
          streetName = locationType.toJson()['long_name'];
          break;
        case "administrative_area_level_2":
          cityName = locationType.toJson()['long_name'];
          break;
      }
    }

    zipCode = zipCode!.replaceAll(' ', '');

    setState(() {
      widget.latLngController.text = "$lat, $lng";
      widget.houseNumberController.text = houseNumber!;
      widget.postalCodeController.text = zipCode!;
      widget.streetNameController.text = streetName!;
      widget.cityNameController.text = cityName!;
    });

    googleMapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
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