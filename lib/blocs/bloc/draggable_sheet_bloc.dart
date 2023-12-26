import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

part 'draggable_sheet_event.dart';
part 'draggable_sheet_state.dart';

class DraggableSheetBloc
    extends Bloc<DraggableSheetEvent, DraggableSheetState> {
  final sheetKey = GlobalKey();
  final controller = DraggableScrollableController();

  DraggableSheetBloc() : super(DraggableSheetInitial()) {
    controller.addListener(() {
      add(DraggableSheetUpdateEvent());
    });
    on<DraggableSheetCollapseEvent>(_handleCollapseEvent);
    on<DraggableSheetAnchorEvent>(_handleAnchorEvent);
    on<DraggableSheetExpandEvent>(_handleExpandEvent);
    on<DraggableSheetHideEvent>(_handleHideEvent);
    on<DraggableSheetUpdateEvent>(_handleUpdateEvent);
  }

  void _animateSheet(double size) {
    controller.animateTo(
      size,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeInOut,
    );
  }

  @override
  Future<void> close() async {
    controller.dispose();
    try {
      await GetIt.I.unregister<DraggableSheetBloc>();
    } catch (e) {
      e;
    }
    return super.close();
  }

  DraggableScrollableSheet get sheet =>
      (sheetKey.currentWidget as DraggableScrollableSheet);

  void _handleUpdateEvent(
      DraggableSheetUpdateEvent event, Emitter<DraggableSheetState> emit) {
    final currentSize = controller.size;
    if (currentSize <= 0.05) add(DraggableSheetCollapseEvent());
  }

  void _handleCollapseEvent(DraggableSheetCollapseEvent event,
          Emitter<DraggableSheetState> emit) =>
      _animateSheet(sheet.snapSizes!.first);

  void _handleAnchorEvent(
          DraggableSheetAnchorEvent event, Emitter<DraggableSheetState> emit) =>
      _animateSheet(sheet.snapSizes!.last);

  void _handleExpandEvent(
          DraggableSheetExpandEvent event, Emitter<DraggableSheetState> emit) =>
      _animateSheet(sheet.maxChildSize);

  void _handleHideEvent(
          DraggableSheetHideEvent event, Emitter<DraggableSheetState> emit) =>
      _animateSheet(sheet.minChildSize);
}
