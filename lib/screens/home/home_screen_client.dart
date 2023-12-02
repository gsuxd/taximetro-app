import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malibu/components/draggable_sheet/draggable_sheet.dart';
import 'package:malibu/components/search_bar/search_bar.dart';
import 'package:malibu/conts.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../blocs/position/position_bloc.dart';
import 'bloc/new_ride_bloc.dart';

class HomeScreenClient extends StatefulWidget {
  const HomeScreenClient({super.key});

  @override
  State<HomeScreenClient> createState() => _HomeScreenClientState();
}

class _HomeScreenClientState extends State<HomeScreenClient> {
  MapboxMap? mapboxMap;
  bool loaded = false;

  void _onTap(ScreenCoordinate point) {
    context.read<NewRideBloc>().add(NewRideMarkerEvent(
          position: Position(
            point.y,
            point.x,
          ),
        ));
  }

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    mapboxMap.setOnMapTapListener(_onTap);
    final pointManager =
        await mapboxMap.annotations.createPointAnnotationManager();
    final polylineManager =
        await mapboxMap.annotations.createPolylineAnnotationManager();
    // ignore: use_build_context_synchronously
    context.read<NewRideBloc>().pointAnnotationManager = pointManager;
    // ignore: use_build_context_synchronously
    context.read<NewRideBloc>().polylineAnnotationManager = polylineManager;
  }

  void _listener(context, state) async {
    if (state is NewRideMarkerState && (state).directionResult != null) {
      final bounds = CoordinateBounds(
        northeast: Point(
          coordinates: (state).directionResult!.geometry.coordinates.first,
        ).toJson(),
        infiniteBounds: false,
        southwest: Point(
          coordinates: (state).directionResult!.geometry.coordinates.last,
        ).toJson(),
      );
      const double padding = 100;
      final camera = await mapboxMap!.cameraForCoordinateBounds(
          bounds,
          MbxEdgeInsets(
              top: padding, left: padding, bottom: padding, right: padding),
          0,
          0);
      await mapboxMap!.flyTo(camera, MapAnimationOptions(duration: 2000));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isDesktop = constraints.maxWidth > 640;
          return BlocListener<NewRideBloc, NewRideState>(
            listener: _listener,
            child: BlocConsumer<PositionBloc, PositionState>(
              listener: (context, state) async {
                if (state is PositionLoaded) {
                  await Future.delayed(const Duration(seconds: 3));
                  await mapboxMap?.location
                      .updateSettings(LocationComponentSettings(enabled: true));
                  await mapboxMap?.flyTo(
                      CameraOptions(
                          center: Point(coordinates: state.position).toJson(),
                          zoom: 17),
                      MapAnimationOptions(duration: 2000));
                  await Future.delayed(const Duration(seconds: 2));
                  setState(() {
                    loaded = true;
                  });
                }
              },
              builder: (context, state) {
                return switch (state) {
                  PositionInitial() => Container(),
                  PositionError() => const Center(
                      child: Text('Error al obtener la ubicación'),
                    ),
                  PositionLoading() => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  PositionLoaded() => Stack(
                      children: [
                        MapWidget(
                          onMapCreated: _onMapCreated,
                          resourceOptions:
                              ResourceOptions(accessToken: MAPBOX_ACCESS_TOKEN),
                        ),
                        Positioned(
                          top: AppBar().preferredSize.height,
                          right: constraints.maxWidth * 0.05,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {},
                                child: const CircleAvatar(
                                    backgroundColor: Colors.black),
                              )
                            ],
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeOut,
                          top: loaded
                              ? isDesktop
                                  ? AppBar().preferredSize.height - 10
                                  : constraints.maxHeight * 0.17
                              : -100,
                          width: isDesktop
                              ? constraints.maxWidth * 0.5
                              : constraints.maxWidth * 0.9,
                          left: constraints.maxWidth * 0.05,
                          child: const SearchAddress(),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeOut,
                          bottom: loaded ? 0 : -100,
                          left: isDesktop ? constraints.maxWidth * 0.25 : 0,
                          height: constraints.maxHeight * 0.9,
                          width: isDesktop
                              ? constraints.maxWidth * 0.5
                              : constraints.maxWidth,
                          child: const MyDraggableSheet(),
                        ),
                        AnimatedOpacity(
                          opacity: context.select<NewRideBloc, double>(
                              (value) =>
                                  value is NewRideMarkerLoadingState ? 1 : 0),
                          duration: const Duration(seconds: 1),
                          child: Container(
                            height: constraints.maxHeight,
                            width: constraints.maxWidth,
                            color: Colors.black54,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator.adaptive(),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Encontrando ruta...',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                };
              },
            ),
          );
        },
      ),
    );
  }
}
