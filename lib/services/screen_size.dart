import 'package:flutter/material.dart';

import '../main.dart';

class ScreenSize {
  final double width;
  final double height;

  const ScreenSize(this.width, this.height);
}

final context = MyApp.contextKey.currentContext!;
final ScreenSize screenSize = ScreenSize(
    MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
