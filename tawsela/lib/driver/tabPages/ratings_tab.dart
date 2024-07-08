import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

import '../../passenger/infoHandler/info_passenger.dart';
import '../global/global_driver.dart';

class RatingsTabPage extends StatefulWidget {
  const RatingsTabPage({Key? key}) : super(key: key);

  @override
  State<RatingsTabPage> createState() => _RatingsTabPageState();
}

class _RatingsTabPageState extends State<RatingsTabPage> {

  double ratingsNumber = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getRatingsNumber();
  }

  getRatingsNumber(){
    setState((){
      ratingsNumber = double.parse(Provider.of<AppInfo>(context, listen: false).driverAverageRatings);
    });

    setupRatingsTitle();
  }

  setupRatingsTitle(){
    if(ratingsNumber == 1){
      setState((){
        titleStarsRating = "Very Bad";
      });
    }
    if(ratingsNumber == 2){
      setState((){
        titleStarsRating = "Bad";
      });
    }
    if(ratingsNumber == 3){
      setState((){
        titleStarsRating = "Good";
      });
    }
    if(ratingsNumber == 4){
      setState((){
        titleStarsRating = "Very Good";
      });
    }
    if(ratingsNumber == 5){
      setState((){
        titleStarsRating = "Excellent";
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: darkTheme ? Colors.black : Colors.white,
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: darkTheme ? Colors.grey : Colors.white60,
        child: Container(
          margin: EdgeInsets.all(4),
          width: double.infinity,
          decoration: BoxDecoration(
            color: darkTheme ? Colors.black : Colors.white54,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 22.0,),

              Text(
                "Your Ratings",
                style: TextStyle(
                  fontSize: 22,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                  color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                ),
              ),

              SizedBox(height: 20,),

              SmoothStarRating(
                rating: ratingsNumber,
                allowHalfRating: true,
                starCount: 5,
                color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                borderColor: darkTheme ? Colors.amber.shade400 : Colors.blue,
                size: 46,
              ),

              SizedBox(height: 12.0,),

              Text(
                titleStarsRating,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                ),
              ),

              SizedBox(height: 18.0,),
            ],
          ),
        ),
      ),
    );
  }
}











