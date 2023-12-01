part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthLogged extends AuthState {
  final dynamic user;
  const AuthLogged(
    this.user,
  );

  @override
  List<Object> get props => [user];
}

final class AuthNotVerified extends AuthState {}

final class AuthNotLogged extends AuthState {}
