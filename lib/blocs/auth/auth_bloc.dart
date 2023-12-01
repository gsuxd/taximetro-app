import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:malibu/blocs/listener.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late final BlocListener listenable;
  AuthBloc() : super(AuthInitial()) {
    listenable = BlocListener(this);
    on<LoadAuthEvent>(_handleLoad);
  }

  void _handleLoad(LoadAuthEvent event, Emitter<AuthState> emit) {
    emit(const AuthLogged({}));
  }
}
