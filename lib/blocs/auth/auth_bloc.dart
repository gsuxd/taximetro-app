import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:malibu/api/auth.dart';
import 'package:malibu/blocs/listener.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late final BlocListener listenable;
  AuthBloc() : super(AuthInitial()) {
    listenable = BlocListener(this);
    on<LoadAuthEvent>(_handleLoad);
    on<AuthLoginEvent>(_handleLogin);
  }

  void _handleLoad(LoadAuthEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final userString = prefs.getString('user');
      final token = prefs.getString('token');
      if (userString != null) {
        final user = User.fromJson(jsonDecode(userString));
        emit(AuthLogged(user, token!));
      } else {
        throw Exception('No hay usuario guardado');
      }
    } catch (e) {
      emit(AuthNotLogged());
    }
  }

  void _handleLogin(AuthLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final res = await AuthApi.login(event.email, event.password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', jsonEncode(res.user.toJson()));
      await prefs.setString('token', jsonEncode(res.token));
      emit(AuthLogged(res.user, res.token));
    } catch (e) {
      if (e.toString() == 'EMAIL_NOT_VERIFIED') {
        await Fluttertoast.showToast(
          msg: 'El correo no ha sido verificado',
          toastLength: Toast.LENGTH_SHORT,
        );
        emit(AuthNotVerified());
        return;
      }
      await Fluttertoast.showToast(
        msg: 'Usuario o contraseña incorrectos',
        toastLength: Toast.LENGTH_SHORT,
      );
      emit(AuthNotLogged());
    }
  }
}
