import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class Place {
  final String id;
  final String type;
  final List<String> placeType;
  final double relevance;
  final String text;
  final String placeName;
  final Position center;
  final Position geometry;

  Place({
    required this.geometry,
    required this.id,
    required this.placeType,
    required this.placeName,
    required this.relevance,
    required this.text,
    required this.type,
    required this.center,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      geometry: Position.fromJson(
          (json['geometry']['coordinates'] as List<dynamic>)
              .map((e) => double.parse(e.toString()))
              .toList()),
      id: json['id'],
      placeType: List<String>.from(json['place_type']),
      placeName: json['place_name'],
      relevance: json['relevance'] is int
          ? json['relevance'].toDouble()
          : json['relevance'],
      text: json['text'],
      type: json['type'],
      center: Position.fromJson((json['center'] as List<dynamic>)
          .map((e) => double.parse(e.toString()))
          .toList()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'geometry': geometry.toJson(),
      'id': id,
      'place_type': placeType,
      'place_name': placeName,
      'relevance': relevance,
      'text': text,
      'type': type,
      'center': center.toJson(),
    };
  }
}
