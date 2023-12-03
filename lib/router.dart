import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:malibu/screens/home/bloc/new_ride_bloc.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/main.dart';
import 'blocs/position/position_bloc.dart';
import 'components/search_bar/bloc/search_address_bloc.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen_client.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/settings/settings_screen.dart';

String? _handleRedirect(BuildContext context, GoRouterState state) {
  final authState = authBlocInstance.state;
  if (authState is AuthLoading && state.path != '/loading') {
    return '/loading';
  }
  final logged = authState is AuthLogged;
  final route = state.uri.path;
  final isInLogin = route.contains('/login');
  final isLoading = route.contains('/loading');
  if (logged && (isInLogin || isLoading)) {
    return '/home';
  } else if (authState is AuthNotVerified &&
      !state.path!.contains('verifyUser')) {
    return '/verifyUser';
  } else if (!logged &&
      (!isInLogin || isLoading || !state.uri.path.contains('verifyUser'))) {
    return '/login';
  }
  return null;
}

final router = GoRouter(
    redirect: _handleRedirect,
    routes: _routes,
    initialLocation: '/login',
    refreshListenable: authBlocInstance.listenable);

final _routes = [
  ..._authRoutes,
  ..._homeRoutes,
  ..._profileRoutes,
  ..._settingsRoutes,
];

final _authRoutes = [
  GoRoute(
    path: '/login',
    name: 'Login',
    builder: (context, state) => const LoginScreen(),
  )
];

final _homeRoutes = [
  GoRoute(
    path: '/home',
    name: 'Home',
    builder: (context, state) => MultiBlocProvider(
      providers: [
        BlocProvider<PositionBloc>(
          create: (context) =>
              positionBlocInstance..add(const PositionGetEvent()),
        ),
        BlocProvider<NewRideBloc>(
          create: (context) => NewRideBloc(),
        ),
        BlocProvider(create: (context) => SearchAddressBloc()),
      ],
      child: const HomeScreenClient(),
    ),
  )
];

final _profileRoutes = [
  GoRoute(
    path: '/profile',
    name: 'Profile',
    builder: (context, state) => const ProfileScreen(),
  )
];

final _settingsRoutes = [
  GoRoute(
    path: '/settings',
    name: 'Settings',
    builder: (context, state) => const SettingsScreen(),
  )
];
