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

  @override
  void initState() {
    context.read<PositionBloc>().add(const PositionGetEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isDesktop = constraints.maxWidth > 640;
          return BlocListener<NewRideBloc, NewRideState>(
            listener: (context, state) async {
              if (state is NewRideMarkerState &&
                  (state).directionResult != null) {
                final bounds = CoordinateBounds(
                  northeast: {
                    'lng': (state).directionResult!.geometry.bbox!.lng1,
                    'lat': (state).directionResult!.geometry.bbox!.lat1,
                  },
                  infiniteBounds: false,
                  southwest: {
                    'lng': (state).directionResult!.geometry.bbox!.lat2,
                    'lat': (state).directionResult!.geometry.bbox!.lng2,
                  },
                );
                final camera = await mapboxMap!.cameraForCoordinateBounds(
                    bounds,
                    MbxEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
                    0,
                    0);
                await mapboxMap!
                    .flyTo(camera, MapAnimationOptions(duration: 2000));
              }
            },
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
                }
              },
              builder: (context, state) {
                return switch (state) {
                  PositionInitial() => Container(),
                  PositionError() => const Center(
                      child: Text('Error al obtener la ubicación'),
                    ),
                  PositionLoading() => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  PositionLoaded() => Stack(
                      children: [
                        MapWidget(
                          onMapCreated: _onMapCreated,
                          resourceOptions:
                              ResourceOptions(accessToken: MAPBOX_ACCESS_TOKEN),
                          // initialCameraPosition: CameraPosition(
                          //   target: state.position,
                          //   zoom: 17,
                          // ),
                          // myLocationEnabled: true,
                          // onTap: (position) {
                          //   context.read<NewRideBloc>().add(
                          //         NewRideMarkerEvent(position: position),
                          //       );
                          // },
                          // polylines: {
                          //   if (context.select<NewRideBloc, bool>(
                          //       (bloc) => bloc.polylinePoints != null))
                          //     Polyline(
                          //       polylineId: const PolylineId('newRidePolyline'),
                          //       points: context
                          //           .select<NewRideBloc, PolylineResult>(
                          //               (bloc) => bloc.polylinePoints!)
                          //           .points
                          //           .map((e) => LatLng(e.latitude, e.longitude))
                          //           .toList(),
                          //       color: Theme.of(context).primaryColor,
                          //       width: 5,
                          //     )
                          // },
                          // markers: {
                          //   if (context.select<NewRideBloc, bool>(
                          //       (bloc) => bloc.markerPosition != null))
                          //     Marker(
                          //       markerId: const MarkerId('newRideDestination'),
                          //       infoWindow: const InfoWindow(title: 'Destino'),
                          //       position: context.select<NewRideBloc, LatLng>(
                          //           (bloc) => bloc.markerPosition!),
                          //     )
                          // },
                        ),
                        Positioned(
                          top: isDesktop
                              ? constraints.maxHeight * 0.1
                              : constraints.maxHeight * 0.04,
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
                        Positioned(
                          top: isDesktop
                              ? constraints.maxHeight * 0.08
                              : constraints.maxHeight * 0.17,
                          width: isDesktop
                              ? constraints.maxWidth * 0.5
                              : constraints.maxWidth * 0.9,
                          left: constraints.maxWidth * 0.05,
                          child: const SearchAddress(),
                        ),
                        Positioned(
                          bottom: 0,
                          left: isDesktop ? constraints.maxWidth * 0.25 : 0,
                          height: constraints.maxHeight * 0.9,
                          width: isDesktop
                              ? constraints.maxWidth * 0.5
                              : constraints.maxWidth,
                          child: const MyDraggableSheet(),
                        )
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
