part of 'search_address_bloc.dart';

sealed class SearchAddressEvent extends Equatable {
  const SearchAddressEvent();

  @override
  List<Object> get props => [];
}

final class SearchInputChangeEvent extends SearchAddressEvent {
  final String input;

  const SearchInputChangeEvent({required this.input});

  @override
  List<Object> get props => [input];
}

final class SearchInputClearEvent extends SearchAddressEvent {}

final class SearchInputSelectEvent extends SearchAddressEvent {
  final String input;

  const SearchInputSelectEvent({required this.input});

  @override
  List<Object> get props => [input];
}
