import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:malibu/blocs/auth/auth_bloc.dart';
import 'package:malibu/screens/auth/login_screen.dart';
import 'mocks/blocs_mock.dart';

void main() {
  late final MockAuthBloc authBloc;
  setUpAll(() {
    authBloc = MockAuthBloc();

    GetIt.I.registerSingleton<AuthBloc>(authBloc);
    whenListen(authBloc, Stream.fromIterable([AuthNotLogged()]),
        initialState: AuthNotLogged());
  });

  setUp(() {
    whenListen(authBloc, Stream.fromIterable([AuthNotLogged()]),
        initialState: AuthNotLogged());
  });
  group("Login Test", () {
    testWidgets("It Should render the login correctly", (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Taximetro'), findsOneWidget);
      expect(find.byType(Container), findsNWidgets(2));
    });

    testWidgets("Should get to login form and error", (widgetTester) async {
      bool calledToast = false;
      MethodChannel channel = const MethodChannel('PonnamKarthik/fluttertoast');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (message) {
        calledToast = true;
        return null;
      });
      await widgetTester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>(
            create: (v) => AuthBloc(),
            child: const LoginScreen(),
          ),
        ),
      );
      await widgetTester.pumpAndSettle();
      expect(find.text('Taximetro'), findsOneWidget);
      await widgetTester.tap(find.byKey(const Key('goLoginButton')));
      await widgetTester.pumpAndSettle();
      expect(find.text('Taximetro'), findsOneWidget);
      await widgetTester.enterText(
          find.byKey(const Key('emailField')), 'asd@asd.com');
      await widgetTester.enterText(
          find.byKey(const Key('passwordField')), '123456');
      await widgetTester.tap(find.byKey(const Key('loginButton')));
      await widgetTester.pumpAndSettle();
      expect(calledToast, true);
    });

    testWidgets("Should login successfully", (widgetTester) async {
      final bloc = AuthBloc();
      await widgetTester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: bloc,
            child: const LoginScreen(),
          ),
        ),
      );
      await widgetTester.pumpAndSettle();
      expect(find.text('Taximetro'), findsOneWidget);
      await widgetTester.tap(find.byKey(const Key('goLoginButton')));
      await widgetTester.pumpAndSettle();
      expect(find.text('Taximetro'), findsOneWidget);
      await widgetTester.enterText(
          find.byKey(const Key('emailField')), 'admin@admin.com');
      await widgetTester.enterText(
          find.byKey(const Key('passwordField')), '123456');
      await widgetTester.tap(find.byKey(const Key('loginButton')));
      await widgetTester.pumpAndSettle();
      expect(bloc.state.runtimeType, AuthLogged);
    });
  });
}
