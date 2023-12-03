import 'package:bloc_test/bloc_test.dart';
import 'package:malibu/blocs/auth/auth_bloc.dart';
import 'package:malibu/blocs/position/position_bloc.dart';
import 'package:malibu/components/search_bar/bloc/search_address_bloc.dart';
import 'package:malibu/screens/home/bloc/new_ride_bloc.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class MockPositionBloc extends MockBloc<PositionEvent, PositionState>
    implements PositionBloc {}

class MockNewRideBloc extends MockBloc<NewRideEvent, NewRideState>
    implements NewRideBloc {}

class MockSearchAddressBloc
    extends MockBloc<SearchAddressEvent, SearchAddressState>
    implements SearchAddressBloc {}
