import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../Assistants/assistant_methods.dart';
import '../global/map_key.dart';
import '../infoHandler/info_passenger.dart';
import '../models/directions.dart';

typedef DataCallback = void Function(Directions data);

class PrecisePickUpDriver extends StatefulWidget {
  // const PrecisePickUpDriver({Key? key}) : super(key: key);
  DataCallback  callback;
  PrecisePickUpDriver({
    required this.callback
  });
  @override
  State<PrecisePickUpDriver> createState() => _precisePickUpDriver();
}

class _precisePickUpDriver extends State<PrecisePickUpDriver> {

  LatLng? pickLocation;
  loc.Location location = loc.Location();
  String? _address;

  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  Position? userCurrentPosition;
  double bottomPaddingOfMap = 0;
  Directions userPickUpAddress = Directions();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  locateUserPosition() async {
    Position cPostion = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPostion;

    LatLng latLngPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 15);

    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress = await AssistantMethods.searchAddressForGeographicCoOrdinates(userCurrentPosition!, context);

  }

  getAddressFromLatLng() async {
    try {
      GeoData data = await Geocoder2.getDataFromCoordinates(
          latitude: pickLocation!.latitude,
          longitude: pickLocation!.longitude,
          googleMapApiKey: mapKey
      );
      setState(() {
        userPickUpAddress.locationLatitude = pickLocation!.latitude;
        userPickUpAddress.locationLongitude = pickLocation!.longitude;
        userPickUpAddress.locationName = data.address;

        // Provider.of<AppInfo>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);

        // _address = data.address;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(top: 100, bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller){
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              setState(() {
                bottomPaddingOfMap = 50;
              });

              locateUserPosition();
            },
            onCameraMove: (CameraPosition? position){
              if(pickLocation != position!.target){
                setState(() {
                  pickLocation = position.target;
                });
              }
            },
            onCameraIdle: () {
              getAddressFromLatLng();
            },
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(top: 60, bottom: bottomPaddingOfMap),
              child: Image.asset("images/pick.png",height: 45, width: 45,),
            ),
          ),

          // Positioned(
          //   top: 40,
          //   right: 20,
          //   left: 20,
          //   child: Container(
          //     decoration: BoxDecoration(
          //       border: Border.all(color: Colors.black),
          //       color: Colors.white,
          //     ),
          //     padding: EdgeInsets.all(20),
          //     child: Text(
          //       userPickUpAddress.locationName != null
          //           ? userPickUpAddress.locationName!
          //           // .substring(0, 24) + "..."
          //           : "Not Getting Address",
          //       //: (_address!).substring(0,24) + "...",
          //       overflow: TextOverflow.visible, softWrap: true,
          //     ),
          //   ),
          // ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white
                ),
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        userPickUpAddress.locationName != null
                            ? userPickUpAddress.locationName!
                        // .substring(0, 24) + "..."
                            : "Not Getting Address",
                        //: (_address!).substring(0,24) + "...",
                        overflow: TextOverflow.visible, softWrap: true,style: TextStyle(
                        fontSize: 16
                      ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height:44,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      widget.callback(userPickUpAddress);
                                    });
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: darkTheme ? Colors.amber.shade400 : Colors.blue,
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    )
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Save this location"),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12,),
                          InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey.shade200
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Icon(Icons.clear,size: 26,),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
