
import 'dart:async';

// import 'package:assets_audio_player/assets_audio_player.dart';
// import '';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';

import '../../passenger/models/user_model.dart';
import '../models/car_model.dart';
import '../models/driver_model.dart';
import '../models/user_ride_request_information.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentUser;

StreamSubscription<Position>? streamSubscriptionPosition;
StreamSubscription<Position>? streamSubscriptionDriverLivePosition;

// AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();

UserModel? userModelCurrentInfo;
CarModel? carModelCurrentInfo;
UserRideRequestInformation? userRideRequestInformation;

Position? driverCurrentPosition;

DriverModel onlineDriverData = DriverModel();

String? driverVehicleType = "";

String titleStarsRating = "Good";

RemoteMessage? savedRemoteMessage;