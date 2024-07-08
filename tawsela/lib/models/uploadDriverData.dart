import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class UploadDriverData {

  UploadDriverData(
      this.carModel,
      this.carCompany,
      this.modelYear,
      this.carColor,
      this.plateNumber,
      this.carLicenceFront,
      this.carLicenceBack,
      this.driverLicence
      );

  String carModel,
      carCompany,
      modelYear,
      carColor,
      plateNumber,
      carLicenceFront,
      carLicenceBack,
      driverLicence;

  UploadDriverData.fromJson(Map<dynamic,dynamic> json)
    :carModel = json['carModel'] as String ,
        carCompany = json['carCompany'] as String ,
        modelYear = json['modelYear'] as String ,
        carColor = json['carColor'] as String ,
        plateNumber = json['plateNumber'] as String,
        carLicenceFront= json['carLicenceFront'] as String,
        carLicenceBack= json['carLicenceBack'] as String,
        driverLicence = json['driverLicence'] as String;

  Map<dynamic, dynamic> toJson() =>
      <dynamic, dynamic>{
        'carModel': carModel,
        'carCompany': carCompany,
        'modelYear': modelYear,
        'carColor': carColor,
        'plateNumber': plateNumber,
        'carLicenceFront': carLicenceFront,
        'carLicenceBack': carLicenceBack,
        'driverLicence': driverLicence,
      };
}