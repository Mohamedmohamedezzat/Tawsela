import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:users/passenger/global/global_passenger.dart';
import 'package:users/passenger/utils/utils.dart';

import '../provider/phone_auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final nationalidTextEditingController = TextEditingController();

  final firstnameTextEditingController = TextEditingController();
  final secondnameTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();

  final addressTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final confirmTextEditingController = TextEditingController();


  bool _passwordVisible = false;
  var image = "";
  File? newImage;

  void selectImage() async {
    newImage = await pickImage(context);
    setState(() {});
  }


  @override
  void dispose() {
    super.dispose();
    firstnameTextEditingController.dispose();
    secondnameTextEditingController.dispose();
    emailTextEditingController.dispose();
    nationalidTextEditingController.dispose();
    addressTextEditingController.dispose();
    passwordTextEditingController.dispose();
    confirmTextEditingController.dispose();
  }

  Map userValue = {};
  @override
  void initState() {
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(currentUserUid);

    userRef.once().then((snap){
      if(snap.snapshot.value != null){
        if(mounted){
          Map o = snap.snapshot.value as Map;
          setState(() {
            userValue = snap.snapshot.value as Map;
             firstnameTextEditingController.text ="${ o.containsKey("firstName")?o["firstName"]:""}";
            secondnameTextEditingController.text ="${ o.containsKey("lastName")?o["lastName"]:""}";
            nationalidTextEditingController.text ="${ o.containsKey("nationalId")?o["nationalId"]:""}";
            emailTextEditingController.text ="${ o.containsKey("email")?o["email"]:""}";
            addressTextEditingController.text ="${ o.containsKey("address")?o["address"]:""}";
             image =o.containsKey("image")?o["image"]:"";

          });
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    // selectedGender = _determineGender();
 
    final isLoading =
        Provider
            .of<AuthProvide>(context, listen: true)
            .isLoading;
    // bool darkTheme =
    //     MediaQuery
    //         .of(context)
    //         .platformBrightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Color(0xFFfdf9eb),
        body: Column(
          children: [
            SizedBox(height: 32,),
            Container(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_back_ios,color: Color(0xFF3C4650),),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Edit Profile',
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
              child: ListView(
                padding: EdgeInsets.only(top: 8),
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: (){
                               selectImage();
                              },
                              child: CircleAvatar(
                                backgroundImage: getImage(),
                                radius: 70,
                              ),
                            ),
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              margin: const EdgeInsets.only(top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [


                                  SizedBox(
                                    height: 30,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text("Name",style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,fontSize: 16
                                    ),),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 150,
                                        child: TextFormField(
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(50)
                                          ],
                                          style: TextStyle(color:  Color(0xFFfdf9eb)),
                                          controller: firstnameTextEditingController,
                                          decoration: InputDecoration(
                                              hintText: "First Name",
                                              hintStyle: const TextStyle(
                                                  color: Color(0xFF808080)),
                                              filled: true,
                                              fillColor: Color(0xFF3C4650),
                                              // fillColor: darkTheme
                                              //     ? Colors.black45
                                              //     : Colors.grey.shade200,
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(
                                                      40),
                                                  borderSide: const BorderSide(
                                                    width: 0,
                                                    style: BorderStyle.none,
                                                  )),
                                              prefixIcon: Icon(
                                                Icons.person,
                                                  color :Color(0xFF808080)
                                                // color: darkTheme
                                                //     ? Colors.amber.shade400
                                                //     : Colors.grey,
                                              )),
                                          autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                          validator: (text) {
                                            if (text == null || text.isEmpty) {
                                              return 'Name can\'t be empty';
                                            }

                                            if (text.length < 3) {
                                              return "Please enter a valid name";
                                            }
                                            if (text.length > 49) {
                                              return "Name can't be more than 50";
                                            }
                                            return null;
                                          },
                                          // onChanged: (text) =>
                                          //     setState(() {
                                          //       firstnameTextEditingController.text =
                                          //           text;
                                          //     }),
                                        ),
                                      ),
                                      SizedBox(width: 20,),
                                      SizedBox(
                                        width: 150,
                                        child: TextFormField(
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(50)
                                          ],
                                          style: TextStyle(color:  Color(0xFFfdf9eb)),

                                          controller: secondnameTextEditingController,

                                          decoration: InputDecoration(
                                              hintText: "Second Name",
                                              hintStyle: const TextStyle(
                                                  color: Color(0xFF808080)),
                                              filled: true,
                                              fillColor: Color(0xFF3C4650),
                                              // fillColor: darkTheme
                                              //     ? Colors.black45
                                              //     : Colors.grey.shade200,
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(
                                                      40),
                                                  borderSide: const BorderSide(
                                                    width: 0,
                                                    style: BorderStyle.none,
                                                  )),
                                              prefixIcon: Icon(
                                                Icons.person,
                                                color :Color(0xFF808080),

                                                // color: darkTheme
                                                //     ? Colors.amber.shade400
                                                //     : Colors.grey,
                                              )),
                                          autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                          validator: (text) {
                                            if (text == null || text.isEmpty) {
                                              return 'Name can\'t be empty';
                                            }

                                            if (text.length < 3) {
                                              return "Please enter a valid name";
                                            }
                                            if (text.length > 49) {
                                              return "Name can't be more than 50";
                                            }
                                            return null;
                                          },
                                          // onChanged: (text) =>
                                          //     setState(() {
                                          //       secondnameTextEditingController.text =
                                          //           text;
                                          //     }),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text("National ID",style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,fontSize: 16
                                    ),),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  TextFormField(
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(14)
                                    ],
                                    style: TextStyle(color:  Color(0xFFfdf9eb)),

                                    controller: nationalidTextEditingController,

                                    decoration: InputDecoration(
                                        hintText: "National ID",
                                        enabled: false,
                                        hintStyle: const TextStyle(
                                            color: Colors.grey),
                                        filled: true,
                                        fillColor: Color(0xFF3C4650),
                                        // fillColor: darkTheme
                                        //     ? Colors.black45
                                        //     : Colors.grey.shade200,
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(40),
                                            borderSide: const BorderSide(
                                              width: 0,
                                              style: BorderStyle.none,
                                            )),
                                        prefixIcon: Icon(
                                          Icons.person_pin_rounded,
                                          color :Color(0xFF808080),
                                          // color: darkTheme
                                          //     ? Colors.amber.shade400
                                          //     : Colors.grey,
                                        )),
                                    keyboardType: TextInputType.number,
                                    autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'National ID can\'t be empty';
                                      }
                                      if (text.length < 14) {
                                        return "National ID must be 14";
                                      }
                                      return null;
                                    },
                                    onChanged: (text) =>
                                        setState(() {
                                          nationalidTextEditingController.text = text;
                                        }),
                                  ),


                                  // Row(
                                  //   children: <Widget>[
                                  //     Expanded( // Expand to take available space
                                  //       child: ListTile(
                                  //         title: Text('Male'),
                                  //         leading: Radio<Gender>(
                                  //           value: Gender.male,
                                  //           groupValue: selectedGender,
                                  //           onChanged: null,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     Expanded(
                                  //       child: ListTile(
                                  //         title: Text('Female'),
                                  //         leading: Radio<Gender>(
                                  //           value: Gender.female,
                                  //           groupValue: selectedGender,
                                  //           onChanged: null,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  // SizedBox(
                                  //   height: 20,
                                  // ),
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  //   child: Text("Email",style: TextStyle(
                                  //     color: Colors.black54,
                                  //     fontWeight: FontWeight.bold,fontSize: 16
                                  //   ),),
                                  // ),
                                  // SizedBox(
                                  //   height: 6,
                                  // ),
                                  // TextFormField(
                                  //   inputFormatters: [
                                  //     LengthLimitingTextInputFormatter(100)
                                  //   ],
                                  //   controller: emailTextEditingController,
                                  //
                                  //   decoration: InputDecoration(
                                  //     hintText: "Email",
                                  //     enabled: false,
                                  //     hintStyle: TextStyle(
                                  //       color: Colors.grey,
                                  //     ),
                                  //     filled: true,
                                  //     fillColor: darkTheme
                                  //         ? Colors.black45
                                  //         : Colors.grey.shade200,
                                  //     border: OutlineInputBorder(
                                  //         borderRadius: BorderRadius.circular(40),
                                  //         borderSide: BorderSide(
                                  //           width: 0,
                                  //           style: BorderStyle.none,
                                  //         )),
                                  //     prefixIcon: Icon(
                                  //       Icons.person,
                                  //       color: darkTheme
                                  //           ? Colors.amber.shade400
                                  //           : Colors.grey,
                                  //     ),
                                  //   ),
                                  //   autovalidateMode:
                                  //   AutovalidateMode.onUserInteraction,
                                  //   validator: (text) {
                                  //     if (text == null || text.isEmpty) {
                                  //       return 'Email can\'t be empty';
                                  //     }
                                  //     if (EmailValidator.validate(text) == true) {
                                  //       return null;
                                  //     }
                                  //     if (text.length < 2) {
                                  //       return "Please enter a valid email";
                                  //     }
                                  //     if (text.length > 99) {
                                  //       return "Email can\'t be more than 100";
                                  //     }
                                  //   },
                                  //   // onChanged: (text) =>
                                  //   //     setState(() {
                                  //   //       emailTextEditingController.text = text;
                                  //   //     }),
                                  // ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text("Address",style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,fontSize: 16
                                    ),),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  TextFormField(
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(100)
                                    ],
                                    style: TextStyle(color:  Color(0xFFfdf9eb)),

                                    controller: addressTextEditingController,

                                    decoration: InputDecoration(
                                      hintText: "Address",
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFF3C4650),
                                      // fillColor: darkTheme
                                      //     ? Colors.black45
                                      //     : Colors.grey.shade200,
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(40),
                                          borderSide: BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          )),
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color :Color(0xFF808080),
                                        // color: darkTheme
                                        //     ? Colors.amber.shade400
                                        //     : Colors.grey,
                                      ),
                                    ),
                                    autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'Address can\'t be empty';
                                      }
                                      if (text.length < 2) {
                                        return "Please enter a valid address";
                                      }
                                      if (text.length > 99) {
                                        return "Address can\'t be more than 100";
                                      }
                                    },
                                    // onChanged: (text) =>
                                    //     setState(() {
                                    //       addressTextEditingController.text = text;
                                    //     }),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),

                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFFEB9042),
                                        foregroundColor: Color(0xFFfdf9eb),
                                        // foregroundColor:
                                        // darkTheme ? Colors.black : Colors.white,
                                        // backgroundColor: darkTheme
                                        //     ? Colors.amber.shade400
                                        //     : Colors.blue,
                                        // elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(32),
                                        ),
                                        minimumSize: Size(double.infinity, 50),
                                      ),
                                      onPressed: () {
                                        var userId = FirebaseAuth.instance.currentUser!.uid.toString();

                                        if(newImage!=null) {
                                          uploadImage("users/$userId/profilePic", newImage!).then((imageUrl){

                                            FirebaseDatabase.instance.ref("users")
                                              .child(userId)
                                              .update(
                                              {
                                                "firstNAme": firstnameTextEditingController
                                                    .text.trim().toString(),
                                                "lastName": secondnameTextEditingController
                                                    .text.trim().toString(),

                                                "image": imageUrl,
                                              }).then((value){
                                                Navigator.pop(context);
                                            });
                                              });
                                        }else{
                                          FirebaseDatabase.instance.ref("users")
                                              .child(userId)
                                              .update(
                                              {
                                                "firstNAme": firstnameTextEditingController
                                                    .text.trim().toString(),
                                                "lastName": secondnameTextEditingController
                                                    .text.trim().toString(),
                                                "address": addressTextEditingController
                                                    .text.trim().toString(),
                                              }).then((value){
                                            Navigator.pop(context);
                                          });
                                        }
                                      },
                                      child: Text(
                                        'Update Profile',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      )),
                                  SizedBox(
                                    height: 10,
                                  ),

                                ],
                              ),
                            ),

                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getImage() {
    return newImage!=null?FileImage(newImage!):image.toString().isNotEmpty?
    NetworkImage(image):AssetImage("images/user.png");
  }

  Future<String> uploadImage(String ref, File file) async {
    UploadTask uploadTask = FirebaseStorage.instance.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

}