import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:malibu/blocs/position/position_bloc.dart';
import 'package:malibu/router.dart';

void main() {
  final positionBloc = PositionBloc();
  GetIt.I.registerSingleton<PositionBloc>(positionBloc);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final contextKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Taximetro',
      routerConfig: router,
      key: contextKey,
      restorationScopeId: 'app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
    );
  }
}
