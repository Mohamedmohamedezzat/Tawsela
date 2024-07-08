import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class UploadTrip {

  UploadTrip(
      this.from,
      this.fromLatitude,
      this.toLatitude,
      this.fromLongtude,
      this.toLongtude,
      this.fromName,
      this.toName,
      this.state,
      this.payment,
      this.road,
      this.passenger,
      this.stops
      );

  String from;
     double fromLatitude,
      toLatitude,
      fromLongtude,
      toLongtude;
         String fromName,
      toName,
      state,
             payment,
      road,
      passenger;
  List stops;

  UploadTrip.fromJson(Map<dynamic,dynamic> json)
    :from = json['from'] as String ,
        fromLatitude = json['fromLatitude'] as double ,
        toLatitude = json['toLatitude'] as double ,
        fromLongtude = json['fromLongtude'] as double ,
        toLongtude = json['toLongtude'] as double ,
        fromName = json['fromName'] as String,
        toName = json['toName'] as String,
        state= json['state'] as String,
        payment= json['payment'] as String,
        road= json['road'] as String,
        passenger = json['passenger'] as String,
  stops = json['stops'] as List;

  Map<dynamic, dynamic> toJson() =>
      <dynamic, dynamic>{
        'from': from,
        'fromLatitude': fromLatitude,
        'toLatitude': toLatitude,
        'fromLongtude': fromLongtude,
        'toLongtude': toLongtude,
        'fromName': fromName,
        'toName': toName,
        'state': state,
        'payment': payment,
        'road': road,
        'passenger': passenger,
        'stops': stops,
      };
}