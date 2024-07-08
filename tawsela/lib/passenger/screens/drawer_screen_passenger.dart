import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users/driver/screens/car_info_screen.dart';
import 'package:users/driver/screens/main_screen_driver.dart';
import 'package:users/driver/screens/register_screen_driver.dart';
import 'package:users/passenger/screens/activeTrip.dart';
import 'package:users/passenger/screens/get_driver_data.dart';
import 'package:users/passenger/screens/phone_screen.dart';
import 'package:users/passenger/screens/trips_passenger.dart';
import 'package:users/passenger/screens/userActiveTrip.dart';
import '../../passenger/global/global_passenger.dart';
import '../../passenger/screens/edit_profile_screen.dart';
import '../../passenger/screens/trips_history_screen.dart';
import '../Assistants/assistant_methods.dart';
import '../provider/phone_auth_provider.dart';
import 'help_screen.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {

  Map userValue = {};
  @override
  void initState() {
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(currentUserUid);

    userRef.onValue.listen((snap){
      if(snap.snapshot.value != null){
     if(mounted){
       setState(() {
         userValue = snap.snapshot.value as Map;
       });
     }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    final ap = Provider.of<AuthProvide>(context, listen: false);

    var name ="${ userValue.containsKey("firstName")?userValue["firstName"]:""} ${ userValue.containsKey("lastName")?userValue["lastName"]:""}";
    var image =userValue.containsKey("image")?userValue["image"]:"";
    var type =userValue.containsKey("type")?userValue["type"]:"";

    return Container(

      width: 240,
      child: Drawer(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 50, 0, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  image.toString().isNotEmpty?
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(image),
                      )
                      :Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 20,),

                  Text(
                    "hi $name",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),

                  SizedBox(height: 20,),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (c) => EditProfileScreen()));
                    },
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.blue,
                      ),
                    ),
                  ),

                  SizedBox(height: 20,),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (c) => TripsPassenger()));
                    },
                    child: Text(
                      "Available Trips",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ),


                  SizedBox(height: 20,),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (c) => ActiveTrip()));
                    },
                    child: Text(
                      "Active Trip",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ),


                  SizedBox(height: 20,),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (c) => UserActiveTrip()));
                    },
                    child: Text(
                      "My Trip",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  SizedBox(height: 20,),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (c) => TripsHistoryScreen()));
                    },
                    child: Text("Your Trips", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),)
                  ),

                  SizedBox(height: 20,),

                  GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (c) => HelpScreen()));

                      },
                      child: Text("Help", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),)
                  ),

                ],
              ),
              Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: darkTheme ? Colors.black : Colors.white, backgroundColor: darkTheme ? Colors.amber.shade400 : Colors.blue,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    // Rounded Rectangle Border
                    maximumSize: Size(185, 50),
                    minimumSize: Size(20, 50)),
                onPressed: () {
                  print("SSSSSSSSSSSSSSSSS $currentUserValue");
                  if(type == "userDriver"){
                    Navigator.push(context, MaterialPageRoute(builder: (c) =>  MainScreenDriver()));

                  }else{
                    Navigator.push(context, MaterialPageRoute(builder: (c) =>  Get_driver_data()));

                  }
                  // Navigator.push(context, MaterialPageRoute(builder: (c) =>  MainScreenDriver()));
                },
                child: Text('Driver Mode',
                    style: TextStyle(
                      fontSize: 20,
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  firebaseAuth.signOut();
                  Navigator.push(context, MaterialPageRoute(builder: (c) => PhoneScreen()));
                },
                child: Text(
                  "Logout",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.red,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
