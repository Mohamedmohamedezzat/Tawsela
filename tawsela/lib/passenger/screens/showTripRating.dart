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

class ShowTripRating extends StatefulWidget{

  Map usersValue;
  Map ratings;
  // String driverName;
  // String driverImage;
  // String tripId;
  // String destination;
  ShowTripRating({
    required this.usersValue,
    required this.ratings,
    // required this.driverName,
    // required this.driverImage,
    // required this.tripId,

});
  @override
  State<ShowTripRating> createState() =>_showTripRating();

}

class _showTripRating extends State<ShowTripRating>{
  double newRating = 0.0;
  TextEditingController passengerNoCon = TextEditingController();
  TextEditingController roadCon = TextEditingController();
  List<Directions> stops = [];

  @override
  Widget build(BuildContext context) {
    List allRatings = [];
    widget.ratings.forEach((key, value) {
      allRatings.add(key);
    });
    return Container(
      // height: 280,
      child: Column(
        children: [
          SizedBox(height: 12,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text("All Rating"
              ,textAlign: TextAlign.center
              ,style: TextStyle(
                  color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold
              ),),
          ),
          Expanded(
            child: allRatings.isEmpty?Center(
              child: Text("There is no rating for this trip",style: TextStyle(
                color: Colors.black,fontSize: 18
              ),),
            ):ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
              itemCount: allRatings.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
              Map userValue = widget.usersValue.containsKey(allRatings.elementAt(index))?
              widget.usersValue[allRatings.elementAt(index)]:{};
              var rate = widget.ratings.containsKey(allRatings.elementAt(index))
                  ?widget.ratings[allRatings.elementAt(index)]:'';
              var name = "${userValue.containsKey("firstName")?userValue["firstName"]:''} ${userValue.containsKey("firstName") ? userValue["firstName"] : ''}";
              var image = userValue.containsKey("image")?userValue["image"]:'';
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(image),
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8,),
                        RatingBar.builder(
                          initialRating: double.parse(rate.toString()),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          tapOnlyMode: true,
                          ignoreGestures: true,
                          itemSize: 24,
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
                      ],
                    ),
                  ),
                  SizedBox(width: 12,),

                ],
              );

            },),
          ),
        ],
      )
    );
  }

}