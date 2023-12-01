part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

final class ChangeThemeEvent extends SettingsEvent {
  final Brightness brightness;
  const ChangeThemeEvent(this.brightness);

  @override
  List<Object> get props => [brightness];
}
