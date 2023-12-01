part of 'draggable_sheet_bloc.dart';

sealed class DraggableSheetState extends Equatable {
  const DraggableSheetState();
  
  @override
  List<Object> get props => [];
}

final class DraggableSheetInitial extends DraggableSheetState {}
