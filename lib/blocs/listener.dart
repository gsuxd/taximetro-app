import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class BlocListener extends ChangeNotifier {
  late StreamSubscription _subscription;

  BlocListener(Bloc bloc) {
    _subscription = bloc.stream.listen((state) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
