import 'package:get_it/get_it.dart';
import 'package:malibu/blocs/position/position_bloc.dart';
import 'package:malibu/conts.dart';

import '../models/place_model.dart';
import '../services/dio.dart';

class PlacesApi {
  static Future<List<Place>> getSuggestions(String input) async {
    try {
      final point =
          (GetIt.I.get<PositionBloc>().state as PositionLoaded).position;
      final location = "${point.lng}%2C${point.lat}";
      final res = await dio.get(
          "https://api.mapbox.com/geocoding/v5/mapbox.places/Las%20Virtudes.json?country=ve&proximity=$location&language=es&access_token=$MAPBOX_ACCESS_TOKEN");
      return (res.data['features'] as List<dynamic>)
          .map((e) => Place.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
