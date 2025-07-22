import 'package:amorgos_echoes/cubit/app_cubit_states.dart';
import 'package:amorgos_echoes/cubit/app_cubits.dart';
import 'package:amorgos_echoes/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../pages/navpages/main_page.dart';

class AppCubitLogics extends StatelessWidget {
  const AppCubitLogics({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubits, CubitStates>(
      builder: (context, state) {
        if (state is WelcomeState) {
          // Sobald wir auf der WelcomePage sind, laden wir die Beaches
         
          return const WelcomePage();
        }

        if (state is BeachLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is BeachesLoadedState) {
          // Hier übergeben wir die Liste an MainPage:
          return MainPage(beaches: state.beaches);
        }

        if (state is BeachErrorState) {
          return Center(child: Text('Error: ${state.message}'));
        }

        return const SizedBox.shrink();

      },
    );
  }
}

