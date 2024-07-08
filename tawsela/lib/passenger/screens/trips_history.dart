import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:users/models/uploadTrip.dart';
import 'package:users/passenger/screens/tripWidget.dart';

import '../models/directions.dart';

class Trips_history extends StatefulWidget{


  @override
  State<Trips_history> createState() =>_trips_history();

}

class _trips_history extends State<Trips_history>{

  TextEditingController searchCon = TextEditingController();
  Map tripsValue = {};
  Map usersValue = {};
  List trips = [];
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


    FirebaseDatabase.instance.ref("trips").onValue.listen((event) {
      if(event.snapshot.exists){
        Map o = event.snapshot.value as Map;
        trips.clear();
        o.forEach((key, value) {
          Map i = o.containsKey(key)?o[key]:{};
          Map requests = i.containsKey("requests")?i["requests"]:{};
          Map myRequest = requests.containsKey(userId)?requests[userId]:{};
          var myRequestState = myRequest.containsKey("state")?myRequest["state"]:"";
          var state = i.containsKey("state")?i["state"]:"";
          if(requests.containsKey(userId)&&state == "Complete"&&myRequestState=="accept"){
            if(mounted){
              setState(() {
                trips.add(key);
              });
            }
          }
        });
        if(mounted){
          setState(() {
            tripsValue = o;
          });
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFfdf9eb),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            SizedBox(height: 32,),
            Container(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  // InkWell(
                  //   onTap: (){
                  //     Navigator.pop(context);
                  //   },
                  //   child: Padding(
                  //     padding: EdgeInsets.all(4.0),
                  //     child: Icon(Icons.arrow_back_ios,color: Colors.black,),
                  //   ),
                  // ),
                  Expanded(
                    child: Text(
                      'History',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color:Color(0xFF3C4650),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child:trips.isEmpty?Padding(
                padding: const EdgeInsets.symmetric(vertical: 100.0),
                child: Text("There is no history",style: TextStyle(
                  fontSize: 20,fontWeight: FontWeight.bold,color: Color(0xFF3C4650)
                ),),
              ): ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 4),
                itemCount: trips.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Map tripValue = tripsValue.containsKey(trips.elementAt(index))?
                  tripsValue[trips.elementAt(index)]:{};
                  return TripWidget(tripValue: tripValue, tripId: trips.elementAt(index), usersValue: usersValue, from: 'historyUser',);
              },)),
          ],
        ),
      ),
    );
  }


}