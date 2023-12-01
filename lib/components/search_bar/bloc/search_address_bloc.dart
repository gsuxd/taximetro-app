import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:malibu/api/places_api.dart';

part 'search_address_event.dart';
part 'search_address_state.dart';

class SearchAddressBloc extends Bloc<SearchAddressEvent, SearchAddressState> {
  SearchAddressBloc() : super(SearchAddressInitial()) {
    on<SearchInputChangeEvent>(_handleSearchInputChangeEvent);
    on<SearchInputClearEvent>(_handleSearchInputClearEvent);
    on<SearchInputSelectEvent>(_handleSearchInputSelectEvent);
  }

  void _handleSearchInputChangeEvent(
      SearchInputChangeEvent event, Emitter<SearchAddressState> emit) async {
    try {
      emit(SearchAddressLoading());
      final results = await PlacesApi.getSuggestions(event.input);
      emit(SearchAddressLoaded(
          suggestions: results.map((e) => e.text).toList()));
    } catch (e) {
      emit(SearchAddressError());
    }
  }

  void _handleSearchInputClearEvent(
      SearchInputClearEvent event, Emitter<SearchAddressState> emit) {
    emit(SearchAddressInitial());
  }

  void _handleSearchInputSelectEvent(
      SearchInputSelectEvent event, Emitter<SearchAddressState> emit) async {
    try {
      emit(SearchAddressLoading());
      final results = await PlacesApi.getSuggestions(event.input);
      emit(SearchAddressLoaded(
          suggestions: results.map((e) => e.text).toList()));
    } catch (e) {
      emit(SearchAddressError());
    }
  }
}
