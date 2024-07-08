

import 'package:firebase_database/firebase_database.dart';

class CarModel {
  String? color;
  String? model;
  String? number;
  String? type;

  CarModel({
    this.color,
    this.model,
    this.number,
    this.type,
  });

  CarModel.fromSnapshot(DataSnapshot snap){
    color = (snap.value as dynamic)["car_details"]["car_color"];
    model = (snap.value as dynamic)["car_details"]["car_model"];
    number = (snap.value as dynamic)["car_details"]["car_number"];
    type = (snap.value as dynamic)["car_details"]["type"];
  }
}