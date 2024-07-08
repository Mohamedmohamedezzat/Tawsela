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
import 'package:users/passenger/screens/main_user.dart';
import 'package:users/passenger/screens/phone_screen.dart';
import 'package:users/passenger/screens/trips_passenger.dart';
import 'package:users/passenger/screens/userActiveTrip.dart';
import '../../passenger/global/global_passenger.dart';
import '../../passenger/screens/edit_profile_screen.dart';
import '../../passenger/screens/trips_history_screen.dart';
import '../Assistants/assistant_methods.dart';
import '../provider/phone_auth_provider.dart';
import 'help_screen.dart';

class ProfileDriver extends StatefulWidget {
  const ProfileDriver({Key? key}) : super(key: key);

  @override
  State<ProfileDriver> createState() => _profileDriver();
}

class _profileDriver extends State<ProfileDriver> {

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

    return Scaffold(
      backgroundColor: Color(0xFFfdf9eb),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      'Profile',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF3C4650),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                image.toString().isNotEmpty
                    ? CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(image),
                )
                    : Container(
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
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Hello, $name",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                      color:Color(0xFF3C4650)
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            Spacer(),
            Container(
              width: 250,
              height: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xFF3C4650)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit_note,
                          color: Color(0xFFEB9042),
                          size: 40,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => EditProfileScreen()));
                          },
                          child: Text(
                            "Edit Profile",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Color(0xFFfdf9eb),
                            ),
                          ),
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 27,
                        ),
                        Icon(
                          Icons.help_outline,
                          color: Color(0xFFEB9042),
                          size: 30,
                        ),
                        SizedBox(
                          width: 39,
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (c) => HelpScreen()));
                            },
                            child: Text(
                              "Help",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Color(0xFFfdf9eb)),
                            )),
                      ],
                    ),
                  ]),
            ),
            Spacer(),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                // style: ElevatedButton.styleFrom(
                //     foregroundColor: darkTheme ? Colors.black : Colors.white, backgroundColor: darkTheme ? Colors.amber.shade400 : Colors.blue,
                //     elevation: 0,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(32),
                //     ),
                //     // Rounded Rectangle Border
                //     maximumSize: Size(185, 50),
                //     minimumSize: Size(20, 50)),
                onTap: () {
                  print("SSSSSSSSSSSSSSSSS $currentUserValue");
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) =>  MainUser()));


                  // Navigator.push(context, MaterialPageRoute(builder: (c) =>  MainScreenDriver()));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(45),
                      color: Color(0xFFEB9042)),
                  padding: EdgeInsets.all(12),
                  width: double.infinity,
                  child: Text('User Mode',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFFfdf9eb),
                      )),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  firebaseAuth.signOut();
                  Navigator.push(context, MaterialPageRoute(builder: (c) => PhoneScreen()));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(45),
                      color: Color(0xFFEB9042)),
                  padding: EdgeInsets.all(12),
                  width: double.infinity,
                  child: Text(
                    "Logout",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFFfdf9eb),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }
}
