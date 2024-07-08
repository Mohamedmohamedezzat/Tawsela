import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:users/models/uploadTrip.dart';
import 'package:users/passenger/screens/tripWidget.dart';

import '../models/directions.dart';

class TripsPassenger extends StatefulWidget{


  @override
  State<TripsPassenger> createState() =>_tripsPassenger();

}

class _tripsPassenger extends State<TripsPassenger>{

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
          var state = i.containsKey("state")?i["state"]:"";
          var from = i.containsKey("from")?i["from"]:"";
          if(state == "active"
              &&from != userId
          ){
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
                children: const [
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
                      'Trips',
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
            SizedBox(
              height: 44,
              child: TextFormField(
                  style: TextStyle(color:  Color(0xFFfdf9eb)),
                  controller: searchCon,

                  decoration: InputDecoration(
                      hintText: "Search trips",
                      hintStyle: const TextStyle(
                          color: Color(0xFF808080)),
                      filled: true,
                      fillColor: Color(0xFF3C4650),
                      contentPadding: EdgeInsets.all(0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          )),
                      prefixIcon: Icon(
                        Icons.search,
                        color:  Colors.grey,
                      )),

                  keyboardType: TextInputType.text,
                  onChanged: (text) {
                    search(text);
                  }
              ),
            ),
            SizedBox(height: 20,),
            Expanded(
                child: trips.isNotEmpty?ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  itemCount: trips.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    Map tripValue = tripsValue.containsKey(trips.elementAt(index))?
                    tripsValue[trips.elementAt(index)]:{};
                    return TripWidget(tripValue: tripValue, tripId: trips.elementAt(index), usersValue: usersValue, from: 'main',);
                  },):Center(child: Text("there is no trips",
                  style: TextStyle(
                      color: Colors.black,fontSize: 18
                  ),),)),
          ],
        ),
      ),
    );
  }

  void search(text) {
    var userId = FirebaseAuth.instance.currentUser!.uid.toString();

    setState(() {
     trips.clear();
   });
    tripsValue.forEach((key, value) {
      Map i = tripsValue.containsKey(key)?tripsValue[key]:{};
      var state = i.containsKey("state")?i["state"]:"";
      var from = i.containsKey("fromName")?i["fromName"]:"";
      var to = i.containsKey("toName")?i["toName"]:"";
      String stopsName = "";
      List stops = i.containsKey("stops")?i["stops"]:[];
      stops.forEach((element)=>stopsName = "${stopsName+element["name"]} ");
      String search = "$stops $from $to";
      var fromId = i.containsKey("from")?i["from"]:"";
      if(state == "active"
          // &&fromId != userId
      ){
        if(search.toLowerCase().contains(text)){
            setState(() {
              trips.add(key);
            });
          }

      }
    });
  }

}