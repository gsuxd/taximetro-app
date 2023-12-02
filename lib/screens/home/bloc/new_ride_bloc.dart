import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:malibu/api/directions.dart';
import 'package:malibu/blocs/bloc/draggable_sheet_bloc.dart';
import 'package:malibu/blocs/main.dart';
import 'package:malibu/blocs/position/position_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

part 'new_ride_event.dart';
part 'new_ride_state.dart';

class NewRideBloc extends Bloc<NewRideEvent, NewRideState> {
  NewRideBloc() : super(NewRideInitial()) {
    on<NewRideMarkerEvent>(_handleMarkerEvent);
    on<NewRideRiderSelectedEvent>(_handleRiderSelectedEvent);
    on<NewRideRiderUnselectedEvent>(_handleRiderUnselectedEvent);
    on<NewRideRiderConfirmedEvent>(_handleRiderConfirmedEvent);
  }

  PointAnnotationManager? pointAnnotationManager;
  PolylineAnnotationManager? polylineAnnotationManager;
  @override
  Future<void> close() {
    pointAnnotationManager?.deleteAll();
    pointAnnotationManager = null;
    return super.close();
  }

  void _handleMarkerEvent(
      NewRideMarkerEvent event, Emitter<NewRideState> emit) async {
    await pointAnnotationManager!.deleteAll();
    await polylineAnnotationManager!.deleteAll();
    if (event.position == null) {
      draggableSheetBlocInstance.add(DraggableSheetHideEvent());
      await Future.delayed(const Duration(milliseconds: 1000), () {
        emit(NewRideInitial());
      });
      return;
    }
    final Uint8List icon =
        (await rootBundle.load('assets/icons/map_marker.png'))
            .buffer
            .asUint8List();
    await pointAnnotationManager!.create(PointAnnotationOptions(
        geometry: Point(coordinates: event.position!).toJson(),
        image: icon,
        iconOffset: [0, -70],
        iconSize: 0.3));
    final location = (positionBlocInstance.state as PositionLoaded).position;
    final directionResult =
        await DirectionsApi.getDirections(location, event.position!);
    await polylineAnnotationManager!.create(PolylineAnnotationOptions(
        geometry: directionResult.geometry.toJson(),
        lineColor: Colors.blue.value,
        lineWidth: 5));
    emit(NewRideMarkerState(
        position: event.position!, directionResult: directionResult));
    await Future.delayed(const Duration(milliseconds: 400), () {
      draggableSheetBlocInstance.add(DraggableSheetAnchorEvent());
    });
  }

  void _handleRiderSelectedEvent(
      NewRideRiderSelectedEvent event, Emitter<NewRideState> emit) {
    emit(NewRideRiderSelectedState(riderId: event.riderId));
  }

  void _handleRiderUnselectedEvent(
      NewRideRiderUnselectedEvent event, Emitter<NewRideState> emit) {
    emit(NewRideRiderUnselectedState(riderId: event.riderId));
  }

  void _handleRiderConfirmedEvent(
      NewRideRiderConfirmedEvent event, Emitter<NewRideState> emit) {
    emit(NewRideRiderConfirmedState(riderId: event.riderId));
  }
}

final newRideBlocInstance = NewRideBloc();
