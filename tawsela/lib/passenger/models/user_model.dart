import 'package:firebase_database/firebase_database.dart';

class UserModel {
  String? phone;
  String? firstname;
  String? secondname;
  String? id;
  String? email;
  String? address;
  String? rid;
  String? profilePic;
  String? nationalid;
  String? password;
  String? rVehicleType;
  String? gender;

  UserModel({
     this.firstname,
     this.secondname,
     this.phone,
     this.email,
     this.id,
     this.address,
     this.rid,
     this.profilePic,
     this.nationalid,
     this.password,
     this.rVehicleType,
     this.gender,
  });

  UserModel.fromSnapshot(DataSnapshot snap){
    phone = (snap.value as dynamic)["phone"];
    firstname = (snap.value as dynamic)["firstname"];
    secondname = (snap.value as dynamic)["secondname"];
    id = snap.key!;
    email = (snap.value as dynamic)["email"];
    address = (snap.value as dynamic)["address"];
    rid = (snap.value as dynamic)["rid"];
    profilePic = (snap.value as dynamic)["profilePic"];
    nationalid = (snap.value as dynamic)["nationalid"];
    password = (snap.value as dynamic)["password"];
    rVehicleType = (snap.value as dynamic)["rVehicleType"];
  }


  // from map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      firstname: map['firstname'] ?? '',
      secondname: map['secondname'] ?? '',
      email: map['email'] ?? '',
      id: map['id'] ?? '',
      phone: map['phone'] ?? '',
      profilePic: map['profilePic'] ?? '',
      address: map['address'] ?? '',
      nationalid: map['nationalid'] ?? '',
      password: map['password'] ?? '',
      rVehicleType: map['rVehicleType'] ?? '',
      rid: map['rid'] ?? '',
      gender: map['gender'] ?? '',
    );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      "firstname": firstname,
      "secondname": secondname,
      "email": email,
      "id": id,
      "profilePic": profilePic,
      "phone": phone,
      "address":address,
      "nationalid":nationalid,
      "password":password,
      "rVehicleType":rVehicleType,
      "gender":gender,
    };
  }

}