import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class UploadUser {

  UploadUser(
      this.address,
      this.token,
      this.nationalId,
      this.firstName,
      this.image,
      this.lastName,
      this.number,
      this.state,
      this.type,
      this.gender,
      this.nationalIdBackSide,
      this.nationalIdFrontSide,
      this.email,
      this.password
      );

  String address,
      token,
      nationalId,
      firstName,
      image,
      lastName,
      number,
      state,
  type,
  gender,
  nationalIdBackSide,
  nationalIdFrontSide,
  email,
   password;

  UploadUser.fromJson(Map<dynamic,dynamic> json)
    :address = json['address'] as String ,
        token = json['token'] as String ,
        nationalId = json['nationalId'] as String ,
    firstName = json['firstName'] as String,
    image= json['image'] as String,
    lastName= json['lastName'] as String,
    number = json['number'] as String,
    state = json['state']as String,
  type = json['type']as String,
  gender = json['gender']as String,
  nationalIdBackSide = json['nationalIdBackSide']as String,
  nationalIdFrontSide = json['nationalIdFrontSide']as String,
  email = json['email']as String,
  password = json['password']as String;

  Map<dynamic, dynamic> toJson() =>
      <dynamic, dynamic>{
        'address': address,
        'token': token,
        'nationalId': nationalId,
        'firstName': firstName,
        'image': image,
        'lastName': lastName,
        'number': number,
        'state': state,
        'type': type,
        'gender': gender,
        'nationalIdBackSide': nationalIdBackSide,
        'nationalIdFrontSide': nationalIdFrontSide,
        'email': email,
        'password': password,
      };
}