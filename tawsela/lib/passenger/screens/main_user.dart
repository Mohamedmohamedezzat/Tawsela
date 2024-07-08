import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:users/passenger/screens/profile_user.dart';
import 'package:users/passenger/screens/trips_history.dart';
import 'package:users/passenger/screens/trips_history_screen.dart';
import 'package:users/passenger/screens/trips_passenger.dart';
import 'package:users/passenger/screens/userActiveTrip.dart';


class MainUser extends StatefulWidget {
  @override
  State<MainUser> createState() => _mainUser();

}

class _mainUser extends State<MainUser>{
  List screensClass = [TripsPassenger(),UserActiveTrip(),Trips_history(),ProfileUser()
    ];
  List screensName = ["Home","Current Trip","History","Profile"];
  List screensIconsFilled = [Icons.home,Icons.drive_eta
    ,Icons.history,Icons.person];
  List screensIconsOut = [Icons.home_outlined,Icons.drive_eta_outlined
    ,Icons.history_outlined,Icons.person];

  int selectedIndex = 0;

  void onItemTapped(int index) {
    if (index == 0) {
      setState(() {
        screensClass[0] = TripsPassenger();
        selectedIndex = 0;
      });
    } else if (index == 1) {
      setState(() {
        screensClass[1] = UserActiveTrip();
        selectedIndex = 1;
      });
    } else if (index == 2) {
      setState(() {
        screensClass[2] = Trips_history();
        selectedIndex = 2;
      });
    } else {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color(0xFFfdf9eb),
        color: const Color(0xFF3C4650),
        index: selectedIndex,
        onTap: onItemTapped,
        items: [
          CurvedNavigationBarItem(
              child: Icon(Icons.home, color: Color(0xFFfdf9eb)),
              label: "Trips",
              labelStyle: TextStyle(color: Color(0xFFfdf9eb))),
          CurvedNavigationBarItem(
              child: Icon(Icons.drive_eta, color: Color(0xFFfdf9eb)),
              label: "Current",
              labelStyle: TextStyle(color: Color(0xFFfdf9eb))),
          CurvedNavigationBarItem(
              child: Icon(Icons.history, color: Color(0xFFfdf9eb)),
              label: "History",
              labelStyle: TextStyle(color: Color(0xFFfdf9eb))),
          CurvedNavigationBarItem(
              child: Icon(Icons.person, color: Color(0xFFfdf9eb)),
              label: "Profile",
              labelStyle: TextStyle(color: Color(0xFFfdf9eb))),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: selectedIndex,
              children: List.generate(screensClass.length,
                      (index) => screensClass.elementAt(index)),
            ),
          ),
          // Container(
          //   padding: const EdgeInsets.symmetric(vertical: 4),
          //   child: Row(
          //     children: List.generate(screensClass.length, (index) {
          //       return Expanded(
          //         child: InkWell(
          //           onTap: () => onItemTapped(index),
          //           child: Padding(
          //             padding: const EdgeInsets.all(2.0),
          //             child: Column(
          //               children: [
          //                 // Icon(
          //                 //   selectedIndex == index
          //                 //       ? screensIconsFilled.elementAt(index)
          //                 //       : screensIconsOut.elementAt(index),
          //                 //   size: 28,
          //                 //   color: selectedIndex == index
          //                 //       ? Colors.blue.shade600
          //                 //       : Colors.black38,
          //                 // ),
          //                 // const SizedBox(height: 4),
          //                 // Text(
          //                 //   screensName.elementAt(index),
          //                 //   style: TextStyle(
          //                 //     color: selectedIndex == index
          //                 //         ? Colors.blue.shade600
          //                 //         : Colors.black38,
          //                 //     fontSize: 13,
          //                 //   ),
          //                 // )
          //               ],
          //             ),
          //           ),
          //         ),
          //       );
          //     }),
          //   ),
          // ),
        ],
      ),
    );
  }

}