import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malibu/blocs/main.dart';
import 'package:malibu/screens/home/bloc/new_ride_bloc.dart';

import 'near_cars.dart';

class MyDraggableSheet extends StatefulWidget {
  const MyDraggableSheet({super.key});
  @override
  State<MyDraggableSheet> createState() => _MyDraggableSheetState();
}

class _MyDraggableSheetState extends State<MyDraggableSheet> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => DraggableScrollableSheet(
        key: draggableSheetBlocInstance.sheetKey,
        initialChildSize: context.select<NewRideBloc, bool>((bloc) =>
                bloc.state is NewRideMarkerState &&
                (bloc.state as NewRideMarkerState).directionResult != null)
            ? 0.2
            : 0.07,
        maxChildSize: context.select<NewRideBloc, bool>((bloc) =>
                bloc.state is NewRideMarkerState &&
                (bloc.state as NewRideMarkerState).directionResult != null)
            ? 1.0
            : 0.2,
        minChildSize: 0,
        expand: true,
        snap: true,
        snapSizes: [
          80 / constraints.maxHeight,
          if (context.select<NewRideBloc, bool>((bloc) =>
              bloc.state is NewRideMarkerState &&
              (bloc.state as NewRideMarkerState).directionResult != null))
            0.5,
        ],
        controller: draggableSheetBlocInstance.controller,
        builder: (BuildContext context, ScrollController scrollController) {
          return DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: BlocBuilder<NewRideBloc, NewRideState>(
              builder: (context, state) => switch (state) {
                NewRideRiderConfirmedState() ||
                NewRideMarkerLoadingState() ||
                NewRideRiderSelectedState() ||
                NewRideRiderUnselectedState() ||
                NewRideMarkerState() =>
                  NearCarsList(
                    scrollController: scrollController,
                  ),
                NewRideInitial() => _View(scrollController),
              },
            ),
          );
        },
      ),
    );
  }
}

class _View extends StatelessWidget {
  final ScrollController scrollController;
  const _View(this.scrollController);
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 7,
                width: 70,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 40,
          ),
        ),
        SliverToBoxAdapter(
          child: Text(
            'Selecciona un punto en el mapa o busca una dirección',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
