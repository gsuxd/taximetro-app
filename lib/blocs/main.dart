import 'package:malibu/blocs/auth/auth_bloc.dart';

import 'bloc/draggable_sheet_bloc.dart';
import 'position/position_bloc.dart';
import 'settings/settings_bloc.dart';

final authBlocInstance = AuthBloc()..add(LoadAuthEvent());
final settingsBlocInstance = SettingsBloc();
final positionBlocInstance = PositionBloc();
final draggableSheetBlocInstance = DraggableSheetBloc();
