import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class UploadRequest {

  UploadRequest(
      this.from,
      this.tripId,
      this.state,
      // this.road,
      // this.passenger
      );

  String from;
  String tripId,
      state;
      // road,
      // passenger;

  UploadRequest.fromJson(Map<dynamic,dynamic> json)
    :from = json['from'] as String ,
        tripId = json['tripId'] as String,
        state= json['state'] as String;
        // road= json['road'] as String,
        // passenger = json['passenger'] as String;

  Map<dynamic, dynamic> toJson() =>
      <dynamic, dynamic>{
        'from': from,
        'tripId': tripId,
        'state': state,
        // 'road': road,
        // 'passenger': passenger,
      };
}