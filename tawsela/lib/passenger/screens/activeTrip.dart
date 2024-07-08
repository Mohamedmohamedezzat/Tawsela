import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:users/models/uploadTrip.dart';
import 'dart:ui' as ui;

import '../../Assistants/assistant_methods.dart';
import '../../widgets/progress_dialog.dart';
import '../models/directions.dart';

class ActiveTrip extends StatefulWidget{


  @override
  State<ActiveTrip> createState() =>_activeTrip();

}

class _activeTrip extends State<ActiveTrip>{

  Map tripsValue = {};
  Map usersValue = {};
  String activeTrip = "";
  Set<Polyline> polylineSet = {};
  List<LatLng> pLineCoOrdinatesList = [];
  Set<Circle> circlesSet = {};
  Set<Marker> markersSet = {};

  GoogleMapController? newGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();


  @override
  void initState() {
    var userId = FirebaseAuth.instance.currentUser!.uid.toString();

    FirebaseDatabase.instance.ref("users").onValue.listen((event) {
      if(event.snapshot.exists){
        Map o = event.snapshot.value as Map;
        if(mounted){
          setState(() {
            usersValue = o;
          });
        }
      }
    });

  FirebaseDatabase.instance.ref("users").child(userId).onValue.listen((event) {
      if(event.snapshot.exists){
        Map o = event.snapshot.value as Map;
        var active = o.containsKey("activeTrip")?o["activeTrip"]:{};
        if(mounted){
          setState(() {
            activeTrip = active;
          });
        }
      }
    });

    FirebaseDatabase.instance.ref("trips").onValue.listen((event) {
      if(event.snapshot.exists){
        Map o = event.snapshot.value as Map;
        if(mounted){
          setState(() {
            tripsValue = o;
          });
        }
      }
    });
  }

  // locateDriverPosition() async {
  //   Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   driverCurrentPosition = cPosition;
  //
  //   LatLng latLngPosition = LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
  //   CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 15);
  //
  //   newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  //
  //   String humanReadableAddress = await AssistantMethods.searchAddressForGeographicCoOrdinates(driverCurrentPosition!, context);
  //   print("This is our address = " + humanReadableAddress);
  //
  //   AssistantMethods.readDriverRatings(context);
  // }

  var drawn = false;
  @override
  Widget build(BuildContext context) {
    Map tripValue = tripsValue.containsKey(activeTrip)?tripsValue[activeTrip]:{};
    var fromName = tripValue.containsKey("fromName")?tripValue["fromName"]:"";
    var state = tripValue.containsKey("state")?tripValue["state"]:"";
    var toName = tripValue.containsKey("toName")?tripValue["toName"]:"";
    var fromLongtude = tripValue.containsKey("fromLongtude")?tripValue["fromLongtude"]:"";
    var toLongtude = tripValue.containsKey("toLongtude")?tripValue["toLongtude"]:"";
    var fromLatitude = tripValue.containsKey("fromLatitude")?tripValue["fromLatitude"]:"";
    var toLatitude = tripValue.containsKey("toLatitude")?tripValue["toLatitude"]:"";
    Map requestsValue = tripValue.containsKey("requests")?tripValue["requests"]:{};
    var road = tripValue.containsKey("road")?tripValue["road"]:"";
    List stops = tripValue.containsKey("stops")?tripValue["stops"]:[];
    var passenger = tripValue.containsKey("passenger")?tripValue["passenger"]:"";
    List requests = [];
    List acceptedRequests = [];
    requestsValue.forEach((key, value) {
      Map v = requestsValue.containsKey(key)?requestsValue[key]:{};
      var state = v.containsKey("state")?v["state"]:"";
      if(state == "pending"|| state == "refused"){
        requests.add(key);
      }
    });
    requestsValue.forEach((key, value) {
      Map v = requestsValue.containsKey(key)?requestsValue[key]:{};
      var state = v.containsKey("state")?v["state"]:"";
      if(state == "accept"){
        acceptedRequests.add(key);
      }
    });
    if(activeTrip.isNotEmpty&&!drawn){
      drawPolyLineFromOriginToDestination(fromLongtude,fromLatitude,toLongtude,
          toLatitude,stops,fromName,toName);
      setState(() {
        drawn = true;
      });
    }
    return Scaffold(
      backgroundColor:  Color(0xFFfdf9eb),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            SizedBox(height: 32,),
            Container(
              padding: EdgeInsets.all(12),
              child: Row(
                children:  [
                  // InkWell(
                  //   onTap: (){
                  //     Navigator.pop(context);
                  //   },
                  //   child: Padding(
                  //     padding: EdgeInsets.all(8.0),
                  //     child: Icon(Icons.arrow_back_ios,color: Colors.black,),
                  //   ),
                  // ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Active Trip',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:Colors.black54,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(state,textAlign: TextAlign.center,style: TextStyle(
                            color: Colors.green,fontSize: 18
                        ),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: state!="Complete",
              child: InkWell(
                onTap: (){
                  if(state == "active"){
                    FirebaseDatabase.instance.ref("trips").child(activeTrip).child("state").set("onRoad");
                  }else if(state == "onRoad"){
                    FirebaseDatabase.instance.ref("trips").child(activeTrip).child("state").set("Complete").then((value){
                      FirebaseDatabase.instance.ref("users").child(FirebaseAuth.instance.currentUser!.uid.toString()).child("activeTrip").remove();
                    });

                  }else if(state == "complete"){
                    // FirebaseDatabase.instance.ref("trips").child(activeTrip).child("state").set("onRoad");

                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.green.shade100
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        state == "active"?'mark as onRoad':state == "onRoad"?"Mark as Complete":"",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color:Colors.black54,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            activeTrip.isEmpty?Center(
              child:   Padding(
                padding: const EdgeInsets.symmetric(vertical: 80.0),
                child: Text(
                  "There is no Active Trip",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ):Expanded(
              child: Column(
              children: [
                Visibility(
                  visible: activeTrip.isNotEmpty,
                  child: SizedBox(
                    height: 320,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: GoogleMap(
                        padding: EdgeInsets.only(top: 40),
                        mapType: MapType.normal,
                        myLocationEnabled: true,
                        zoomGesturesEnabled: true,
                        zoomControlsEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(double.parse(fromLatitude.toString()),
                              double.parse(fromLongtude.toString())),
                          zoom: 12.4746,
                        ),
                        polylines: polylineSet,
                        markers: markersSet,
                        circles: circlesSet,

                        onMapCreated: (GoogleMapController controller){
                          _controllerGoogleMap.complete(controller);
                          newGoogleMapController = controller;

                          // if(darkTheme == true){
                          //   setState(() {
                          //     blackThemeGoogleMap(newGoogleMapController);
                          //   });
                          // }

                          // locateDriverPosition();
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFF3C4650),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 12,),
                            Container(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: Color(0xFFEB9042),
                                        size: 40,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: [
                                            Text(
                                              "From",
                                              style: TextStyle(
                                                color:
                                                Color(0xFF808080),
                                                fontSize: 18,
                                                fontWeight:
                                                FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              fromName.toString(),
                                              style: TextStyle(
                                                  color: Color(
                                                      0xFFfdf9eb),
                                                  fontSize: 18),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: Color(0xFFEB9042),
                                        size: 40,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: [
                                            Text(
                                              "To",
                                              style: TextStyle(
                                                color:
                                                Color(0xFF808080),
                                                fontSize: 18,
                                                fontWeight:
                                                FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              toName.toString(),
                                              style: TextStyle(
                                                  color: Color(
                                                      0xFFfdf9eb),
                                                  fontSize: 18),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.grey,
                              // Customize the color
                              thickness: 1.0,
                              // Adjust the thickness
                              indent: 10.0,
                              // Add indentation from the start
                              endIndent: 16.0,
                              height: 30,
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  "images/road.png",
                                  scale: 1.6,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Road ",
                                      style: TextStyle(
                                        color: Color(0xFF808080),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      road.toString(),
                                      style: TextStyle(
                                          color: Color(0xFFfdf9eb),
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.grey,
                              // Customize the color
                              thickness: 1.0,
                              // Adjust the thickness
                              indent: 10.0,
                              // Add indentation from the start
                              endIndent: 16.0,
                              height: 30,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.payment,
                                  color: Color(0xFFEB9042),
                                  size: 40,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Payment Method ",
                                      style: TextStyle(
                                        color: Color(0xFF808080),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      road.toString(),
                                      style: TextStyle(
                                          color: Color(0xFFfdf9eb),
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.grey,
                              // Customize the color
                              thickness: 1.0,
                              // Adjust the thickness
                              indent: 10.0,
                              // Add indentation from the start
                              endIndent: 16.0,
                              height: 30,
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  "images/pin.png",
                                  scale: 2,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  "Stops",
                                  style: TextStyle(
                                    color: Color(0xFF808080),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            ListView.builder(
                              padding:
                              EdgeInsets.symmetric(horizontal: 2),
                              itemCount: stops.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: Color(0xFFEB9042),
                                        size: 30,
                                      ),
                                      SizedBox(
                                        width: 17,
                                      ),
                                      Expanded(
                                        child: Text(
                                          stops.elementAt(
                                              index)["name"],
                                          style: TextStyle(
                                              color:
                                              Color(0xFFfdf9eb),
                                              fontSize: 18),
                                        ),
                                      ),
                                      // Spacer(),
                                    ],
                                  ),
                                );
                              },
                            ),
                            Divider(
                              color: Colors.grey,
                              // Customize the color
                              thickness: 1.0,
                              // Adjust the thickness
                              indent: 10.0,
                              // Add indentation from the start
                              endIndent: 16.0,
                              height: 30,
                            ),
                            Text(
                              "Passengers No. "+passenger.toString() + " passengers",
                              style: TextStyle(
                                  color:  Color(0xFFfdf9eb),
                                  fontSize: 18),
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              height: 60,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: int.tryParse(
                                    passenger.toString()) ??
                                    0,
                                itemBuilder: (context, index) {
                                  print(
                                      "SQQQQQQQQQQQQQQ $index DDDDDDDDDD ${acceptedRequests.length - 1}");

                                  var requestId =
                                  acceptedRequests.length - 1 >=
                                      index
                                      ? acceptedRequests
                                      .elementAt(index)
                                      : "";
                                  Map requestValue = requestId
                                      .toString()
                                      .isNotEmpty
                                      ? requestsValue
                                      .containsKey(requestId)
                                      ? requestsValue[requestId]
                                      : {}
                                      : {};
                                  var userId =
                                  requestValue.containsKey("from")
                                      ? requestValue["from"]
                                      : "";
                                  Map userValue =
                                  usersValue.containsKey(userId)
                                      ? usersValue[userId]
                                      : {};
                                  var image =
                                      "${userValue.containsKey("image") ? userValue["image"] : ""}";

                                  return Padding(
                                    padding:
                                    const EdgeInsets.all(2.0),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.white,
                                      backgroundImage: getImage(
                                          requestId, image) !=
                                          null
                                          ? getImage(requestId,
                                          image) // Image from request ID if available
                                          : AssetImage(
                                          "images/user.png"),
                                      // Default asset image otherwise
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 12,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Requests",
                                style: TextStyle(
                                    color:  Color(0xFFfdf9eb),
                                    fontSize: 20),
                              ),
                            ),
                            ListView.builder(
                              padding: EdgeInsets.all(0),
                              itemCount: requests.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                Map requestValue = requestsValue.containsKey(requests.elementAt(index))?
                                requestsValue[requests.elementAt(index)]:{};
                                var userId = requestValue.containsKey("from")?requestValue["from"]:"";
                                var state = requestValue.containsKey("state")?requestValue["state"]:"";
                                Map userValue = usersValue.containsKey(userId)?usersValue[userId]:{};

                                var name = "${userValue.containsKey("firstName")?userValue["firstName"]:""} ${userValue.containsKey("lastName")?userValue["lastName"]:""}";
                                var image = "${userValue.containsKey("image")?userValue["image"]:""}";
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey.shade100
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 24,
                                              backgroundImage: NetworkImage(image),
                                            ),
                                            SizedBox(width: 12,),
                                            Expanded(
                                              child: Text(
                                                name,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18),
                                              ),
                                            ),
                                            SizedBox(width: 12,),

                                          ],
                                        ),
                                        SizedBox(height: 8,),
                                        Visibility(
                                          visible: state == "pending",
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              InkWell(onTap: (){
                                                FirebaseDatabase.instance.ref("trips").child(activeTrip)
                                                    .child("requests").child(requests.elementAt(index))
                                                    .child("state")
                                                    .set("accept").then((value) {

                                                });
                                              },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      color: Colors.green
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text("Accept",style: TextStyle(
                                                        color: Colors.white,fontSize: 16
                                                    ),),
                                                  ),
                                                ),),
                                              SizedBox(width: 12,),
                                              InkWell(onTap: (){
                                                FirebaseDatabase.instance.ref("trips").child(activeTrip)
                                                    .child("requests").child(requests.elementAt(index)).child("state")
                                                    .set("refused").then((value) {
                                                  FirebaseDatabase.instance.ref("users").child(userId)
                                                      .child("myCurrentTrip")
                                                      .remove().then((value) {

                                                  });
                                                });
                                              },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      color: Colors.red
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text("Refuse",style: TextStyle(
                                                        color: Colors.white,fontSize: 16
                                                    ),),
                                                  ),
                                                ),),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: state == "refused",
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Colors.red
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("You Refused",style: TextStyle(
                                                  color: Colors.white,fontSize: 16
                                              ),),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20,)
                                      ],
                                    ),
                                  ),
                                );
                              },),
                          ],
                        ),
                      ),
                      SizedBox(height: 25,)
                    ],
                  ),
                ),
              ],
           ),
            )
          ],
        ),
      ),
    );
  }
  int shown = 0;
  Future<void> drawPolyLineFromOriginToDestination(fromLongtude,fromLatitude,toLongtude,toLatitude,List stops, fromName,toName) async {
    // var originPosition =
    //     Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    // var destinationPosition =
    //     Provider.of<AppInfo>(context, listen: false).userDropOffLocation;
    print("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSQQQQQQQQQQQQQQqqqq");
    var originLatLng = LatLng(
        double.parse(fromLatitude.toString()), double.parse(fromLongtude.toString()));
    var destinationLatLng = LatLng(double.parse(toLatitude.toString()),
        double.parse(toLongtude.toString()));

    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) => ProgressDialog(
    //     message: "Please wait...",
    //   ),
    // );

    var directionDetailsInfo =
    await AssistantMethods.obtainOriginToDestinationDirectionDetails(
        originLatLng, destinationLatLng);
    // setState(() {
    //   tripDirectionDetailsInfo = directionDetailsInfo;
    // });


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

    if(shown == 0){
      newGoogleMapController!
          .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));
      setState(() {
        shown = 1;
      });
    }
    // BitmapDescriptor ccustomIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
    //     'images/stop.png');
    final Uint8List markerIcon = await getBytesFromAsset('images/stop.png', 100);

    stops.forEach((element) {
      // element[""]
      var stopLatLng = LatLng(
          double.parse(element["latitude"].toString()), double.parse(element["longitude"].toString()));

      Marker marker = Marker(
        markerId: MarkerId(element["name"]),
        infoWindow:
        InfoWindow(title: element["name"], snippet: "Stop"),
        position: stopLatLng,
        icon: BitmapDescriptor.fromBytes(markerIcon),
      );
      setState(() {
        markersSet.add(marker);
      });
      print("SSSSSSSSSSSSSSSSSsss ${markersSet}");

    });
    Marker originMarker = Marker(
      markerId: const MarkerId("originID"),
      infoWindow:
      InfoWindow(title: fromName, snippet: "Origin"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      infoWindow: InfoWindow(
          title: toName, snippet: "Destination"),
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

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }
  getImage(requestId, String image) {
    return requestId.toString().isNotEmpty?image.isEmpty?
    AssetImage("images/user.png"):
    NetworkImage(image):null;
  }

}