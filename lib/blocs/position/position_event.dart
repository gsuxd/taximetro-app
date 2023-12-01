part of 'position_bloc.dart';

sealed class PositionEvent extends Equatable {
  const PositionEvent();

  @override
  List<Object> get props => [];
}

final class PositionUpdateEvent extends PositionEvent {
  final Position position;

  const PositionUpdateEvent({required this.position});

  @override
  List<Object> get props => [position];
}

final class PositionErrorEvent extends PositionEvent {
  final String message;

  const PositionErrorEvent({required this.message});

  @override
  List<Object> get props => [message];
}

final class PositionGetEvent extends PositionEvent {
  const PositionGetEvent();
}
