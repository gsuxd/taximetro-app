import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malibu/components/search_bar/bloc/search_address_bloc.dart';
import 'package:malibu/screens/home/bloc/new_ride_bloc.dart';

class NearCarsList extends StatelessWidget {
  const NearCarsList({super.key, required this.scrollController});
  final ScrollController scrollController;
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
            height: 5,
          ),
        ),
        SliverToBoxAdapter(
            child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.03,
            ),
            IconButton(
              onPressed: () {
                context.read<NewRideBloc>().add(const NewRideMarkerEvent(
                      position: null,
                    ));
                context.read<SearchAddressBloc>().add(SearchInputClearEvent());
              },
              icon: const Icon(Icons.close),
              iconSize: 30,
              tooltip: "Cerrar",
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.04,
            ),
            Text(
              'Selecciona tu chofer',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        )),
        SliverToBoxAdapter(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.timelapse_outlined),
            const SizedBox(
              width: 5,
            ),
            Text(
              context.select<NewRideBloc, String>((bloc) {
                if (bloc.state is! NewRideMarkerState ||
                    (bloc.state as NewRideMarkerState).directionResult ==
                        null) {
                  return '';
                }
                final min = ((bloc.state as NewRideMarkerState)
                            .directionResult!
                            .duration /
                        60)
                    .round();
                if (min > 60) {
                  return '${(min / 60).floor()} h ${(min % 60).floor()} min';
                } else {
                  return '$min min';
                }
              }),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              width: 10,
            ),
            const Icon(Icons.directions_car_outlined),
            const SizedBox(
              width: 5,
            ),
            Text(
              context.select<NewRideBloc, String>((value) {
                final state = value.state;
                if (state is! NewRideMarkerState ||
                    state.directionResult == null) return '';
                return '${((value.state as NewRideMarkerState).directionResult!.distance / 1000).toStringAsFixed(2)} km';
              }),
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        )),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 15,
          ),
        ),
        SliverList.separated(
          separatorBuilder: (context, index) => const SizedBox(
            height: 10,
          ),
          itemBuilder: (context, index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: _ListItem(index),
          ),
          itemCount: 10,
        ),
      ],
    );
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem(this.index);
  final int index;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(
            'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'),
      ),
      title: Text('Conductor $index'),
      subtitle: const Text('1.10\$'),
      trailing: TextButton(
        onPressed: () {},
        child: const Text('Ver Info'),
      ),
    );
  }
}
