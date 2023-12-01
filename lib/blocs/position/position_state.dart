part of 'position_bloc.dart';

sealed class PositionState extends Equatable {
  const PositionState();

  @override
  List<Object> get props => [];
}

final class PositionInitial extends PositionState {}

final class PositionLoading extends PositionState {}

final class PositionLoaded extends PositionState {
  final Position position;

  const PositionLoaded({required this.position});

  @override
  List<Object> get props => [position];
}

final class PositionError extends PositionState {
  final String message;

  const PositionError({required this.message});

  @override
  List<Object> get props => [message];
}
