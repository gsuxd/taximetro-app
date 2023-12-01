part of 'settings_bloc.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

final class SettingsInitial extends SettingsState {}

final class SettingsChanged extends SettingsState {
  final Brightness brightness;
  const SettingsChanged(this.brightness);

  @override
  List<Object> get props => [brightness];
}
