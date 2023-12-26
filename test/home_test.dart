import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:malibu/blocs/auth/auth_bloc.dart';
import 'package:malibu/blocs/bloc/draggable_sheet_bloc.dart';
import 'package:malibu/blocs/position/position_bloc.dart';
import 'package:malibu/components/search_bar/bloc/search_address_bloc.dart';
import 'package:malibu/models/user_model.dart';
import 'package:malibu/screens/home/bloc/new_ride_bloc.dart';
import 'package:malibu/screens/home/home_screen_client.dart';
import 'package:malibu/services/dio.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' hide Size;
import 'package:network_image_mock/network_image_mock.dart';

import 'mocks/blocs_mock.dart';
import 'mocks/login_response_mock.dart';
import 'mocks/places_response_mock.dart';

void main() {
  late final MockAuthBloc authBloc;
  late final MockPositionBloc positionBloc;
  setUpAll(() {
    authBloc = MockAuthBloc();
    positionBloc = MockPositionBloc();
    GetIt.I.registerSingleton<AuthBloc>(authBloc);
    GetIt.I.registerSingleton<PositionBloc>(positionBloc);
    GetIt.I.registerSingleton<DraggableSheetBloc>(DraggableSheetBloc());
    whenListen(
        authBloc,
        Stream.fromIterable([
          AuthLogged(
              User.fromJson(loginRes['user'] as Map<String, dynamic>), "")
        ]),
        initialState: AuthLogged(
            User.fromJson(loginRes['user'] as Map<String, dynamic>), ""));
    whenListen(positionBloc,
        Stream.fromIterable([PositionLoaded(position: Position(-70, 11))]),
        initialState: PositionLoading());
  });
  group('Home clients tests', () {
    testWidgets('Renders Home correctly', (tester) async {
      final newRideBloc = MockNewRideBloc();
      whenListen(
        newRideBloc,
        Stream.fromIterable([NewRideInitial()]),
        initialState: NewRideInitial(),
      );
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<PositionBloc>.value(
              value: positionBloc,
            ),
            BlocProvider(create: (context) => DraggableSheetBloc()),
            BlocProvider<NewRideBloc>.value(
              value: newRideBloc,
            ),
            BlocProvider(
              create: (context) => SearchAddressBloc(),
            ),
          ],
          child: const MaterialApp(home: HomeScreenClient()),
        ),
      );
      await tester.pump(const Duration(seconds: 5));
      expect(find.byType(MapWidget), findsOneWidget);
      expect(find.byType(SearchBar), findsOneWidget);
      expect(find.byType(DraggableScrollableSheet), findsOneWidget);
    });
    testWidgets(
        "Finds a place",
        (tester) => mockNetworkImagesFor(() async {
              final newRideBloc = MockNewRideBloc();
              whenListen(
                newRideBloc,
                Stream.fromIterable([NewRideInitial()]),
                initialState: NewRideInitial(),
              );
              await tester.pumpWidget(MultiBlocProvider(
                providers: [
                  BlocProvider<PositionBloc>.value(
                    value: positionBloc,
                  ),
                  BlocProvider(create: (context) => DraggableSheetBloc()),
                  BlocProvider<NewRideBloc>.value(
                    value: newRideBloc,
                  ),
                  BlocProvider(
                    create: (context) => SearchAddressBloc(),
                  ),
                ],
                child: const MaterialApp(home: HomeScreenClient()),
              ));
              final dioAdapter = DioAdapter(dio: dio);
              final point = (positionBloc.state as PositionLoaded).position;
              final location = "${point.lng}%2C${point.lat}";
              dioAdapter.onGet(
                  "https://api.mapbox.com/geocoding/v5/mapbox.places/Las%20Virtudes.json?country=ve&proximity=$location&language=es&access_token=pk.eyJ1IjoiZ3N1eGQiLCJhIjoiY2xwbGV3c2UzMDNjZjJrbGJ1MTJ5djJnYyJ9.7F2rvgLxf-gsIxyvulp6Sw",
                  (server) {
                server.reply(200, placesResponseMock);
              });
              await tester.pump(const Duration(seconds: 10));
              expect(find.byType(SearchBar), findsOneWidget);
              await tester.pump(const Duration(seconds: 10));
              await tester.enterText(
                  find.byType(TextField).last, "CC Las Virtudes");
              await tester.pump(const Duration(seconds: 5));
              expect(find.text("CC Las Virtudes"), findsNWidgets(2));
              await tester.pump(const Duration(seconds: 3));
              expect(find.byType(ListTile), findsOneWidget);
              await tester.tap(find.byType(ListTile));
              newRideBloc.emit(NewRideMarkerState(
                  position: Position(-70.205383, 11.658415)));
              await tester.pump(const Duration(seconds: 5));
              expect(find.text("CC Las Virtudes - Ciudad Comercial"),
                  findsNWidgets(3));
              await tester.pump(const Duration(seconds: 3));
              expect(find.byType(MapWidget), findsOneWidget);
            }));
  });
}
