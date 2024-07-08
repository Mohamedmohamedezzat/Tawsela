import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users/screens/login_screen.dart';

import '../../passenger/splashScreen/splash_screen.dart';
import '../global/global_driver.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({Key? key}) : super(key: key);

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {

  final nameTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  final addressTextEditingController = TextEditingController();

  DatabaseReference userRef = FirebaseDatabase.instance.ref().child("drivers");

  Future<void> showDriverNameDialogAlert(BuildContext context, String name){

    nameTextEditingController.text = name;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Update"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: nameTextEditingController,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel", style: TextStyle(color: Colors.red),),
              ),

              TextButton(
                onPressed: () {
                  userRef.child(firebaseAuth.currentUser!.uid).update({
                    "name": nameTextEditingController.text.trim(),
                  }).then((value){
                    nameTextEditingController.clear();
                    Fluttertoast.showToast(msg: "Updated Succesfully. \n Reload the app to see the changes");
                  }).catchError((errorMessage) {
                    Fluttertoast.showToast(msg: "Error Occurred. \n $errorMessage");
                  });
                  Navigator.pop(context);
                },
                child: Text("Ok", style: TextStyle(color: Colors.black),),
              ),
            ],
          );
        }
    );
  }

  Future<void> showDriverPhoneDialogAlert(BuildContext context, String phone){

    phoneTextEditingController.text = phone;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Update"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: phoneTextEditingController,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel", style: TextStyle(color: Colors.red),),
              ),

              TextButton(
                onPressed: () {
                  userRef.child(firebaseAuth.currentUser!.uid).update({
                    "phone": phoneTextEditingController.text.trim(),
                  }).then((value){
                    phoneTextEditingController.clear();
                    Fluttertoast.showToast(msg: "Updated Succesfully. \n Reload the app to see the changes");
                  }).catchError((errorMessage) {
                    Fluttertoast.showToast(msg: "Error Occurred. \n $errorMessage");
                  });
                  Navigator.pop(context);
                },
                child: Text("Ok", style: TextStyle(color: Colors.black),),
              ),
            ],
          );
        }
    );
  }

  Future<void> showDriverAddressDialogAlert(BuildContext context, String address){

    addressTextEditingController.text = address;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Update"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: addressTextEditingController,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel", style: TextStyle(color: Colors.red),),
              ),

              TextButton(
                onPressed: () {
                  userRef.child(firebaseAuth.currentUser!.uid).update({
                    "address": addressTextEditingController.text.trim(),
                  }).then((value){
                    addressTextEditingController.clear();
                    Fluttertoast.showToast(msg: "Updated Succesfully. \n Reload the app to see the changes");
                  }).catchError((errorMessage) {
                    Fluttertoast.showToast(msg: "Error Occurred. \n $errorMessage");
                  });
                  Navigator.pop(context);
                },
                child: Text("Ok", style: TextStyle(color: Colors.black),),
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {

    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: darkTheme ? Colors.amber.shade400 : Colors.black,
            ),
          ),
          title: Text("Profile Screen", style: TextStyle(color: darkTheme ? Colors.amber.shade400 : Colors.black, fontWeight: FontWeight.bold),),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: ListView(
          padding: EdgeInsets.all(0),
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 50),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(50),
                      decoration: BoxDecoration(
                        color: darkTheme ? Colors.amber.shade400 : Colors.lightBlue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person, color: darkTheme ? Colors.black : Colors.white,),
                    ),

                    SizedBox(height: 30,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${userModelCurrentInfo?.firstname}",
                          style: TextStyle(
                            color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        IconButton(
                            onPressed: () {
                              showDriverNameDialogAlert(context, onlineDriverData.firstname!);
                            },
                            icon: Icon(
                              Icons.edit,
                              color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                            )
                        ),
                      ],
                    ),

                    Divider(
                      thickness: 1,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${userModelCurrentInfo?.phone!}",
                          style: TextStyle(
                            color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        IconButton(
                            onPressed: () {
                              showDriverPhoneDialogAlert(context, onlineDriverData.phone!);
                            },
                            icon: Icon(
                              Icons.edit,
                              color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                            )
                        ),
                      ],
                    ),

                    Divider(
                      thickness: 1,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${userModelCurrentInfo?.address!}",
                          style: TextStyle(
                            color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        IconButton(
                            onPressed: () {
                              showDriverAddressDialogAlert(context, onlineDriverData.address!);
                            },
                            icon: Icon(
                              Icons.edit,
                              color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                            )
                        ),
                      ],
                    ),

                    Divider(
                      thickness: 1,
                    ),

                    Text("${userModelCurrentInfo?.email}",
                      style: TextStyle(
                        color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 20,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${onlineDriverData.car_model!} \n ${onlineDriverData.car_color!} (${onlineDriverData.car_number!})",
                          style: TextStyle(
                            color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Image.asset(
                          onlineDriverData.car_type == "Car" ? "images/Car.png"
                              : onlineDriverData.car_type == "CNG" ? "images/CNG.png"
                              : "images/Bike.png",
                          scale: 2,
                        ),
                      ],
                    ),

                    SizedBox(height: 20,),

                    ElevatedButton(
                      onPressed: () {
                        firebaseAuth.signOut();
                        Navigator.pushAndRemoveUntil(
                            context, MaterialPageRoute(builder: (context) => LoginScreen(),),(route) => false,);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                      child: Text("Log Out"),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}























