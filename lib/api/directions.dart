import 'package:dio/dio.dart';
import 'package:malibu/conts.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class DirectionResponse {
  final double distance;
  final double duration;
  final GeoJSONObject geometry;

  DirectionResponse({
    required this.distance,
    required this.duration,
    required this.geometry,
  });

  factory DirectionResponse.fromJson(Map<String, dynamic> json) {
    return DirectionResponse(
      distance: json["distance"],
      duration: json["duration"],
      geometry: GeoJSONObject.fromJson(json['geometry']),
    );
  }
}

abstract class DirectionsApi {
  static Future<DirectionResponse> getDirections(Position a, Position b) async {
    try {
      final response = await Dio().get(
          "https://api.mapbox.com/directions/v5/mapbox/driving/${a.lng}%2C${a.lat}%3B${b.lng}%2C${b.lat}?alternatives=true&annotations=distance%2Cduration&geometries=geojson&overview=full&steps=false&access_token=$MAPBOX_ACCESS_TOKEN");
      final data = response.data;
      if (data["routes"] != null) {
        return DirectionResponse.fromJson(data["routes"][0]);
      }
      return DirectionResponse.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }
}
