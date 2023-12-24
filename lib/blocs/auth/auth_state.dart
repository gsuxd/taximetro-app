part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthLogged extends AuthState {
  final User user;
  final String token;
  const AuthLogged(
    this.user,
    this.token,
  );

  @override
  List<Object> get props => [user, token];
}

final class AuthNotVerified extends AuthState {}

final class AuthNotLogged extends AuthState {}
