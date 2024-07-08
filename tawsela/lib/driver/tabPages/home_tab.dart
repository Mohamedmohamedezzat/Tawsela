import 'dart:async';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:users/passenger/screens/makeTrip.dart';
import 'package:users/passenger/screens/search_places_driver.dart';

import '../../Assistants/black_theme_google_map.dart';
import '../../driver/Assistants/assistant_methods.dart';
import '../../passenger/models/directions.dart';
import '../../passenger/screens/precise_pickup_location.dart';
import '../../passenger/screens/search_places_screen.dart';
import '../../passenger/widgets/progress_dialog.dart';
import '../Assistants/black_theme_google_map.dart';
import '../global/global_driver.dart';
import '../pushNotification/push_notification_system.dart';
import '../screens/new_trip_screen.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key? key}) : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {

  GoogleMapController? newGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  var geoLocator = Geolocator();

  LocationPermission? _locationPermission;

  String? statusText;
  Color? buttonColor;
  bool? isDriverActive;
  Directions destination = Directions();
  Directions pickUp = Directions();
  Set<Marker> markersSet = {};

  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();
    if(_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  locateDriverPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    driverCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 15);

    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    // String humanReadableAddress = await AssistantMethods.searchAddressForGeographicCoOrdinates(driverCurrentPosition!, context);
    // print("This is our address = " + humanReadableAddress);
    //
    // AssistantMethods.readDriverRatings(context);
  }


  @override
  void initState() {
    super.initState();
  }
  Set<Polyline> polylineSet = {};
  List<LatLng> pLineCoOrdinatesList = [];
  Set<Circle> circlesSet = {};

  @override
  Widget build(BuildContext context) {

    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Stack(
      children: [
        GoogleMap(
          padding: EdgeInsets.only(top: 40 , bottom: 130),
          mapType: MapType.normal,
          myLocationEnabled: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
          initialCameraPosition: _kGooglePlex,
          polylines: polylineSet,
          markers: markersSet,
          circles: circlesSet,

          onMapCreated: (GoogleMapController controller){
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;

            if(darkTheme == true){
              setState(() {
                blackThemeGoogleMap(newGoogleMapController);
              });
            }

            locateDriverPosition();
          },
        ),

        Container(
          child: Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 50, 10, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    // padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Color(0xFF3C4650),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: Color(0xFFEB9042)
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: (){
                                           Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (c) =>
                                                      SearchPlacesDriver(callback: (data) {
                                                        setState(() {
                                                          pickUp = data;
                                                        });
                                                        if(destination.locationName!=null){
                                                          showBottomOrder(context);
                                                        }
                                                      },)));
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            // Text(
                                            //   "From",
                                            //   style: TextStyle(
                                            //     color: darkTheme
                                            //         ? Colors.amber.shade400
                                            //         : Colors.blue,
                                            //     fontSize: 16,
                                            //     fontWeight: FontWeight.bold,
                                            //   ),
                                            // ),
                                            Text(
                                              pickUp.locationName!=null?pickUp.locationName.toString():"Not Getting Address",
                                              style: TextStyle(
                                                  color: Color(0xFFfdf9eb),
                                                  fontSize: 16),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Divider(
                                height: 1,
                                thickness: 0.5,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: InkWell(
                                  onTap: ()  {
                                    //go to search places screen
                                    // var responseFromSearchScreen =
                                    // await
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (c) =>
                                                SearchPlacesDriver(callback: (data) {
                                                  setState(() {
                                                    destination = data;
                                                  });
                                                  if(pickUp.locationName!=null){
                                                    print("ZZZZZz");
                                                    // Navigator.pop(context);
                                                    Timer(Duration(seconds: 1), () {
                                                      drawPolyLineFromOriginToDestination();
                                                      // showBottomOrder(context);

                                                    });
                                                    Timer(Duration(seconds: 2), () {
                                                      // drawPolyLineFromOriginToDestination();
                                                      showBottomOrder(context);

                                                    });
                                                  }
                                                },)));

                                    // if (responseFromSearchScreen ==
                                    //     "obtainedDropoff") {
                                    //   setState(() {
                                    //     openNavigationDrawer = false;
                                    //   });
                                    // }
                                    //
                                    // await drawPolyLineFromOriginToDestination(
                                    //     darkTheme);
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                          Icons.location_on_outlined,
                                          color: Color(0xFFEB9042)
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            // Text(
                                            //   "To",
                                            //   style: TextStyle(
                                            //     color: darkTheme
                                            //         ? Colors.amber.shade400
                                            //         : Colors.blue,
                                            //     fontSize: 12,
                                            //     fontWeight: FontWeight.bold,
                                            //   ),
                                            // ),
                                            Text(
                                             destination.locationName!=null?
                                             destination.locationName.toString():"Where to?",
                                              style: TextStyle(
                                                  color: Color(0xFFfdf9eb),
                                                  fontSize: 16),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),

      ],
    );
  }

  driverIsOnlineNow() async {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    driverCurrentPosition = pos;

    Geofire.initialize("activeDrivers");
    Geofire.setLocation(currentUser!.uid, driverCurrentPosition!.latitude, driverCurrentPosition!.longitude).then((_) {
      print("Driver location saved successfully.");
    }).catchError((error) {
      print("Error saving driver location: $error");
    });

    // //CarType
    // DatabaseReference carTypeRef = FirebaseDatabase.instance.ref().child("activeDrivers").child(currentUser!.uid).child("type");
    // carTypeRef.set(carModelCurrentInfo!.type).then((_) {
    //   print("Car type data saved successfully.");
    // }).catchError((error) {
    //   print("Error saving car type data: $error");
    // });

    //NewRideStatus
    DatabaseReference ref = FirebaseDatabase.instance.ref().child("drivers").child(currentUser!.uid).child("newRideStatus");

    ref.set("idle");
    ref.onValue.listen((event) { });

    //Status
    FirebaseDatabase.instance.ref().child("drivers").child(currentUser!.uid).child("status").set("online");
  }

  updateDriversLocationAtRealTime() {
    streamSubscriptionPosition = Geolocator.getPositionStream().listen((Position position) {
      if(isDriverActive == true){
        Geofire.setLocation(currentUser!.uid, driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
      }

      LatLng latLng = LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);

      newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  driverIsOfflineNow() {
    Geofire.removeLocation(currentUser!.uid);

    DatabaseReference? ref = FirebaseDatabase.instance.ref().child("drivers").child(currentUser!.uid).child("newRideStatus");

    FirebaseDatabase.instance.ref().child("drivers").child(currentUser!.uid).child("status").set("offline");

    ref.onDisconnect();
    ref.remove();
    ref = null;

    // Future.delayed(Duration(milliseconds: 2000), () {
    //   SystemChannels.platform.invokeMethod("SystemNavigator.pop");
    // });
  }
  showLoaderDialog(BuildContext context) {
    showGeneralDialog(context: context,
        barrierDismissible: false,

        pageBuilder: (_, __, ___) {
          return Align(
            alignment: Alignment.center,
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                margin: EdgeInsets.all(20),
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)
                ),
                padding: EdgeInsets.symmetric(horizontal: 24,vertical: 12),
                child: Column(
                  children: [
                    SizedBox(width: 24,),
                    Text("Signing In...",
                      style: TextStyle(fontSize: 18, color: Colors.green
                      ),)
                    , SizedBox(height: 24,),
                    SizedBox(
                      width: 140,
                      height: 4,
                      child: LinearProgressIndicator(
                        color: Colors.green,
                      ),
                    )

                  ],),
              ),
            ),
          );
        });
  }

  showBottomOrder(BuildContext context){
    showModalBottomSheet(context: context, builder: (context) {
      return MakeTrip(pickUp: pickUp, destination: destination);

      //   StatefulBuilder(builder: (
      //     BuildContext context, void Function(void Function()) setState) {
      //
      //   return SizedBox(
      //     height: double.infinity,
      //     child: Container(
      //       color: Colors.white,
      //       padding: EdgeInsets.symmetric(horizontal: 12),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Container(
      //             decoration: BoxDecoration(
      //                 borderRadius: BorderRadius.circular(10),
      //                 color: Colors.white
      //             ),
      //             child: Column(
      //               children: [
      //                 Padding(
      //                   padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 4),
      //                   child: Row(
      //                     children: [
      //                       Icon(Icons.clear,size: 24,color: Colors.red,),
      //                       SizedBox(width: 12,),
      //                       Text(
      //                         "Make a public trip",
      //                         style: TextStyle(
      //                           color: Colors.black54,
      //                           fontSize: 20,
      //                           fontWeight: FontWeight.bold,
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //                 SizedBox(height: 12,),
      //                 Container(
      //                   padding: EdgeInsets.all(10),
      //                   decoration: BoxDecoration(
      //                     color:Colors.white,
      //                     borderRadius: BorderRadius.circular(10),
      //                   ),
      //                   child: Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Text(
      //                         "From",
      //                         style: TextStyle(
      //                           color: Colors.black54,
      //                           fontSize: 16,
      //                           fontWeight: FontWeight.bold,
      //                         ),
      //                       ),
      //                       Padding(
      //                         padding: EdgeInsets.all(5),
      //                         child: Row(
      //                           children: [
      //                             Icon(
      //                               Icons.location_on_outlined,
      //                               color:  Colors.blue,
      //                             ),
      //                             SizedBox(
      //                               width: 10,
      //                             ),
      //                             Expanded(
      //                               child: Column(
      //                                 crossAxisAlignment:
      //                                 CrossAxisAlignment.start,
      //                                 children: [
      //                                   // Text(
      //                                   //   "From",
      //                                   //   style: TextStyle(
      //                                   //     color: darkTheme
      //                                   //         ? Colors.amber.shade400
      //                                   //         : Colors.blue,
      //                                   //     fontSize: 16,
      //                                   //     fontWeight: FontWeight.bold,
      //                                   //   ),
      //                                   // ),
      //                                   Text(
      //                                     pickUp.locationName!=null?pickUp.locationName.toString():"Not Getting Address",
      //                                     style: TextStyle(
      //                                         color: Colors.black,
      //                                         fontSize: 16),
      //                                   )
      //                                 ],
      //                               ),
      //                             )
      //                           ],
      //                         ),
      //                       ),
      //                       SizedBox(
      //                         height: 5,
      //                       ),
      //                       Divider(
      //                         height: 1,
      //                         thickness: 2,
      //                         color:Colors.black26,
      //                       ),
      //                       SizedBox(
      //                         height: 5,
      //                       ),
      //                       Text(
      //                         "To",
      //                         style: TextStyle(
      //                           color: Colors.black54,
      //                           fontSize: 16,
      //                           fontWeight: FontWeight.bold,
      //                         ),
      //                       ),
      //                       Padding(
      //                         padding: EdgeInsets.all(5),
      //                         child: Row(
      //                           children: [
      //                             Icon(
      //                               Icons.my_location,
      //                               color:Colors.green,
      //                             ),
      //                             SizedBox(
      //                               width: 10,
      //                             ),
      //                             Expanded(
      //                               child: Column(
      //                                 crossAxisAlignment:
      //                                 CrossAxisAlignment.start,
      //                                 children: [
      //                                   // Text(
      //                                   //   "To",
      //                                   //   style: TextStyle(
      //                                   //     color: darkTheme
      //                                   //         ? Colors.amber.shade400
      //                                   //         : Colors.blue,
      //                                   //     fontSize: 12,
      //                                   //     fontWeight: FontWeight.bold,
      //                                   //   ),
      //                                   // ),
      //                                   Text(
      //                                     destination.locationName!=null?destination.locationName.toString():"Where to?",
      //                                     style: TextStyle(
      //                                         color: Colors.black,
      //                                         fontSize: 16),
      //                                   )
      //                                 ],
      //                               ),
      //                             )
      //                           ],
      //                         ),
      //                       )
      //                     ],
      //                   ),
      //                 ),
      //                 SizedBox(
      //                   height: 12,
      //                 ),
      //                 TextFormField(
      //                   inputFormatters: [
      //                     LengthLimitingTextInputFormatter(100)
      //                   ],
      //                   controller: roadCon,
      //
      //                   decoration: InputDecoration(
      //                     hintText: "the Road taken",
      //                     hintStyle: TextStyle(
      //                       color: Colors.grey,
      //                     ),
      //                     filled: true,
      //                     fillColor:Colors.grey.shade200,
      //                     border: OutlineInputBorder(
      //                         borderRadius: BorderRadius.circular(40),
      //                         borderSide: BorderSide(
      //                           width: 0,
      //                           style: BorderStyle.none,
      //                         )),
      //                     // prefixIcon: Icon(
      //                     //   Icons.map,
      //                     //   color: Colors.grey,
      //                     // ),
      //                   ),
      //
      //                   onChanged: (text) =>
      //                       setState(() {
      //                         roadCon.text = text;
      //                       }),
      //                 ),
      //                 SizedBox(
      //                   height: 12,
      //                 ),
      //                 TextFormField(
      //                   inputFormatters: [
      //                     LengthLimitingTextInputFormatter(100)
      //                   ],
      //                   controller: passengerNoCon,
      //
      //                   decoration: InputDecoration(
      //                     hintText: "Number of Passengers",
      //                     hintStyle: TextStyle(
      //                       color: Colors.grey,
      //                     ),
      //                     filled: true,
      //                     fillColor:Colors.grey.shade200,
      //                     border: OutlineInputBorder(
      //                         borderRadius: BorderRadius.circular(40),
      //                         borderSide: BorderSide(
      //                           width: 0,
      //                           style: BorderStyle.none,
      //                         )),
      //                     // prefixIcon: Icon(
      //                     //   Icons.map,
      //                     //   color: Colors.grey,
      //                     // ),
      //                   ),
      //
      //                   onChanged: (text) =>
      //                       setState(() {
      //                         passengerNoCon.text = text;
      //                       }),
      //                 ),
      //                 SizedBox(height: 48,),
      //                 ElevatedButton(
      //                     style: ElevatedButton.styleFrom(
      //                       foregroundColor:
      //                       Colors.white,
      //                       backgroundColor:  Colors.blue,
      //                       elevation: 0,
      //                       shape: RoundedRectangleBorder(
      //                         borderRadius: BorderRadius.circular(32),
      //                       ),
      //                       minimumSize: Size(double.infinity, 50),
      //                     ),
      //                     onPressed: () {
      //                       var userId = FirebaseAuth.instance.currentUser!.uid.toString();
      //                       print("SSSSSSSSSSSSSSS ${passengerNoCon.text}");
      //                     },
      //                     child: Text(
      //                       'Post Trip',
      //                       style: TextStyle(
      //                         fontSize: 20,
      //                       ),
      //                     )),
      //                 SizedBox(height: 24,),
      //               ],
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   );
      // },
      //
      // );
    },);
  }


  Future<void> drawPolyLineFromOriginToDestination() async {
    // var originPosition =
    //     Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    // var destinationPosition =
    //     Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    var originLatLng = LatLng(
        pickUp.locationLatitude!, pickUp.locationLongitude!);
    var destinationLatLng = LatLng(destination.locationLatitude!,
        destination.locationLongitude!);

    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Please wait...",
      ),
    );

    var directionDetailsInfo =
    await AssistantMethods.obtainOriginToDestinationDirectionDetails(
        originLatLng, destinationLatLng);
    // setState(() {
    //   tripDirectionDetailsInfo = directionDetailsInfo;
    // });

    Navigator.pop(context);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodePolyLinePointsResultList =
    pPoints.decodePolyline(directionDetailsInfo.e_points!);

    pLineCoOrdinatesList.clear();

    if (decodePolyLinePointsResultList.isNotEmpty) {
      decodePolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
        pLineCoOrdinatesList
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polylineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color:  Colors.blue,
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoOrdinatesList,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
        width: 5,
      );

      polylineSet.add(polyline);
    });

    LatLngBounds boundsLatLng;
    if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng =
          LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    } else if (originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
      );
    } else if (originLatLng.latitude > destinationLatLng.latitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      boundsLatLng =
          LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }

    newGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));

    Marker originMarker = Marker(
      markerId: const MarkerId("originID"),
      infoWindow:
      InfoWindow(title: pickUp.locationName, snippet: "Origin"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      infoWindow: InfoWindow(
          title: destination.locationName, snippet: "Destination"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      markersSet.add(originMarker);
      markersSet.add(destinationMarker);
    });

    Circle originCircle = Circle(
      circleId: CircleId("originID"),
      fillColor: Colors.green,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatLng,
    );

    Circle destinationCircle = Circle(
      circleId: CircleId("destinationID"),
      fillColor: Colors.red,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: destinationLatLng,
    );

    setState(() {
      circlesSet.add(originCircle);
      circlesSet.add(destinationCircle);
    });
  }

}


















