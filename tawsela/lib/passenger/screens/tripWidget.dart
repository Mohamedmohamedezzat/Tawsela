import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:users/models/uploadRequest.dart';
import 'package:users/models/uploadTrip.dart';
import 'package:users/passenger/screens/showMyRating.dart';
import 'package:users/passenger/screens/showTripRating.dart';

import '../models/directions.dart';

class TripWidget extends StatefulWidget{

  Map tripValue;
  Map usersValue;
  String tripId;
  String from;

  TripWidget({required this.tripValue,
    required this.tripId,
    required this.usersValue,
    required this.from,
  });

  @override
  State<TripWidget> createState() =>_tripWidget();

}

class _tripWidget extends State<TripWidget>{

  // Map tripsValue = {};
  // Map usersValue = {};
  String activeTrip = "";


  @override
  Widget build(BuildContext context) {
    Map tripValue = widget.tripValue;
    var from = tripValue.containsKey("from")?tripValue["from"]:"";
    var fromName = tripValue.containsKey("fromName")?tripValue["fromName"]:"";
    var toName = tripValue.containsKey("toName")?tripValue["toName"]:"";
    var comment = tripValue.containsKey("payment")?tripValue["payment"]:"";
    var fromLongtude = tripValue.containsKey("fromLongtude")?tripValue["fromLongtude"]:"";
    var toLongtude = tripValue.containsKey("toLongtude")?tripValue["toLongtude"]:"";
    var fromLatitude = tripValue.containsKey("fromLatitude")?tripValue["fromLatitude"]:"";
    var toLatitude = tripValue.containsKey("toLatitude")?tripValue["toLatitude"]:"";
    Map requestsValue = tripValue.containsKey("requests")?tripValue["requests"]:{};
    Map ratingsValue = tripValue.containsKey("ratings")?tripValue["ratings"]:{};
    var stops = tripValue.containsKey("stops")?tripValue["stops"]:"";

    Map myRequestValue = requestsValue.containsKey(FirebaseAuth.instance.currentUser!.uid.toString())?
        requestsValue[FirebaseAuth.instance.currentUser!.uid.toString()]:{};
    var myState = myRequestValue.containsKey("state")?myRequestValue["state"]:"";
    List acceptedRequests = [];
    var road = tripValue.containsKey("road")?tripValue["road"]:"";
    var passenger = tripValue.containsKey("passenger")?tripValue["passenger"]:"";
    requestsValue.forEach((key, value) {
      Map v = requestsValue.containsKey(key)?requestsValue[key]:{};
      var state = v.containsKey("state")?v["state"]:"";
      if(state == "accept"){
        acceptedRequests.add(key);
      }
    });
    var userId = FirebaseAuth.instance.currentUser!.uid.toString();
    var myReview = 0.0 ;
    ratingsValue.forEach((key, value) {
      var v = ratingsValue.containsKey(key)?ratingsValue[key]:"";
      // var r = v.containsKey(userId)?v[userId]:"";
      myReview = double.parse(v.toString());
    });
    return  Container(
      child: Column(
        children: [
          Column(
            // padding: EdgeInsets.symmetric(horizontal: 2),
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Color(0xFF3C4650)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "From",
                                        style: TextStyle(
                                          color: Color(0xFF808080),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        fromName.toString(),
                                        style: TextStyle(
                                            color: Color(0xFFfdf9eb),
                                            fontSize: 16),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
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
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "To",
                                        style: TextStyle(
                                          color: Color(0xFF808080),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        toName.toString(),
                                        style: TextStyle(
                                            color: Color(0xFFfdf9eb),
                                            fontSize: 16),
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
                        color: Colors.grey, // Customize the color
                        thickness: 1.0, // Adjust the thickness
                        indent: 1.0, // Add indentation from the start
                        endIndent: 16.0,
                        height: 30,
                      ),
                      Row(
                        children: [
                          Image.asset("images/road.png" ,scale: 1.6,),
                          SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Road ",style: TextStyle(color: Color(0xFF808080), fontSize: 16,                                          fontWeight: FontWeight.bold,
                              ),
                              ),
                              Text(
                                road.toString(),
                                style: TextStyle(color: Color(0xFFfdf9eb), fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.grey, // Customize the color
                        thickness: 1.0, // Adjust the thickness
                        indent: 1.0, // Add indentation from the start
                        endIndent: 16.0,
                        height: 30,
                      ),
                      Row(
                        children: [
                          Icon(Icons.payment,   color: Color(0xFFEB9042),
                            size: 30,),
                          SizedBox(width: 20,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Payment Method : ",style: TextStyle(color: Color(0xFF808080), fontSize: 16,                                          fontWeight: FontWeight.bold,
                              ),
                              ),
                              Text(
                                comment,
                                style: TextStyle(color: Color(0xFFfdf9eb), fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.grey, // Customize the color
                        thickness: 1.0, // Adjust the thickness
                        indent: 1.0, // Add indentation from the start
                        endIndent: 16.0,
                        height: 30,
                      ),
                      Row(
                        children: [
                          Image.asset("images/pin.png" ,scale: 2,),
                          SizedBox(width: 15,),
                          Text(
                            "Stops",
                            style: TextStyle(
                              color: Color(0xFF808080),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 2),
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
                                    stops.elementAt(index)["name"],
                                    style: TextStyle(
                                        color: Color(0xFFfdf9eb), fontSize: 16),
                                  ),
                                ),
                                // Spacer(),
                              ],
                            ),
                          );
                        },
                      ),
                      Divider(
                        color: Colors.grey, // Customize the color
                        thickness: 1.0, // Adjust the thickness
                        indent: 1.0, // Add indentation from the start
                        endIndent: 16.0,
                        height: 30,
                      ),
                      // Text(
                      //   "Passengers No. "+passenger.toString() + " passengers",
                      //   style: TextStyle(
                      //       color: Colors.black,
                      //       fontSize: 18),
                      // ),
                      // SizedBox(height: 8,),
                      SizedBox(
                        height: 60,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: int.parse(passenger.toString()),
                          itemBuilder: (context, index) {
                            // print("SQQQQQQQQQQQQQQ $index DDDDDDDDDD ${acceptedRequests.length -1}");

                            var requestId = acceptedRequests.length - 1 >= index
                                ? acceptedRequests.elementAt(index)
                                : "";
                            Map requestValue = requestId.toString().isNotEmpty
                                ? requestsValue.containsKey(requestId)
                                ? requestsValue[requestId]
                                : {}
                                : {};
                            var userId = requestValue.containsKey("from")
                                ? requestValue["from"]
                                : "";
                            Map userValue =
                            widget.usersValue.containsKey(userId)
                                ? widget.usersValue[userId]
                                : {};
                            var image =
                                "${userValue.containsKey("image") ? userValue["image"] : ""}";
                            print("QQQQQQQQQQQQQQQQ ${widget.usersValue}");

                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: CircleAvatar(
                                radius: 30,

                                backgroundColor: Colors.white,
                                backgroundImage: getImage(requestId, image) != null
                                    ? getImage(requestId, image) // Image from request ID if available
                                    : AssetImage("images/user.png"),
                                // Default asset image otherwise
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Visibility(
            visible: widget.from != "main",
            child: Row(

              children: [
                InkWell(
                  onTap: () {
                    if (widget.from == "historyDriver") {
                      showRatingModelDriver(
                          ratingsValue, widget.usersValue);
                    } else if (widget.from == "historyUser") {
                      showRatingModelUser(
                          from, myReview, widget.tripId);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Color(0xFFEB9042)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        widget.from == "historyDriver"
                            ? "Ratings"
                            : "Your Rate",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 17 , color: Color(0xFFfdf9eb) ) ,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Visibility(
            visible: widget.from == "main",
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      var upload = UploadRequest(
                          FirebaseAuth.instance.currentUser!.uid.toString(),
                          widget.tripId,
                          "pending");
                      FirebaseDatabase.instance
                          .ref("trips")
                          .child(widget.tripId)
                          .child("requests")
                          .child(
                          FirebaseAuth.instance.currentUser!.uid.toString())
                          .set(upload.toJson())
                          .then((value) {
                        FirebaseDatabase.instance
                            .ref("users")
                            .child(FirebaseAuth.instance.currentUser!.uid
                            .toString())
                            .child("myCurrentTrip")
                            .set(widget.tripId)
                            .then((value) {});
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Color(0xFFEB9042)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          myState == "pending"
                              ? "You request sent"
                              : myState == "accept"
                              ? "Your Request Accepted"
                              : "Send Request",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Visibility(
                  visible: myRequestValue.isNotEmpty,
                  child: Expanded(
                    child: InkWell(
                      onTap: () {
                        FirebaseDatabase.instance
                            .ref("trips")
                            .child(widget.tripId)
                            .child("requests")
                            .child(FirebaseAuth.instance.currentUser!.uid
                            .toString())
                            .remove();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.red),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Cancel",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey, // Customize the color
            thickness: 3.0, // Adjust the thickness
            indent: 1, // Add indentation from the start
            endIndent: 1,
            height: 20,
          ),
        ],
      ),
    );
  }


  showRatingModelUser(from,myRating,tripId){
    showModalBottomSheet(
      isDismissible: false
      ,context: context, builder: (context) {
      return SizedBox(
          height: 180,
          child: ShowMyRating(driverId: from,myRating: myRating,tripId: tripId,));
    },);
  }


  showRatingModelDriver(ratings,usersValue,){
    showModalBottomSheet(
      isDismissible: false
      ,context: context, builder: (context) {
      return SizedBox(
          height: 340,
          child: ShowTripRating(ratings: ratings,usersValue: usersValue,));
    },);
  }

  getImage(requestId, String image) {
    return requestId.toString().isNotEmpty?image.isEmpty?
    AssetImage("images/user.png"):
    NetworkImage(image):null;
  }

}