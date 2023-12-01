import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    on<ChangeThemeEvent>(_handleChangeColor);
  }

  void _handleChangeColor(ChangeThemeEvent event, Emitter<SettingsState> emit) {
    emit(SettingsChanged(event.brightness));
  }
}
