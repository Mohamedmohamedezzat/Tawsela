import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:users/models/uploadUser.dart';
import 'package:users/passenger/global/global_passenger.dart';
import 'package:users/passenger/screens/forgot_password_screen.dart';
import 'package:users/passenger/screens/main_screen_passenger.dart';
import 'package:users/passenger/screens/main_user.dart';
import 'package:users/passenger/screens/phone_screen.dart';
import 'package:users/passenger/splashScreen/splash_screen.dart';

import '../models/user_model.dart';
import '../provider/phone_auth_provider.dart';
import '../utils/utils.dart';
import 'help_screen.dart';

class RegisterScreenPassenger extends StatefulWidget {

  const RegisterScreenPassenger({Key? key, }) : super(key: key);

  @override
  State<RegisterScreenPassenger> createState() => _RegisterScreenPassengerState();
}

class _RegisterScreenPassengerState extends State<RegisterScreenPassenger> {

  final nationalidTextEditingController = TextEditingController();
  Gender? selectedGender;

  File? image;
  File? frontImage;
  File? backImage;
  final firstnameTextEditingController = TextEditingController();
  final secondnameTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();

  final addressTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final confirmTextEditingController = TextEditingController();


  bool _passwordVisible = false;

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

  void selectImage() async {
    try {
      final pickedImage =
      await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        // image = File(pickedImage.path);
        image = File(pickedImage.path);

        setState(() {});
      }

    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void selectImageCamera() async {
    try {
      final pickedImage =
      await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        // image = File(pickedImage.path);
          image = File(pickedImage.path);

        setState(() {});
      }

    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Future<void> _performTextRecognition(_imageFile) async {
  //   final FirebaseVisionImage visionImage =
  //   FirebaseVisionImage.fromFile(_imageFile);
  //
  //   final TextRecognizer textRecognizer =
  //   FirebaseVision.instance.textRecognizer();
  //   final VisionText visionText =
  //   await textRecognizer.processImage(visionImage);
  //   String recognizedText = '';
  //   for (TextBlock block in visionText.blocks) {
  //     for (TextLine line in block.lines) {
  //       recognizedText += "${line.text} ";
  //     }
  //   }
  //   print("AAAAAAAAAAAAAAA $recognizedText");
  //   setState(() {
  //     // _recognizedText = recognizedText;
  //   });
  //   textRecognizer.close();
  // }

  void selectImageId() async {
    try {
      final pickedImage =
      await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        // image = File(pickedImage.path);
        if(toBePicked == "front"){
          frontImage = File(pickedImage.path);
        }else if(toBePicked == "back"){
          backImage = File(pickedImage.path);
        }
        setState(() {});
      }

    } catch (e) {
      showSnackBar(context, e.toString());
    }


  }


  void selectImageIdCamera() async {
    try {
      final pickedImage =
      await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        // image = File(pickedImage.path);
        if(toBePicked == "front"){
          frontImage = File(pickedImage.path);
        }else if(toBePicked == "back"){
          backImage = File(pickedImage.path);
        }
        setState(() {});
      }

    } catch (e) {
      showSnackBar(context, e.toString());
    }


  }


  String toBePicked = "";


  //declare a GlobalKey
  // final _formKey = GlobalKey<FormState>();
  //
  // void _submit() async {
  //   // validate all the form fields
  //   if(_formKey.currentState!.validate()) {
  //     await firebaseAuth.createUserWithEmailAndPassword(
  //         email: emailTextEditingController.text.trim(),
  //         password: passwordTextEditingController.text.trim()
  //     ).then((auth) async {
  //       currentUser = auth.user;
  //
  //       if(currentUser != null){
  //         Map userMap = {
  //           "id": currentUser!.uid,
  //           "name": nameTextEditingController.text.trim(),
  //           "email": emailTextEditingController.text.trim(),
  //           "address": addressTextEditingController.text.trim(),
  //           "phone": phoneTextEditingController.text.trim(),
  //           "rid": "free",
  //           "rVehicleType": "none",
  //         };
  //
  //         DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users");
  //         userRef.child(currentUser!.uid).set(userMap);
  //       }
  //       await Fluttertoast.showToast(msg: "Successfully Registered");
  //       Navigator.push(context, MaterialPageRoute(builder: (c) => SplashScreen()));
  //     }).catchError((errorMessage) {
  //       Fluttertoast.showToast(msg: "Error occured: \n $errorMessage");
  //     });
  //   }
  //   else{
  //     Fluttertoast.showToast(msg: "Not all field are valid");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    selectedGender = _determineGender();
    final isLoading =
        Provider
            .of<AuthProvide>(context, listen: true)
            .isLoading;
    bool darkTheme =
        MediaQuery
            .of(context)
            .platformBrightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor:  Color(0xFFfdf9eb),
        body: ListView(
          padding: EdgeInsets.only(top: 20),
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 20, 15, 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        margin: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                              Row(
                                children: [
                                  Padding(

                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    'Create New Account',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF3C4650),
                                    ),
                                  ),

                                                              ),
                                  SizedBox(width: 20,),
                                  InkWell(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (c)
                                        => HelpScreen()));
                                      },
                                      child: Icon(Icons.help,color: Color(0xFF3C4650),size: 28,)),
                                ],
                              ),

                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () => showSheet("profile"),
                              child: image == null
                                  ?  CircleAvatar(
                                backgroundColor:  Color(0xFF3C4650),
                                radius: 60,
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Icon(Icons.camera_alt_outlined, color: Color(0xFF808080) , size: 50,),
                                ),
                              )
                                  : CircleAvatar(
                                backgroundImage: FileImage(image!),
                                radius: 60,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: TextFormField(
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(10)
                                    ],
                                    style: TextStyle(color:  Color(0xFFfdf9eb)),
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
                                    onChanged: (text) =>
                                        setState(() {
                                          firstnameTextEditingController.text =
                                              text;
                                        }),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                SizedBox(
                                  width: 170,
                                  child: TextFormField(
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(50)
                                    ],
                                    style: TextStyle(color:  Color(0xFFfdf9eb)),
                                    decoration: InputDecoration(
                                        hintText: "Second Name",
                                        hintStyle: const TextStyle(
                                            color:Color(0xFF808080)),
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
                                          color: Color(0xFF808080),
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
                                    onChanged: (text) =>
                                        setState(() {
                                          secondnameTextEditingController.text =
                                              text;
                                        }),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(14)
                              ],
                              style: TextStyle(color:  Color(0xFFfdf9eb)),
                              decoration: InputDecoration(
                                  hintText: "National ID",
                                  hintStyle: const TextStyle(
                                      color: Color(0xFF808080)),
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
                                    color: Color(0xFF808080),
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
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text("National Id Front Side",
                                textAlign: TextAlign.center,style: TextStyle(
                                    color: Color(0xFF808080),
                                    fontSize: 17
                                ),),
                            ),
                            InkWell(
                              onTap: (){
                                setState(() {
                                  toBePicked = "front";
                                });
                                showSheet("");
                              },
                              child: frontImage!= null?ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.file(frontImage!,height: 180,
                                  width: double.infinity,fit: BoxFit.cover,),
                              ):Container(
                                height: 180,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Color(0xFF3C4650)
                                ),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(12.0),

                                child: Text("press to pick the front image of your national id",
                                  textAlign: TextAlign.center,style: TextStyle(
                                      color: Color(0xFF808080),
                                      fontSize: 17
                                  ),),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text("National Id Back Side",
                                textAlign: TextAlign.center,style: TextStyle(
                                    color: Color(0xFF808080),
                                    fontSize: 17
                                ),),
                            ),
                            InkWell(
                              onTap: (){
                                setState(() {
                                  toBePicked = "back";
                                });
                               showSheet("");
                              },
                              child: backImage!= null?ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.file(backImage!,height: 180,
                                  width: double.infinity,fit: BoxFit.cover,),
                              ):Container(
                                height: 180,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                    color: Color(0xFF3C4650)
                                ),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(12.0),

                                child: Text("press to pick the back image of your national id",
                                textAlign: TextAlign.center,style: TextStyle(
                                      color: Color(0xFF808080),
                                  fontSize: 17
                                ),),
                              ),
                            ),

                            SizedBox(
                              height: 20,
                            ),

                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(40) , color: Color(0xFF3C4650)),
                                    child: ListTile(
                                      title: const Text('Male'),
                                      textColor: const Color(0xFF808080),
                                      leading: Radio<Gender>(
                                        fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                                          if (states.contains(MaterialState.selected)) {
                                            return Color(0xFFfdf9eb); // Green when selected
                                          }
                                          return Color(0xFF808080); // Transparent otherwise (outline only)
                                        }),
                                        value: Gender.male,
                                        groupValue: selectedGender,
                                        onChanged: (Gender? value) {
                                          setState(() {
                                            selectedGender = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5), // Add spacing between the options
                                Expanded(
                                  child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(40) , color: Color(0xFF3C4650)),
                                    child: ListTile(
                                      title: const Text('Female', style: TextStyle(color: Color(0xFF808080))),
                                      leading: Radio<Gender>(
                                        fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                                          if (states.contains(MaterialState.selected)) {
                                            return Color(0xFFfdf9eb); // Green when selected
                                          }
                                          return Color(0xFF808080); // Transparent otherwise (outline only)
                                        }),
                                        value: Gender.female,
                                        groupValue: selectedGender,
                                        onChanged: (Gender? value) {
                                          setState(() {
                                            selectedGender = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // SizedBox(
                            //   height: 20,
                            // ),
                            //
                            // TextFormField(
                            //   inputFormatters: [
                            //     LengthLimitingTextInputFormatter(100)
                            //   ],
                            //   decoration: InputDecoration(
                            //     hintText: "Email",
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
                            //   onChanged: (text) =>
                            //       setState(() {
                            //         emailTextEditingController.text = text;
                            //       }),
                            // ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(30)
                              ],
                              style: TextStyle(color:  Color(0xFFfdf9eb)),
                              decoration: InputDecoration(
                                hintText: "Address",
                                hintStyle: TextStyle(
                                  color: Color(0xFF808080),
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
                                  color: Color(0xFF808080),
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
                              onChanged: (text) =>
                                  setState(() {
                                    addressTextEditingController.text = text;
                                  }),
                            ),

                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFEB9042),
                                  foregroundColor:  Color(0xFFFFFFFF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  minimumSize: Size(double.infinity, 50),
                                ),
                                onPressed: () {
                                  //_submit();
                                  storeData();
                                },
                                child: Text(
                                  'Continue',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            // GestureDetector(
                            //   onTap: () {
                            //     Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: (c) =>
                            //                 ForgotPasswordScreen()));
                            //   },
                            //   child: Text(
                            //     'Forgot Password?',
                            //     style: TextStyle(
                            //       color: darkTheme
                            //           ? Colors.amber.shade400
                            //           : Colors.blue,
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 20,
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Text(
                            //       "Have an account?",
                            //       style: TextStyle(
                            //         color: Colors.grey,
                            //         fontSize: 15,
                            //       ),
                            //     ),
                            //     SizedBox(
                            //       width: 5,
                            //     ),
                            //     GestureDetector(
                            //       onTap: () {
                            //         Navigator.push(
                            //             context,
                            //             MaterialPageRoute(
                            //                 builder: (c) => PhoneScreen()));
                            //       },
                            //       child: Text(
                            //         "Sign In",
                            //         style: TextStyle(
                            //           fontSize: 15,
                            //           color: darkTheme
                            //               ? Colors.amber.shade400
                            //               : Colors.blue,
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // )

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
    );
  }

  void storeData() async {
    final ap = Provider.of<AuthProvide>(context, listen: false);
    var address = addressTextEditingController.text.trim();
    var nationalId = nationalidTextEditingController.text.trim();
    var firstName = firstnameTextEditingController.text.trim();
    var lastName = secondnameTextEditingController.text.trim();
    var email = emailTextEditingController.text.trim();
    var password = passwordTextEditingController.text.trim();
    var userId = FirebaseAuth.instance.currentUser!.uid.toString();

    if(address.isNotEmpty&&firstName.isNotEmpty&&lastName.isNotEmpty&&
        frontImage!= null&&backImage!= null&&image!= null){
      // if(image!= null){
        uploadImage("users/$userId/profilePic", image!).then((imageUrl){
          uploadImage("users/$userId/nationalIdFrontSide", frontImage!).then((frontImageUrl){
            uploadImage("users/$userId/nationalIdBackSide", backImage!).then((backImageUrl){
              var upload = UploadUser(addressTextEditingController.text.trim(), "",nationalId,
                firstnameTextEditingController.text.trim(), imageUrl,
                secondnameTextEditingController.text.trim()
                , FirebaseAuth.instance.currentUser!.phoneNumber.toString()
                , "active", "user", selectedGender.toString()
                , backImageUrl, frontImageUrl, emailTextEditingController.text.trim(),
                passwordTextEditingController.text.trim(),);
              FirebaseDatabase.instance.ref("users").child(userId).set(upload.toJson()).then((value) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  MainUser(),
                    ),
                        (route) => false);
              });

            });
          });
        });
      // }else{
      //   uploadImage("users/$userId/nationalIdFrontSide", frontImage!).then((frontImageUrl){
      //     uploadImage("users/$userId/nationalIdBackSide", backImage!).then((backImageUrl){
      //       var upload = UploadUser(addressTextEditingController.text.trim(), "",nationalId,
      //         firstnameTextEditingController.text.trim(), "",
      //         secondnameTextEditingController.text.trim()
      //         , FirebaseAuth.instance.currentUser!.phoneNumber.toString()
      //         , "active", "user", selectedGender.toString()
      //         , backImageUrl, frontImageUrl, emailTextEditingController.text.trim(),
      //         passwordTextEditingController.text.trim(),);
      //       FirebaseDatabase.instance.ref("users").child(userId).set(upload.toJson()).then((value) {
      //         Navigator.pushAndRemoveUntil(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) =>  MainUser(),
      //             ),
      //                 (route) => false);
      //       });
      //
      //     });
      //   });
      // }

    }
   // UserModel userModel = UserModel(
   //    id: FirebaseAuth.instance.currentUser!.uid.toString(),
   //    firstname: firstnameTextEditingController.text.trim(),
   //    secondname: secondnameTextEditingController.text.trim(),
   //    email: emailTextEditingController.text.trim(),
   //    profilePic: "",
   //    phone: "",
   //    nationalid: nationalidTextEditingController.text.trim(),
   //    password: passwordTextEditingController.text.trim(),
   //    address: addressTextEditingController.text.trim(),
   //    rid: "free",
   //    rVehicleType: "car",
   //    gender: selectedGender.toString()
   //  );
   //
   //
   //  if (image != null) {
   //    ap.saveUserDataToFirebase(
   //      context: context,
   //      userModel: userModel,
   //      profilePic: image!,
   //      onSuccess: () {
   //        ap.saveUserDataToSP().then(
   //              (value) =>
   //              ap.setSignIn().then(
   //                    (value) =>
   //                    Navigator.pushAndRemoveUntil(
   //                        context,
   //                        MaterialPageRoute(
   //                          builder: (context) => const MainScreenpassenger(),
   //                        ),
   //                            (route) => false),
   //              ),
   //        );
   //      },
   //    );
   //  } else {
   //    showSnackBar(context, "Please upload your profile photo");
   //  }
  }

  Gender _determineGender() {
    String nationalId = nationalidTextEditingController.text;

    if (nationalId.length == 14) {
      int lastDigit = int.tryParse(nationalId[12]) ?? 0;
      return (lastDigit % 2 == 0) ? Gender.female : Gender.male;
    } else {
      return Gender.unknown;
    }
  }

  void showSheet(from) {
    showModalBottomSheet(
      context: context, builder: (context) {
      return Container(
        color: Color(0xFFfdf9eb),
        height: 180,
        padding: EdgeInsets.all(12),
        child: Column(

          children: [
            Text("Choose One of the next",style: TextStyle(
                color: Color(0xFF3C4650),fontSize: 20,fontWeight: FontWeight.bold
            ),),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                    if(from == "profile"){
                      selectImageCamera();
                    }else{
                      selectImageIdCamera();
                    }
                  },
                  child: Column(
                    children: [
                      Icon(Icons.camera_alt_rounded,size: 28,color: Color(0xFF3C4650)),
                      SizedBox(height: 6,),
                      Text("Camera",style: TextStyle(
                          color: Color(0xFF3C4650),fontSize: 18
                      ),)
                    ],
                  ),
                ),
                SizedBox(width: 48,),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                    if(from == "profile"){
                      selectImage();
                    }else{
                      selectImageId();
                    }

                  },
                  child: Column(
                    children: [
                      Icon(Icons.image,size: 28, color: Color(0xFF3C4650)),
                      SizedBox(height: 6,),
                      Text("Gallery",style: TextStyle(
                          color: Color(0xFF3C4650),fontSize: 18
                      ),)
                    ],
                  ),
                )
              ],
            ),
            Spacer(),
          ],
        ),
      );
    },);
  }

  showLoaderDialog(BuildContext context) {
    showGeneralDialog(context: context,
        barrierDismissible: false,

        pageBuilder: (_, __, ___) {
          return Align(
            alignment: Alignment.center,
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                margin: EdgeInsets.all(12),
                height: 140,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)
                ),
                padding: EdgeInsets.symmetric(horizontal: 48,vertical: 24),
                child: Column(
                  children: [
                    // SizedBox(width: 24,),
                    Spacer(),
                    Text("Saving Data",
                      style: TextStyle(fontSize: 18, color: Colors.indigo,fontWeight: FontWeight.bold
                      ),)
                    , SizedBox(height: 24,),
                    SizedBox(
                      width: 140,
                      height: 4,
                      child: LinearProgressIndicator(
                        color: Colors.indigo,
                      ),
                    ),
                    Spacer(),
                  ],),
              ),
            ),
          );
        });
  }


  Future<String> uploadImage(String ref, File file) async {
    UploadTask uploadTask = FirebaseStorage.instance.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
enum Gender { male, female, unknown }
