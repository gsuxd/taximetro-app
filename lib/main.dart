import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:malibu/blocs/position/position_bloc.dart';
import 'package:malibu/router.dart';

import 'blocs/auth/auth_bloc.dart';

void main() {
  final positionBloc = PositionBloc();
  final authBloc = AuthBloc();
  GetIt.I.registerSingleton<AuthBloc>(authBloc);
  GetIt.I.registerSingleton<PositionBloc>(positionBloc);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final contextKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GetIt.I<AuthBloc>(),
      child: MaterialApp.router(
        title: 'Taximetro',
        routerConfig: router,
        key: contextKey,
        restorationScopeId: 'app',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
      ),
    );
  }
}
