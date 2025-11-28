// File: lib/cubit/connectivity_cubit.dart

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Emits `true` when online and `false` when offline.
class ConnectivityCubit extends Cubit<bool> {
  final Connectivity _connectivity = Connectivity();
  late final StreamSubscription<ConnectivityResult> _subscription;

  ConnectivityCubit() : super(true) {
    initConnectivity();
  }

  /// Checks the current connectivity status and starts listening for changes.
  Future<void> initConnectivity() async {
    // Initial check
    final result = await _connectivity.checkConnectivity();
    emit(result != ConnectivityResult.none);

    // Subscribe to future changes
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      emit(result != ConnectivityResult.none);
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
