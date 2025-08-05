import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amorgos_echoes/cubit/app_cubit_states.dart';
import 'package:amorgos_echoes/cubit/app_cubits.dart';
import 'package:amorgos_echoes/pages/welcome_page.dart';
import 'package:amorgos_echoes/pages/navpages/main_page.dart';
import '../widgets/app_state_keeper.dart';

class AppCubitLogics extends StatelessWidget {
  const AppCubitLogics({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubits, CubitStates>(
      builder: (context, state) {
        if (state is WelcomeState) {
          return const WelcomePage();
        } else if (state is BeachLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BeachesLoadedState) {
          return MainPage(beaches: state.beaches);
        } else if (state is BeachErrorState) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return AppStateKeeper().getOrDefault(const WelcomePage());
      },
    );
  }
}
