
import 'dart:async';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';


import '../../driver/Assistants/request_assistant.dart';
import '../../driver/models/trips_history_model_passenger.dart';
import '../../passenger/global/map_key.dart';
import '../../passenger/models/direction_details_info.dart';
import '../../passenger/models/directions.dart';
import '../../passenger/models/user_model.dart';
import '../global/global_driver.dart';
import '../infoHandler/info_driver.dart';
import '../models/car_model.dart';
import '../models/user_ride_request_information.dart';

class AssistantMethods {

  static readCurrentOnlineUserInfo() async {
    currentUser = firebaseAuth.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
      .ref()
      .child("drivers")
      .child(currentUser!.uid);

    userRef.once().then((snap){
      if(snap.snapshot.value != null){
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
      }
    });
  }

  static readCurrentOnlineUserCarInfo() async {
    DatabaseReference carRef = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(firebaseAuth.currentUser!.uid);

    carRef.once().then((snap){
      if(snap.snapshot.value != null){
        carModelCurrentInfo = CarModel.fromSnapshot(snap.snapshot);
      }
    });
  }

  static readOnTripInformation() async {
    if(userModelCurrentInfo!.rid != "free") {
      DatabaseReference tripRef = FirebaseDatabase.instance
          .ref()
          .child("All Ride Requests")
          .child(userModelCurrentInfo!.rid!);

      tripRef.once().then((snap){
        if(snap.snapshot.value != null){
          userRideRequestInformation = UserRideRequestInformation.fromSnapshot(snap.snapshot);
        }
      });
    }

    // print("RID: ${userModelCurrentInfo!.rid}");
  }

  static Future<String> searchAddressForGeographicCoOrdinates(Position position, context) async {

    String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    String humanReadableAddress = "";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if(requestResponse != "Error Occured. Failed. No Response."){
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude = position.latitude;
      userPickUpAddress.locationLongitude = position.longitude;
      userPickUpAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
    }

    return humanReadableAddress;
  }

  static Future<DirectionDetailsInfo> obtainOriginToDestinationDirectionDetails(LatLng originPosition, LatLng destinationPosition) async {

    String urlOriginToDestinationDirectionDetails = "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapKey";
    var responseDirectionApi = await RequestAssistant.receiveRequest(urlOriginToDestinationDirectionDetails);

    // if(responseDirectionApi == "Error Occured. Failed. No Response."){
    //   return "";
    // }

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
    directionDetailsInfo.e_points = responseDirectionApi["routes"][0]["overview_polyline"]["points"];

    directionDetailsInfo.distance_text = responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
    directionDetailsInfo.distance_value = responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];

    directionDetailsInfo.duration_text = responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
    directionDetailsInfo.duration_value = responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetailsInfo;
  }

  static pauseLiveLocationUpdates() {
    streamSubscriptionPosition!.pause();
    Geofire.removeLocation(firebaseAuth.currentUser!.uid);
  }

  static double calculateFareAmountFromOriginToDestination(DirectionDetailsInfo directionDetailsInfo)
  {
    double timeTraveledFareAmountPerMinute = (directionDetailsInfo.duration_value! / 60) * 0.1;
    double distanceTraveledFareAmountPerKilometer = (directionDetailsInfo.duration_value! / 1000) * 0.1;

    //USD
    double totalFareAmount = timeTraveledFareAmountPerMinute + distanceTraveledFareAmountPerKilometer;
    double localCurrencyTotalFare = totalFareAmount * 107;

    if(driverVehicleType == "Bike"){
      double resultFareAmount = ((localCurrencyTotalFare.truncate()) * 0.8);
      print("resultFareAmount Bike: ${resultFareAmount}");
      return resultFareAmount;
    }
    else if(driverVehicleType == "CNG"){
      double resultFareAmount = ((localCurrencyTotalFare.truncate()) * 1.5);
      print("resultFareAmount CNG: ${resultFareAmount}");
      return resultFareAmount;
    }
    else if(driverVehicleType == "Car"){
      double resultFareAmount = ((localCurrencyTotalFare.truncate()) * 2.0);
      print("resultFareAmount Car: ${resultFareAmount}");
      return resultFareAmount;
    }
    else{
      print("Fare: ${localCurrencyTotalFare.truncate().toDouble()}");
      return localCurrencyTotalFare.truncate().toDouble();
    }
    //return double.parse(localCurrencyTotalFare.toStringAsFixed(1));
  }

  //retrieve the trips keys for online user
  //trip key = ride request key
  static void readTripsKeysForOnlineDriver(context){
    FirebaseDatabase.instance.ref().child("All Ride Requests").orderByChild("driverId").equalTo(firebaseAuth.currentUser!.uid).once().then((snap){
      if(snap.snapshot.value != null){
        Map keysTripsId = snap.snapshot.value as Map;

        //count total number trips and share it with Provider
        int overAllTripsCounter = keysTripsId.length;
        Provider.of<AppInfo>(context, listen: false).updateOverAllTripsCounter(overAllTripsCounter);

        //share trips keys with Provider
        List<String> tripsKeysList = [];
        keysTripsId.forEach((key, value) {
          tripsKeysList.add(key);
        });
        Provider.of<AppInfo>(context, listen: false).updateOverAllTripsKeys(tripsKeysList);

        //get trips keys data - read trips complete information
        readTripsHistoryInformation(context);
      }
    });
  }

  static void readTripsHistoryInformation(context){
    var tripsAllKeys = Provider.of<AppInfo>(context, listen: false).historyTripsKeysList;

    for(String eachKey in tripsAllKeys){
      FirebaseDatabase.instance.ref().child("All Ride Requests").child(eachKey).once().then((snap){
        var eachTripHistory = TripsHistoryModel.fromSnapshot(snap.snapshot);

        if((snap.snapshot.value as Map)["status"] == "ended"){
          Provider.of<AppInfo>(context, listen: false).updateOverAllTripsHistoryInformation(eachTripHistory);
        }
      });
    }
  }

  //readDriverEarnings
  static void readDriverEarnings(context){
    FirebaseDatabase.instance.ref().child("drivers").child(firebaseAuth.currentUser!.uid).child("earnings").once().then((snap){
      if(snap.snapshot.value != null){
        String driverEarnings = snap.snapshot.value.toString();
        Provider.of<AppInfo>(context, listen: false).updateDriverTotalEarnings(driverEarnings);
      }
    });

    readTripsKeysForOnlineDriver(context);
  }

  static void readDriverRatings(context){
    FirebaseDatabase.instance.ref().child("drivers").child(firebaseAuth.currentUser!.uid).child("ratings").once().then((snap){
      if(snap.snapshot.value != null){
        String driverRatings = snap.snapshot.value.toString();
        Provider.of<AppInfo>(context, listen: false).updateDriverAverageRatings(driverRatings);
      }
    });
  }

}












