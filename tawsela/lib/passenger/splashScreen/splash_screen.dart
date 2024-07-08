import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:users/passenger/screens/main_user.dart';

import '../../passenger/screens/main_screen_passenger.dart';
import '../../passenger/Assistants/assistant_methods.dart';
import '../../passenger/global/global_passenger.dart';
import '../screens/phone_screen.dart';
import '../screens/register_screen_passenger.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  startTimer() async {
    if(firebaseAuth.currentUser != null){
      DatabaseReference userRef = FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(FirebaseAuth.instance.currentUser!.uid);

      userRef.once().then((snap){
        if(snap.snapshot.exists){
          Future(() async => await AssistantMethods.readCurrentOnlineUserInfo());
          Timer(Duration(seconds: 2), () {
            Navigator.push(context, MaterialPageRoute(builder: (c) => MainUser()));
          });
          // userModelCurrentInfo = UserModel.fromMap(snap.snapshot as Map<String, dynamic>);
        }else{
          Timer(Duration(seconds: 2), () {
            Navigator.push(context, MaterialPageRoute(builder: (c) => RegisterScreenPassenger()));
          });
        }
      });

      // await AssistantMethods.readOnlineDriverCarInfo();
      // await AssistantMethods.readOnTripInformation();

    }
    else{
      Timer(Duration(seconds: 5), () {
        Navigator.push(context, MaterialPageRoute(builder: (c) => PhoneScreen()));
      });

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfdf9eb),
      body: Center(
        child:Image.asset("images/logo_splash.png",height: 200,)
      ),
    );
  }
}
