import 'dart:async';

import 'package:flutter/material.dart';
import 'package:users/Assistants/assistant_methods.dart';
import 'package:users/global/global.dart';
import 'package:users/screens/login_screen.dart';
import 'package:users/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  startTimer() async {
    if(firebaseAuth.currentUser != null){
      await AssistantMethods.readCurrentOnlineUserInfo();
      await AssistantMethods.readOnlineDriverCarInfo();
      await AssistantMethods.readOnTripInformation();
      Timer(Duration(seconds: 5), () {
        Navigator.push(context, MaterialPageRoute(builder: (c) => MainScreen()));
      });
    }
    else{
      Timer(Duration(seconds: 5), () {
        Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
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
      body: Center(
        child: Image.asset("images/logo_splash.png",height: 200,)
        // Text(
        //   'Trippo',
        //   style: TextStyle(
        //     fontSize: 40,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
      ),
    );
  }
}
