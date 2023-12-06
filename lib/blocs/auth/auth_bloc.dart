import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:malibu/blocs/listener.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late final BlocListener listenable;
  AuthBloc() : super(AuthInitial()) {
    listenable = BlocListener(this);
    on<LoadAuthEvent>(_handleLoad);
    on<AuthLoginEvent>(_handleLogin);
  }

  void _handleLoad(LoadAuthEvent event, Emitter<AuthState> emit) {
    emit(AuthNotLogged());
  }

  void _handleLogin(AuthLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    if (event.email == 'admin@admin.com' && event.password == '123456') {
      emit(const AuthLogged({}));
    } else {
      await Fluttertoast.showToast(
        msg: 'Usuario o contraseña incorrectos',
        toastLength: Toast.LENGTH_SHORT,
      );
      emit(AuthNotLogged());
    }
  }
}
