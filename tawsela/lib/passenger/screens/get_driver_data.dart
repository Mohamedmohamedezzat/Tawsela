import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:users/models/uploadDriverData.dart';
import 'package:users/models/uploadUser.dart';
import 'package:users/passenger/global/global_passenger.dart';
import 'package:users/passenger/screens/forgot_password_screen.dart';
import 'package:users/passenger/screens/main_screen_passenger.dart';
import 'package:users/passenger/screens/phone_screen.dart';
import 'package:users/passenger/splashScreen/splash_screen.dart';

import '../models/user_model.dart';
import '../provider/phone_auth_provider.dart';
import '../utils/utils.dart';
import 'help_screen.dart';
import 'main_driver.dart';

class Get_driver_data extends StatefulWidget {

  const Get_driver_data({Key? key, }) : super(key: key);

  @override
  State<Get_driver_data> createState() => _get_driver_data();
}

class _get_driver_data extends State<Get_driver_data> {

  File? image;
  // File? frontImage;
  // File? backImage;
  File? carLicenceFront;
  File? carLicenceBack;
  File? driverLicence;


  bool _passwordVisible = false;


  void selectImageId() async {
    try {
      final pickedImage =
      await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        // image = File(pickedImage.path);
        if(toBePicked == "carFront"){
          carLicenceFront = File(pickedImage.path);
        }else if(toBePicked == "carBack"){
          carLicenceBack = File(pickedImage.path);
        }else if(toBePicked == "driver"){
          driverLicence = File(pickedImage.path);
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
        if(toBePicked == "carFront"){
          carLicenceFront = File(pickedImage.path);
        }else if(toBePicked == "carBack"){
          carLicenceBack = File(pickedImage.path);
        }else if(toBePicked == "driver"){
          driverLicence = File(pickedImage.path);
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

  TextEditingController modelCon = TextEditingController();
  TextEditingController carCompanyCon = TextEditingController();
  TextEditingController modelYearCon = TextEditingController();
  TextEditingController carColorCon = TextEditingController();
  TextEditingController carNumberCon = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
        body: Column(
          children: [
            SizedBox(height: 32,),
            Container(
              padding: EdgeInsets.all(12),
              child: Row(
                children:  [
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
                      'Driver Data',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3C4650),
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (c)
                        => HelpScreen()));
                      },
                      child: Icon(Icons.help,color: Color(0xFF3C4650),size: 28,)),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: EdgeInsets.only(top: 0),
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 50),
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
                              margin: const EdgeInsets.only(top: 8),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 150,
                                        child: TextFormField(
                                          keyboardType: TextInputType.text,
                                          controller: modelCon,
                                          style: TextStyle(color:  Color(0xFFfdf9eb)),
                                          decoration: InputDecoration(
                                            hintText: "Car Model",
                                            hintStyle: TextStyle(
                                              color: Color(0xFF808080),
                                            ),
                                            filled: true,
                                            fillColor: Color(0xFF3C4650),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(40),
                                                borderSide: BorderSide(
                                                  width: 0,
                                                  style: BorderStyle.none,
                                                )),
                                            prefixIcon: Icon(
                                              Icons.car_rental,
                                              color: Color(0xFF808080),
                                            ),
                                          ),

                                          // onChanged: (text) =>
                                          //     setState(() {
                                          //       addressTextEditingController.text = text;
                                          //     }),
                                        ),
                                      ),
                                      SizedBox(width: 20,),
                                      SizedBox(
                                        width: 150,
                                        child: TextFormField(
                                          keyboardType: TextInputType.text,
                                          controller: carCompanyCon,
                                          style: TextStyle(color:  Color(0xFFfdf9eb)),

                                          decoration: InputDecoration(
                                            hintText: "Car Company",
                                            hintStyle: TextStyle(
                                              color: Color(0xFF808080),
                                            ),
                                            filled: true,
                                            fillColor: Color(0xFF3C4650),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(40),
                                                borderSide: BorderSide(
                                                  width: 0,
                                                  style: BorderStyle.none,
                                                )),
                                            prefixIcon: Icon(
                                              Icons.car_rental,
                                              color: Color(0xFF808080),
                                            ),
                                          ),

                                          // onChanged: (text) =>
                                          //     setState(() {
                                          //       addressTextEditingController.text = text;
                                          //     }),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 12,),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 150,

                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: modelYearCon,
                                          style: TextStyle(color:  Color(0xFFfdf9eb)),

                                          decoration: InputDecoration(
                                            hintText: "Car Model year",
                                            hintStyle: TextStyle(
                                              color: Color(0xFF808080),
                                            ),
                                            filled: true,
                                            fillColor: Color(0xFF3C4650),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(40),
                                                borderSide: BorderSide(
                                                  width: 0,
                                                  style: BorderStyle.none,
                                                )),
                                            prefixIcon: Icon(
                                              Icons.car_rental,
                                              color: Color(0xFF808080),
                                            ),
                                          ),

                                          // onChanged: (text) =>
                                          //     setState(() {
                                          //       addressTextEditingController.text = text;
                                          //     }),
                                        ),
                                      ),
                                      SizedBox(width: 20,),
                                      SizedBox(
                                        width: 150,

                                        child: TextFormField(
                                          keyboardType: TextInputType.text,
                                          controller: carColorCon,
                                          style: TextStyle(color:  Color(0xFFfdf9eb)),

                                          decoration: InputDecoration(
                                            hintText: "Car Color",
                                            hintStyle: TextStyle(
                                                color: Color(0xFF808080)),
                                            filled: true,
                                            fillColor: Color(0xFF3C4650),

                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(40),
                                                borderSide: BorderSide(
                                                  width: 0,
                                                  style: BorderStyle.none,
                                                )),
                                            prefixIcon: Icon(
                                              Icons.car_rental,
                                              color: Color(0xFF808080),
                                            ),
                                          ),

                                          // onChanged: (text) =>
                                          //     setState(() {
                                          //       addressTextEditingController.text = text;
                                          //     }),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 12,),

                                  TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: carNumberCon,
                                    style: TextStyle(color:  Color(0xFFfdf9eb)),
                                    decoration: InputDecoration(
                                      hintText: "car plate number",
                                      hintStyle: const TextStyle(
                                          color: Color(0xFF808080)),
                                      filled: true,
                                      fillColor: Color(0xFF3C4650),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(40),
                                          borderSide: BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          )),
                                      prefixIcon: Icon(
                                        Icons.car_rental,
                                        color: Color(0xFF808080),
                                      ),
                                    ),

                                    // onChanged: (text) =>
                                    //     setState(() {
                                    //       addressTextEditingController.text = text;
                                    //     }),
                                  ),
                                  SizedBox(height: 12,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: Text("Car Licence Front Side",
                                      textAlign: TextAlign.center,style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 17
                                      ),),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      setState(() {
                                        toBePicked = "carFront";
                                      });
                                      showSheet();
                                    },
                                    child: carLicenceFront!= null?ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.file(carLicenceFront!,height: 180,
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

                                      child: Text("press to pick the front image of your car licence",
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
                                    child: Text("Car licence Back Side",
                                      textAlign: TextAlign.center,style: TextStyle(
                                          color: Color(0xFF808080),
                                          fontSize: 17
                                      ),),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      setState(() {
                                        toBePicked = "carBack";
                                      });
                                     showSheet();
                                    },
                                    child: carLicenceBack!= null?ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.file(carLicenceBack!,height: 180,
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

                                      child: Text("press to pick the back image of your car licence",
                                      textAlign: TextAlign.center,style: TextStyle(
                                            color: Color(0xFF808080),
                                        fontSize: 17
                                      ),),
                                    ),
                                  ),

                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: Text("Driver Licence",
                                      textAlign: TextAlign.center,style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 17
                                      ),),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      setState(() {
                                        toBePicked = "driver";
                                      });
                                     showSheet();
                                    },
                                    child: driverLicence!= null?ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.file(driverLicence!,height: 180,
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

                                      child: Text("press to pick your driver licence",
                                      textAlign: TextAlign.center,style: TextStyle(
                                            color: Color(0xFF808080),
                                        fontSize: 17
                                      ),),
                                    ),
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
                                    height: 22,
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

  void storeData() async {
    final ap = Provider.of<AuthProvide>(context, listen: false);
    var carModel = modelCon.text.trim();
    var carCompony = carCompanyCon.text.trim();
    var modelYear = modelYearCon.text.trim();
    var carColor = carColorCon.text.trim();
    var plateNumber = carNumberCon.text.trim();
    var userId = FirebaseAuth.instance.currentUser!.uid.toString();

    if(carModel.isNotEmpty&&carCompony.isNotEmpty&&carColor.isNotEmpty&&modelYear.isNotEmpty&&
        plateNumber.isNotEmpty&&carLicenceFront!= null
        &&carLicenceBack!= null&&driverLicence!= null){

        uploadImage("users/$userId/carLicenceFront", carLicenceFront!).then((carLicenceFrontUrl){
          uploadImage("users/$userId/carLicenceBack", carLicenceBack!).then((carLicenceBackUrl){
            uploadImage("users/$userId/driverLicence", driverLicence!).then((driverLicenceUrl){
              var upload = UploadDriverData(carModel, carCompony, modelYear,carColor, plateNumber, carLicenceFrontUrl,
                  carLicenceBackUrl, driverLicenceUrl);
              FirebaseDatabase.instance.ref("users").child(userId).child("driver").set(upload.toJson()).then((value) {
                FirebaseDatabase.instance.ref("users").child(userId).child("type").set("userDriver").then((value){
                  Navigator.pushAndRemoveUntil(
                    context, MaterialPageRoute(builder: (context) => MainDriver(),),(route) => false,);

                });

              });

            });
          });
        });


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


  void showSheet() {
    showModalBottomSheet(
      context: context, builder: (context) {
      return Container(
        color: Color(0xFFfdf9eb),
        height: 180,
        padding: EdgeInsets.all(12),
        child: Column(

          children: [
            Text("Choose One of the next",style: TextStyle(
                color: Color(0xFF808080),fontSize: 20,fontWeight: FontWeight.bold,
            ),),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                    selectImageIdCamera();
                  },
                  child: Column(
                    children: [
                      Icon(Icons.camera_alt_rounded,size: 28,color: Color(0xFF3C4650),),
                      SizedBox(height: 6,),
                      Text("Camera",style: TextStyle(
                          color: Color(0xFF808080),fontSize: 18
                      ),)
                    ],
                  ),
                ),
                SizedBox(width: 48,),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                    selectImageId();
                  },
                  child: Column(
                    children: [
                      Icon(Icons.image,size: 28, color: Color(0xFF3C4650),),
                      SizedBox(height: 6,),
                      Text("Gallery",style: TextStyle(
                          color: Color(0xFF808080),fontSize: 18
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
  Future<String> uploadImage(String ref, File file) async {
    UploadTask uploadTask = FirebaseStorage.instance.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
enum Gender { male, female, unknown }
