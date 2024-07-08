
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:users/driver/screens/main_screen_driver.dart';

import '../../passenger/models/user_model.dart';
import '../../passenger/provider/phone_auth_provider.dart';
import '../../passenger/screens/forgot_password_screen.dart';
import '../../passenger/screens/phone_screen.dart';
import '../../passenger/utils/utils.dart';
import '../global/global_driver.dart';
import 'car_info_screen.dart';


class RegisterScreenDriver extends StatefulWidget {
  const RegisterScreenDriver({Key? key}) : super(key: key);

  @override
  State<RegisterScreenDriver> createState() => _RegisterScreenDriverState();
}

class _RegisterScreenDriverState extends State<RegisterScreenDriver> {

  final nationalidTextEditingController = TextEditingController();
  Gender? selectedGender;
  File? image;
  final firstnameTextEditingController = TextEditingController();
  final secondnameTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();

  //final nationalidTextEditingController = TextEditingController();
  final addressTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final confirmTextEditingController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    // validate all the form fields
      await firebaseAuth.createUserWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim()
      ).then((auth) async {
        currentUser = auth.user;

        if(currentUser != null){
          Map userMap = {
            "id": currentUser!.uid,
            "firstname": firstnameTextEditingController.text.trim(),
            "secondname": secondnameTextEditingController.text.trim(),
            "nationalid": nationalidTextEditingController.text.trim(),
            "email": emailTextEditingController.text.trim(),
            "address": addressTextEditingController.text.trim(),
            "gender": selectedGender,
            "status": "offline",
            "rid": "free",
          };

          DatabaseReference userRef = FirebaseDatabase.instance.ref().child("drivers");
          userRef.child(currentUser!.uid).set(userMap);

        }
        await Fluttertoast.showToast(msg: "Successfully Registered");
        Navigator.push(context, MaterialPageRoute(builder: (c) => CarInfoScreen()));
      }).catchError((errorMessage) {
        Fluttertoast.showToast(msg: "Error occurred: \n $errorMessage");
      });

  }

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
    image = await pickImage(context);
    setState(() {});
  }

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
                            Text(
                              'Register',
                              style: TextStyle(
                                color: darkTheme
                                    ? Colors.amber.shade400
                                    : Colors.blue,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () => selectImage(),
                              child: image == null
                                  ? const CircleAvatar(
                                backgroundColor: Colors.purple,
                                radius: 50,
                                child: Icon(
                                  Icons.account_circle,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              )
                                  : CircleAvatar(
                                backgroundImage: FileImage(image!),
                                radius: 50,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 171,
                                  child: TextFormField(
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(50)
                                    ],
                                    decoration: InputDecoration(
                                        hintText: "First Name",
                                        hintStyle: const TextStyle(
                                            color: Colors.grey),
                                        filled: true,
                                        fillColor: darkTheme
                                            ? Colors.black45
                                            : Colors.grey.shade200,
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                40),
                                            borderSide: const BorderSide(
                                              width: 0,
                                              style: BorderStyle.none,
                                            )),
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: darkTheme
                                              ? Colors.amber.shade400
                                              : Colors.grey,
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
                                SizedBox(width: 9,),
                                SizedBox(
                                  width: 171,
                                  child: TextFormField(
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(50)
                                    ],
                                    decoration: InputDecoration(
                                        hintText: "Second Name",
                                        hintStyle: const TextStyle(
                                            color: Colors.grey),
                                        filled: true,
                                        fillColor: darkTheme
                                            ? Colors.black45
                                            : Colors.grey.shade200,
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                40),
                                            borderSide: const BorderSide(
                                              width: 0,
                                              style: BorderStyle.none,
                                            )),
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: darkTheme
                                              ? Colors.amber.shade400
                                              : Colors.grey,
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
                              decoration: InputDecoration(
                                  hintText: "National ID",
                                  hintStyle: const TextStyle(
                                      color: Colors.grey),
                                  filled: true,
                                  fillColor: darkTheme
                                      ? Colors.black45
                                      : Colors.grey.shade200,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                      borderSide: const BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      )),
                                  prefixIcon: Icon(
                                    Icons.person_pin_rounded,
                                    color: darkTheme
                                        ? Colors.amber.shade400
                                        : Colors.grey,
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

                            Row(
                              children: <Widget>[
                                Expanded( // Expand to take available space
                                  child: ListTile(
                                    title: Text('Male'),
                                    leading: Radio<Gender>(
                                      value: Gender.male,
                                      groupValue: selectedGender,
                                      onChanged: null,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListTile(
                                    title: Text('Female'),
                                    leading: Radio<Gender>(
                                      value: Gender.female,
                                      groupValue: selectedGender,
                                      onChanged: null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(100)
                              ],
                              decoration: InputDecoration(
                                hintText: "Email",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                filled: true,
                                fillColor: darkTheme
                                    ? Colors.black45
                                    : Colors.grey.shade200,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    )),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: darkTheme
                                      ? Colors.amber.shade400
                                      : Colors.grey,
                                ),
                              ),
                              autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Email can\'t be empty';
                                }
                                if (EmailValidator.validate(text) == true) {
                                  return null;
                                }
                                if (text.length < 2) {
                                  return "Please enter a valid email";
                                }
                                if (text.length > 99) {
                                  return "Email can\'t be more than 100";
                                }
                              },
                              onChanged: (text) =>
                                  setState(() {
                                    emailTextEditingController.text = text;
                                  }),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(100)
                              ],
                              decoration: InputDecoration(
                                hintText: "Address",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                filled: true,
                                fillColor: darkTheme
                                    ? Colors.black45
                                    : Colors.grey.shade200,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    )),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: darkTheme
                                      ? Colors.amber.shade400
                                      : Colors.grey,
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
                            TextFormField(
                              obscureText: !_passwordVisible,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(100)
                              ],
                              decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: const TextStyle(color: Colors.grey),
                                // TextStyle
                                filled: true,
                                fillColor: darkTheme
                                    ? Colors.black45
                                    : Colors.grey.shade200,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    )),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: darkTheme
                                      ? Colors.amber.shade400
                                      : Colors.grey,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                      _passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: darkTheme
                                          ? Colors.amber.shade400
                                          : Colors.grey),
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                              ),
                              autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Password can\'t be empty';
                                }
                                if (text.length < 6) {
                                  return "Please enter a valid Password";
                                }
                                if (text.length > 20) {
                                  return "Password can't be more than 20";
                                }
                                return null;
                              },
                              onChanged: (text) =>
                                  setState(() {
                                    passwordTextEditingController.text = text;
                                  }),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              obscureText: !_passwordVisible,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(100)
                              ],
                              decoration: InputDecoration(
                                hintText: "Confirm Password",
                                hintStyle: const TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: darkTheme
                                    ? Colors.black45
                                    : Colors.grey.shade200,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    )),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: darkTheme
                                      ? Colors.amber.shade400
                                      : Colors.grey,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: darkTheme
                                        ? Colors.amber.shade400
                                        : Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                              ),
                              autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Confirm Password can\'t be empty';
                                }
                                if (text !=
                                    passwordTextEditingController.text) {
                                  return "Password not match";
                                }
                                if (text.length < 6) {
                                  return "Confirm Please enter a valid Password";
                                }
                                if (text.length > 20) {
                                  return "Confirm Password can't be more than 20";
                                }
                                return null;
                              },
                              onChanged: (text) =>
                                  setState(() {
                                    confirmTextEditingController.text = text;
                                  }),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor:
                                  darkTheme ? Colors.black : Colors.white,
                                  backgroundColor: darkTheme
                                      ? Colors.amber.shade400
                                      : Colors.blue,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  minimumSize: Size(double.infinity, 50),
                                ),
                                onPressed: () {
                                  _submit();
                                  //storeData();
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
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) =>
                                            ForgotPasswordScreen()));
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: darkTheme
                                      ? Colors.amber.shade400
                                      : Colors.blue,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Have an account?",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (c) => PhoneScreen()));
                                  },
                                  child: Text(
                                    "Sign In",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: darkTheme
                                          ? Colors.amber.shade400
                                          : Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            )

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




  // void storeData() async {
  //   final ap = Provider.of<AuthProvide>(context, listen: false);
  //   Driverm userModel = UserModel(
  //       id: currentUser!.uid,
  //       firstname: firstnameTextEditingController.text.trim(),
  //       secondname: secondnameTextEditingController.text.trim(),
  //       email: emailTextEditingController.text.trim(),
  //       profilePic: "",
  //       phone: "",
  //       nationalid: nationalidTextEditingController.text.trim(),
  //       password: passwordTextEditingController.text.trim(),
  //       address: addressTextEditingController.text.trim(),
  //       rid: "free",
  //       rVehicleType: "car",
  //       gender: selectedGender.toString()
  //   );
  //
  //
  //   if (image != null) {
  //     ap.saveUserDataToFirebase(
  //       context: context,
  //       userModel: userModel,
  //       profilePic: image!,
  //       onSuccess: () {
  //         ap.saveUserDataToSP().then(
  //               (value) =>
  //               ap.setSignIn().then(
  //                     (value) =>
  //                     Navigator.pushAndRemoveUntil(
  //                         context,
  //                         MaterialPageRoute(
  //                           builder: (context) => const MainScreenDriver(),
  //                         ),
  //                             (route) => false),
  //               ),
  //         );
  //       },
  //     );
  //   } else {
  //     showSnackBar(context, "Please upload your profile photo");
  //   }
  // }

  Gender _determineGender() {
    String nationalId = nationalidTextEditingController.text;

    if (nationalId.length == 14) {
      int lastDigit = int.tryParse(nationalId[12]) ?? 0;
      return (lastDigit % 2 == 0) ? Gender.female : Gender.male;
    } else {
      return Gender.unknown;
    }
  }

}
enum Gender { male, female, unknown }

















