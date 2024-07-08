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

class DriverRating extends StatefulWidget{


  @override
  State<DriverRating> createState() =>_driverRating();

}

class _driverRating extends State<DriverRating>{
  double newRating = 0.0;
  TextEditingController passengerNoCon = TextEditingController();
  TextEditingController roadCon = TextEditingController();
  int num = 0;

  double rates = 0.0;
  @override
  void initState() {
    var userId = FirebaseAuth.instance.currentUser!.uid.toString();

    FirebaseDatabase.instance.ref("trips").onValue.listen((event) {
      if(event.snapshot.exists){
        Map o = event.snapshot.value as Map;
        o.forEach((key, value) {
          Map i = o.containsKey(key)?o[key]:{};
          var from = i.containsKey("from")?i["from"]:"";
          Map ratings = i.containsKey("ratings")?i["ratings"]:{};
          if(from==userId){
          if(ratings.isNotEmpty){
            ratings.forEach((key, value) {
           if(mounted){
             setState(() {
               rates = rates + double.parse(value.toString());
               num = num +1;
             });
           }
            });

          }
          }
        });
        // if(mounted){
        //
        // }
      }
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor:  Color(0xFFfdf9eb),
        // height: 280,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 32,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 12),
              child: Text("Your Rating"
                ,textAlign: TextAlign.center
                ,style: TextStyle(
                  color: Color(0xFF3C4650),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,                ),),
            ),
            Spacer(),

            Row(
              children: [
                Spacer(),
                RatingBar.builder(
                  initialRating: rates/num,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  tapOnlyMode: true,
                  ignoreGestures: true,
                  itemSize: 54,
                  updateOnDrag: false,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    // size: 12,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {

                  },
                ),

                Spacer(),
              ],
            ),
            SizedBox(height: 8,),
            Text("Rating $rates | $num Rates"
              ,textAlign: TextAlign.center
              ,style: TextStyle(
                  color: Colors.black,fontSize: 23,fontWeight: FontWeight.bold
              ),),
            Spacer()
          ],
        )
    );
  }

}