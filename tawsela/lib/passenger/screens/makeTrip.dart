import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:users/models/uploadTrip.dart';
import 'package:users/passenger/screens/search_places_driver.dart';

import '../models/directions.dart';
import 'activeTrip.dart';

class MakeTrip extends StatefulWidget{

  Directions pickUp;
  Directions destination;
  MakeTrip({
    required this.pickUp,
    required this.destination,

});
  @override
  State<MakeTrip> createState() =>_makeTrip();

}

class _makeTrip extends State<MakeTrip>{

  TextEditingController passengerNoCon = TextEditingController();
  TextEditingController roadCon = TextEditingController();
  TextEditingController paymentCon = TextEditingController();
  List<Directions> stops = [];
  @override
  Widget build(BuildContext context) {
    Directions pickUp = widget.pickUp;
    Directions destination = widget.destination;
    return SizedBox(
      height: double.infinity,
      child: Padding(
        padding:  EdgeInsets.only(bottom:MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          color:Color(0xFF3C4650),
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 4),
                      child: Row(
                        children: [
                          InkWell(
                              onTap:(){Navigator.pop(context);},
                              child: Icon(Icons.arrow_back_ios,size: 24,color: Color(0xFFfdf9eb),)),
                          SizedBox(width: 12,),
                          Text(
                            "Make a public trip",
                            style: TextStyle(
                              color: Color(0xFFfdf9eb),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
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
                                      pickUp.locationName!=null?pickUp.locationName.toString():"Not Getting Address",
                                      style: TextStyle(
                                          color:Color(0xFFfdf9eb),
                                          fontSize: 16),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15,
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
                                      destination.locationName!=null?destination.locationName.toString():"Where to?",
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
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
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
                    ),
                    ListView.builder(
                      itemCount: stops.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [

                                SizedBox(width: 8,),
                                Icon(Icons.location_on_outlined,size: 26,color: Color(0xFFEB9042),),
                                SizedBox(width: 20,),
                                Expanded(
                                  child: Text(stops.elementAt(index).locationName.toString(),style: TextStyle(
                                      color: Color(0xFFfdf9eb),fontSize: 16
                                  ),),
                                ),
                                // Spacer(),
                                InkWell(
                                  onTap: (){
                                    setState(() {
                                      stops.removeAt(index);
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Icon(Icons.delete,size: 26,color: Color(0xFFEB9042),),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },),
                    SizedBox(
                      height: 4,
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) =>
                                    SearchPlacesDriver(callback: (data) {
                                      // setState(() {
                                      Directions location = data;
                                      // });
                                      setState(() {
                                        stops.add(location);
                                      });
                                    },)));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Color(0xFFfdf9eb),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.add,size: 26,color: Color(0xFFEB9042),),
                              SizedBox(width: 8,),
                              Text("Add Stop",style: TextStyle(
                                color: Color(0xFF808080),fontSize: 16
                              ),)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey, // Customize the color
                      thickness: 1.0, // Adjust the thickness
                      indent: 1.0, // Add indentation from the start
                      endIndent: 16.0,
                      height: 20,
                    ),
                    TextFormField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(100)
                      ],
                      controller: roadCon,
                      decoration: InputDecoration(
                        prefixIcon: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Image.asset('images/road.png',scale: 2,), // Or use NetworkImage for remote images
                        ),
                        hintText: "the Road taken",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        filled: true,
                        fillColor:Color(0xFFfdf9eb),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            )),
                        // prefixIcon: Icon(
                        //   Icons.map,
                        //   color: Colors.grey,
                        // ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey, // Customize the color
                      thickness: 1.0, // Adjust the thickness
                      indent: 1.0, // Add indentation from the start
                      endIndent: 16.0,
                      height: 20,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(100)
                            ],
                            controller: paymentCon,

                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.payment, color:  Color(0xFFEB9042),),
                              hintText: "Payment Method",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              filled: true,
                              fillColor:Color(0xFFfdf9eb),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  )),
                              // prefixIcon: Icon(
                              //   Icons.map,
                              //   color: Colors.grey,
                              // ),
                            ),

                          ),
                        ),
                        SizedBox(width: 10,),
                        SizedBox(
                          width: 150,
                          child: TextFormField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(100)
                            ],
                            controller: passengerNoCon,

                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.group, color:  Color(0xFFEB9042),),

                              hintText: "N Passengers",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              filled: true,
                              fillColor:Color(0xFFfdf9eb),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  )),
                              // prefixIcon: Icon(
                              //   Icons.map,
                              //   color: Colors.grey,
                              // ),
                            ),


                          ),
                        ),

                      ],
                    ),
                    Divider(
                      color: Colors.grey, // Customize the color
                      thickness: 1.0, // Adjust the thickness
                      indent: 1.0, // Add indentation from the start
                      endIndent: 16.0,
                      height: 20,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                          Color(0xFFfdf9eb),
                          backgroundColor:  Color(0xFFEB9042),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        onPressed: () {
                          var userId = FirebaseAuth.instance.currentUser!.uid.toString();
                         var road = roadCon.text.trim().toString();
                         var passengers = passengerNoCon.text.trim().toString();
                         List<Map> theStops = [];
                          stops.forEach((element) {
                            theStops.add({"name":element.locationName,
                            "longitude":element.locationLongitude,
                            "latitude":element.locationLatitude});
                          });
                          if(passengers.isNotEmpty&&road.isNotEmpty&&paymentCon.text.trim().toString().isNotEmpty){
                            var upload = UploadTrip(userId, pickUp.locationLatitude!.toDouble(),
                                destination.locationLatitude!.toDouble(),
                                pickUp.locationLongitude!.toDouble(), destination.locationLongitude!.toDouble(),
                                pickUp.locationName.toString(), destination.locationName.toString(),
                                "active",paymentCon.text.trim().toString()
                                , road, passengers,theStops);
                            var tripId = FirebaseDatabase.instance.ref("trips").push().key.toString();
                            FirebaseDatabase.instance.ref("trips").child(tripId).set(upload.toJson()).then((value){
                              FirebaseDatabase.instance.ref("users").child(userId).child("activeTrip").set(tripId).then((value){
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ActiveTrip(),));
                              });
                            });
                          }
                        },
                        child: Text(
                          'Post Trip',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        )),
                    SizedBox(height: 24,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}