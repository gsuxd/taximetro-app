part of 'new_ride_bloc.dart';

sealed class NewRideState extends Equatable {
  const NewRideState();

  @override
  List<Object> get props => [];
}

final class NewRideInitial extends NewRideState {}

final class NewRideMarkerState extends NewRideState {
  final Position position;
  final DirectionResponse? directionResult;

  const NewRideMarkerState({required this.position, this.directionResult});

  @override
  List<Object> get props => [position];
}

final class NewRideRiderSelectedState extends NewRideState {
  final int riderId;

  const NewRideRiderSelectedState({
    required this.riderId,
  });

  @override
  List<Object> get props => [riderId];
}

final class NewRideRiderUnselectedState extends NewRideState {
  final int riderId;

  const NewRideRiderUnselectedState({
    required this.riderId,
  });

  @override
  List<Object> get props => [riderId];
}

final class NewRideRiderConfirmedState extends NewRideState {
  final int riderId;

  const NewRideRiderConfirmedState({
    required this.riderId,
  });

  @override
  List<Object> get props => [riderId];
}
