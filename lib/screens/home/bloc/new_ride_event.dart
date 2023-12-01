part of 'new_ride_bloc.dart';

sealed class NewRideEvent extends Equatable {
  const NewRideEvent();

  @override
  List<Object> get props => [];
}

final class NewRideMarkerEvent extends NewRideEvent {
  final Position position;

  const NewRideMarkerEvent({
    required this.position,
  });

  @override
  List<Object> get props => [position];
}

final class NewRideRiderSelectedEvent extends NewRideEvent {
  final int riderId;

  const NewRideRiderSelectedEvent({
    required this.riderId,
  });

  @override
  List<Object> get props => [riderId];
}

final class NewRideRiderUnselectedEvent extends NewRideEvent {
  final int riderId;

  const NewRideRiderUnselectedEvent({
    required this.riderId,
  });

  @override
  List<Object> get props => [riderId];
}

final class NewRideRiderConfirmedEvent extends NewRideEvent {
  final int riderId;

  const NewRideRiderConfirmedEvent({
    required this.riderId,
  });

  @override
  List<Object> get props => [riderId];
}
