part of 'draggable_sheet_bloc.dart';

sealed class DraggableSheetEvent extends Equatable {
  const DraggableSheetEvent();

  @override
  List<Object> get props => [];
}

final class DraggableSheetCollapseEvent extends DraggableSheetEvent {}

final class DraggableSheetAnchorEvent extends DraggableSheetEvent {}

final class DraggableSheetExpandEvent extends DraggableSheetEvent {}

final class DraggableSheetHideEvent extends DraggableSheetEvent {}

final class DraggableSheetUpdateEvent extends DraggableSheetEvent {}
