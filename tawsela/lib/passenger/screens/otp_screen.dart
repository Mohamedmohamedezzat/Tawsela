import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import 'package:provider/provider.dart';
import 'package:users/passenger/screens/main_screen_passenger.dart';
import 'package:users/passenger/screens/register_screen_passenger.dart';

import '../global/global_passenger.dart';
import '../provider/phone_auth_provider.dart';
import '../utils/utils.dart';
import 'main_user.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;

  const OtpScreen({super.key, required this.verificationId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? otpCode;

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    final isLoading =
        Provider.of<AuthProvide>(context, listen: true).isLoading;
    return Scaffold(
      backgroundColor: Color(0xFFfdf9eb),
      body: SingleChildScrollView(
        child: SafeArea(
          child: isLoading == true
              ? const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          )
              : Center(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 35, horizontal: 25),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.arrow_back , color: Color(0xFF3C4650),),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Verification",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3C4650),
                    ),
                  ),
                  Image.asset("images/otp.jpg"),
                  const SizedBox(height: 10),
                  const Text(
                    "Enter the OTP send to your phone number",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black38,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Pinput(

                    length: 6,
                    showCursor: true,
                    defaultPinTheme: PinTheme(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color:  Color(0xFF3C4650),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.black
                        ),
                      ),
                      textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFfdf9eb)
                      ),
                    ),
                    onCompleted: (value) {
                      setState(() {
                        otpCode = value;
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // foregroundColor:
                        //     darkTheme ? Colors.black : Colors.white,
                        // backgroundColor:
                        //     darkTheme ? Colors.amber.shade400 : Colors.blue,
                        foregroundColor:  Color(0xFFFFFFFF),
                        backgroundColor:  Color(0xFFEB9042),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        fixedSize: Size(250, 50),
                      ),
                      onPressed: () {
                        if (otpCode != null) {
                          verifyOtp(context, otpCode!);
                        } else {
                          showSnackBar(context, "Enter 6-Digit code");
                        }
                      },
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      )),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // verify otp
  void verifyOtp(BuildContext context, String userOtp) {
    final ap = Provider.of<AuthProvide>(context, listen: false);
    ap.verifyOtp(
      context: context,
      verificationId: widget.verificationId,
      userOtp: userOtp,
      onSuccess: () {
        // checking whether user exists in the db
        ap.checkExistingUser().then(
          (value) async {
            // if (value == true) {
              // user exists in our app
              DatabaseReference userRef = FirebaseDatabase.instance
                  .ref()
                  .child("users")
                  .child(FirebaseAuth.instance.currentUser!.uid);

              userRef.once().then((snap){
                if(snap.snapshot.exists){
                  // Future(() async => await AssistantMethods.readCurrentOnlineUserInfo());
                  // Timer(Duration(seconds: 2), () {
                  Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>  MainUser()),
                            (route) => false);
                      // }
                  // });
                  // userModelCurrentInfo = UserModel.fromMap(snap.snapshot as Map<String, dynamic>);
                }else{
                  // Timer(Duration(seconds: 2), () {
                  Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreenPassenger()),
                            (route) => false);
                      // }                  // });
                }
              });
              // ap.getDataFromFirestore().then(
              //       (value) => ap.saveUserDataToSP().then(
              //             (value) => ap.setSignIn().then(
              //                   (value) => Navigator.pushAndRemoveUntil(
              //                       context,
              //                       MaterialPageRoute(
              //                         builder: (context) => const MainScreenpassenger(),
              //                       ),
              //                       (route) => false),
              //                 ),
              //           ),
              //     );
            // } else {
            //   // new user
            //   Navigator.pushAndRemoveUntil(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => const RegisterScreenPassenger()),
            //       (route) => false);
            // }
          },
        );
      },
    );
  }
}
