part of 'search_address_bloc.dart';

sealed class SearchAddressState extends Equatable {
  const SearchAddressState();

  @override
  List<Object> get props => [];
}

final class SearchAddressInitial extends SearchAddressState {}

final class SearchAddressLoading extends SearchAddressState {}

final class SearchAddressError extends SearchAddressState {}

final class SearchAddressLoaded extends SearchAddressState {
  final List<String> suggestions;

  const SearchAddressLoaded({required this.suggestions});

  @override
  List<Object> get props => [suggestions];
}
