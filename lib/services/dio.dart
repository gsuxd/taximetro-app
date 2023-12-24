import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:malibu/conts.dart';

import '../blocs/auth/auth_bloc.dart';

final dio = Dio();

Future<void> initializeDio() async {
  InterceptorsWrapper(
    onRequest: (options, handler) {
      final authState = GetIt.I.get<AuthBloc>().state;
      if (authState is AuthLogged) {
        if (options.baseUrl.contains(API_URL)) {
          options.headers['Authorization'] = 'Token ${authState.token}';
        }
      }
      return handler.next(options);
    },
  );
}
