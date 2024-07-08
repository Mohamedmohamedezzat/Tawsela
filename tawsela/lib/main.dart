import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users/passenger/provider/phone_auth_provider.dart';
import 'package:users/passenger/screens/main_user.dart';
import 'package:users/passenger/screens/register_screen_passenger.dart';


import 'passenger/splashScreen/splash_screen.dart';
import 'passenger//themeProvider/theme_provider.dart';
import 'passenger/infoHandler/info_passenger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvide()),
        ChangeNotifierProvider(create: (context) => AppInfo())
      ],
      child: MaterialApp(
        title: 'Tawsillah',
        themeMode: ThemeMode.system,
        theme: MyThemes.lightTheme,
        darkTheme: MyThemes.darkTheme,
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}


