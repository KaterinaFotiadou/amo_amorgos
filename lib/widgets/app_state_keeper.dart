import 'package:flutter/widgets.dart';

class AppStateKeeper {
  static final AppStateKeeper _instance = AppStateKeeper._internal();
  factory AppStateKeeper() => _instance;
  AppStateKeeper._internal();

  Widget? lastActiveScreen;

  void save(Widget screen) {
    lastActiveScreen = screen;
  }

  Widget getOrDefault(Widget fallback) {
    return lastActiveScreen ?? fallback;
  }
}
