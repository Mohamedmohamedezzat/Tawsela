import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:users/passenger/screens/main_screen_passenger.dart';

import '../../passenger/screens/help_screen.dart';
import '../../passenger/screens/edit_profile_screen.dart';
import '../../passenger/splashScreen/splash_screen.dart';
import '../global/global_driver.dart';


class DrawerScreenDriver extends StatelessWidget {
  const DrawerScreenDriver({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;


    return Container(
      width: 220,
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
                  Container(
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
                    "hi , ${userModelCurrentInfo!.firstname!}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),

                  SizedBox(height: 10,),

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

                  SizedBox(height: 30,),

                  Text("Your Trips", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),

                  SizedBox(height: 20,),

                  GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (c) => HelpScreen()));

                      },
                      child: Text("Help", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),)
                  ),
                  SizedBox(height: 400,),
                ],
              ),
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
                  Navigator.push(context, MaterialPageRoute(builder: (c) =>  MainScreenpassenger()));
                },
                child: Text('Passenger Mode',
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
                  Navigator.push(context, MaterialPageRoute(builder: (c) => SplashScreen()));
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
