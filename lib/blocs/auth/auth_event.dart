part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;
  const AuthLoginEvent(
    this.email,
    this.password,
  );

  @override
  List<Object> get props => [email, password];
}

final class LogoutAuthEvent extends AuthEvent {}

final class LoadAuthEvent extends AuthEvent {}
