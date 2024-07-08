import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

import '../provider/phone_auth_provider.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final TextEditingController phoneController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    phoneController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: phoneController.text.length,
      ),
    );
    return Scaffold(
      backgroundColor:  Color(0xFFfdf9eb),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 25),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3C4650),
                    ),
                  ),
                  Image.asset("images/login.png"),
                  const SizedBox(height: 10),
                  const Text(
                    "Add your phone number. \n We'll send you a verification code",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF808080),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  IntlPhoneField(
                    showCountryFlag: true,
                    dropdownTextStyle: TextStyle(color:  Color(0xFFfdf9eb)),
                    dropdownIcon: Icon(
                      Icons.arrow_drop_down,
                      // color: darkTheme
                      //     ? Colors.amber.shade400
                      //     : Colors.grey,
                      color : Color(0xFFfdf9eb),
                    ),
                    style: TextStyle(color:  Color(0xFFfdf9eb)),
                    decoration: InputDecoration(
                      hintText: "Phone Number",
                      hintStyle: const TextStyle(color: Color(0xFF808080)),
                      // TextStyle
                      filled: true,
                      // fillColor: darkTheme
                      //     ? Colors.black45
                      //     : Colors.grey.shade200,
                      fillColor: Color(0xFF3C4650),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          )),
                    ),
                    onChanged: (text) => setState(() {
                      phoneController.text =
                          text.completeNumber;
                    }),
                    initialCountryCode: "EG",
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // foregroundColor: darkTheme ? Colors.black : Colors.white, backgroundColor: darkTheme
                      // ? Colors.amber.shade400
                      // : Colors.blue,
                        elevation: 0,
                        foregroundColor:  Color(0xFFFFFFFF),
                        backgroundColor:  Color(0xFFEB9042),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        // Rounded Rectangle Border
                        minimumSize: Size(double.infinity, 50)),
                    onPressed: () {
                      sendPhoneNumber();
                    },
                    child: Text('Send me otp',
                        style: TextStyle(
                          fontSize: 20,
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void sendPhoneNumber() {
    final ap = Provider.of<AuthProvide>(context, listen: false);
    String phoneNumber = phoneController.text.trim();
    ap.signInWithPhone(context, "$phoneNumber");
  }
}
