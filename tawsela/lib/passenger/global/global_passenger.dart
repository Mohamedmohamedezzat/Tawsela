
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../passenger/models/direction_details_info.dart';
import '../models/active_nearby_drivers_type.dart';
import '../models/user_model.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

var currentUserUid = FirebaseAuth.instance.currentUser!.uid.toString();

User? currentUser;

UserModel? userModelCurrentInfo;
Map currentUserValue = {};

String cloudMessagingServerToken = "key=AAAABtiQzP4:APA91bFTLzNNnLGlU6Cdl-75HQLFHUOP7oLGJbCN_7kzGbzh3mFmS1F241dWxhdih3P02ih4k6omdxZdcq_m6lCX7YgqsnfAxUpic2oFGapKriffda3m4ebpOnJwFUVSQsqnkkBwArz_";

List driversList = [];
List<VehicleTypeInfo>? vehicleTypeInfoList = [];

// DatabaseReference referenceRideRequest = FirebaseDatabase.instance.ref();
String? rVehicleType;

DirectionDetailsInfo? tripDirectionDetailsInfo;
String userDropOffAddress = "";
String driverCarDetails = "";
String driverName = "";
String driverPhone = "";
String driverRatings = "";

double countRatingStars = 0.0;
String titleStarsRating = "";