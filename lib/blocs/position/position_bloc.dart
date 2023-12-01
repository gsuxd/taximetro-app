import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart' hide Position;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

part 'position_event.dart';
part 'position_state.dart';

class PositionBloc extends Bloc<PositionEvent, PositionState> {
  PositionBloc() : super(PositionInitial()) {
    on<PositionGetEvent>(_handlePositionGet);
    on<PositionUpdateEvent>(_handlePositionUpdate);
    on<PositionErrorEvent>(_handlePositionError);
  }

  void _handlePositionUpdate(
      PositionUpdateEvent event, Emitter<PositionState> emit) {
    emit(PositionLoaded(position: event.position));
  }

  void _handlePositionError(
      PositionErrorEvent event, Emitter<PositionState> emit) {
    emit(PositionError(message: event.message));
  }

  StreamSubscription<Position>? _sub;

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }

  void _handlePositionGet(
      PositionGetEvent event, Emitter<PositionState> emit) async {
    emit(PositionLoading());
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final userPermission = await Geolocator.requestPermission();
        if (userPermission == LocationPermission.deniedForever) {
          emit(const PositionError(
              message:
                  'Permiso de ubicación denegado, por favor habilítelo en la configuración de su dispositivo.'));
          return;
        }
      }
      final position = await Geolocator.getCurrentPosition();
      emit(PositionLoaded(
          position: Position(position.longitude, position.latitude)));
      _sub = Geolocator.getPositionStream().listen((event) {
        add(PositionUpdateEvent(
            position: Position(event.longitude, event.latitude)));
      }) as dynamic;
    } catch (e) {
      emit(PositionError(message: e.toString()));
    }
  }
}
