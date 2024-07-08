import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:users/models/uploadTrip.dart';
import 'package:users/passenger/screens/search_places_driver.dart';

import '../models/directions.dart';
import 'activeTrip.dart';

class MakeRating extends StatefulWidget{

  String driverId;
  String driverName;
  String driverImage;
  String tripId;
  // String destination;
  MakeRating({
    required this.driverId,
    required this.driverName,
    required this.driverImage,
    required this.tripId,

});
  @override
  State<MakeRating> createState() =>_makeRating();

}

class _makeRating extends State<MakeRating>{
  double newRating = 2.5;
  TextEditingController passengerNoCon = TextEditingController();
  TextEditingController roadCon = TextEditingController();
  List<Directions> stops = [];
  @override
  Widget build(BuildContext context) {

    return Container(
      // height: 280,
      padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text("Rate this driver",style: TextStyle(
                color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold
            ),),
          ),
          SizedBox(height: 24,),
          SizedBox(height: 4,),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: NetworkImage(widget.driverImage),
              ),
              SizedBox(height: 8,),
              Text(
                widget.driverName,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8,),
              SizedBox(width: 12,),

            ],
          ),
          SizedBox(height: 12,),

          RatingBar.builder(
            initialRating: 2.5,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                newRating = rating;
              });
            },
          ),
          SizedBox(height: 24,),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: (){
                    var userId = FirebaseAuth.instance.currentUser!.uid.toString();
                    FirebaseDatabase.instance.ref("trips").child(widget.tripId)
                        .child("ratings")
                        .child(userId).set(newRating).then((value){
                      FirebaseDatabase.instance.ref("users").child(userId).child("myCurrentTrip")
                          .remove().then((value){
                        Navigator.pop(context);
                      });
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.blue
                    ),
                    padding: EdgeInsets.all(18),
                    width: double.infinity,
                    child: Text("Submit",textAlign: TextAlign.center,style: TextStyle(
                        color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold
                    ),),
                  ),
                ),
              ),
              SizedBox(width: 12,),
              Expanded(
                child: InkWell(
                  onTap: (){
                    var userId = FirebaseAuth.instance.currentUser!.uid.toString();
                    FirebaseDatabase.instance.ref("users").child(userId).child("myCurrentTrip")
                        .remove().then((value){
                      Navigator.pop(context);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.red
                    ),
                    padding: EdgeInsets.all(18),
                    width: double.infinity,
                    child: Text("Cancel",textAlign: TextAlign.center,style: TextStyle(
                        color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold
                    ),),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}