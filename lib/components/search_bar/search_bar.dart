import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malibu/api/places_api.dart';
import 'package:malibu/screens/home/bloc/new_ride_bloc.dart';

import 'bloc/search_address_bloc.dart';

class SearchAddress extends StatelessWidget {
  const SearchAddress({super.key});
  FutureOr<List<Widget>> _suggestionsBuilder(
      BuildContext context, SearchController controller) async {
    if (controller.text.length < 3) return const [];
    try {
      final res = await PlacesApi.getSuggestions(controller.text);
      return res
          .map((e) => ListTile(
                onTap: () async {
                  controller.closeView(e.text);
                  FocusScopeNode currentFocus = FocusScope.of(context);

                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                  await Future.delayed(const Duration(milliseconds: 500));
                  context
                      .read<NewRideBloc>()
                      .add(NewRideMarkerEvent(position: e.center));
                },
                leading: Image.network(
                  "https://cdn0.iconfinder.com/data/icons/small-n-flat/24/678111-map-marker-512.png",
                  width: 30,
                  height: 30,
                ),
                title: Text(e.text),
              ))
          .toList();
    } catch (e) {
      return [
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                Icons.info,
                // ignore: use_build_context_synchronously
                color: Theme.of(context).colorScheme.error,
              ),
              Text(
                "Ocurrió un error, intenta de nuevo",
                // ignore: use_build_context_synchronously
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        )
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      suggestionsBuilder: (c, controller) =>
          _suggestionsBuilder(context, controller),
      builder: (c, s) => BlocListener<SearchAddressBloc, SearchAddressState>(
        listener: (context, state) {
          if (state is SearchAddressInitial) {
            s.clear();
          }
        },
        child: SearchBar(
          // width: MediaQuery.of(context).size.width * 0.9,
          // searchBarOpen: (a) => {a = 0},
          // textController: s,
          // helpText: "A dónde vamos hoy?",
          // onSuffixTap: () {
          //   s.clear();
          // },
          // onSubmitted: (p0) {
          //   s.text = p0;
          //   s.openView();
          // },

          hintText: "A dónde vamos hoy?",
          onChanged: (value) {
            s.openView();
          },
          onTap: () {
            s.openView();
          },
          controller: s,
          backgroundColor:
              MaterialStateColor.resolveWith((states) => Colors.white),
          leading: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
