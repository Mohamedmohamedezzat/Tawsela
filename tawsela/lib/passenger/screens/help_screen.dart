import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> lunch(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw "Could not launch $url";
  }
}

class HelpScreen extends StatefulWidget {
  static const String id = "help_screen";

  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    var phonenumber = "+201111433441";
    var email = "mohmedmohamedezzat@gmail.com";
    var whatsapplink = "https://wa.me/+201111433441";
    return Scaffold(
        backgroundColor: Color(0xFFfdf9eb),
        appBar: AppBar(
          backgroundColor: Color(0xFFfdf9eb),
          title: Text(
            "Help Center",
            style: TextStyle(color: Color(0xFF3C4650) , fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.close,
              color: Color(0xFF3C4650),
            ),
            onPressed: () {
              // SystemNavigator.pop();
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Image.asset("images/help.png", scale: 3,),
                  Spacer(),
                  Text("How can we help you ?" ,style: TextStyle(color: Color(0xFF3C4650) ,fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Container(
                    width: 250,
                    height: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFF3C4650)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                launch("tel: $phonenumber");
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF3C4650)),
                              icon: Icon(Icons.phone, color: Color(0xFFEB9042),size: 30),
                              label: Text("Call Help Center",style: TextStyle(color:Color(0xFFfdf9eb),),),
                            ),
                            Divider(
                              color: Colors.white, // Customize the color
                              thickness: 1.0, // Adjust the thickness
                              indent: 10.0, // Add indentation from the start
                              endIndent: 100.0,
                              height: 30,
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                launch(whatsapplink);
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF3C4650)),
                              icon: Icon(Icons.chat, color: Color(0xFFEB9042),size: 30),
                              label: Text("Whatsapp Help Center",style: TextStyle(color:Color(0xFFfdf9eb),),),
                            ),
                            Divider(
                              color: Colors.grey, // Customize the color
                              thickness: 1.0, // Adjust the thickness
                              indent: 10.0, // Add indentation from the start
                              endIndent: 16.0,
                              height: 30,
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                launch("sms: $phonenumber ");
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF3C4650)),
                              icon: Icon(Icons.sms, color: Color(0xFFEB9042),size: 30),
                              label: Text("SMS Help Center",style: TextStyle(color:Color(0xFFfdf9eb),),),
                            ),
                            Divider(
                              color: Colors.white, // Customize the color
                              thickness: 1.0, // Adjust the thickness
                              indent: 10.0, // Add indentation from the start
                              endIndent: 20.0,
                              height: 30,
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                launch("mailto: $email");
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF3C4650)),
                              icon: Icon(Icons.email, color: Color(0xFFEB9042),size: 30),
                              label: Text("Email Help Center",style: TextStyle(color:Color(0xFFfdf9eb),),),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ],
          ),
        ));
  }
}
