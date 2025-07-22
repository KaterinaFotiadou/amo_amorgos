import 'package:amorgos_echoes/models/beach.dart';
import 'package:equatable/equatable.dart';

abstract class CubitStates extends Equatable{}

class InitialState extends CubitStates{
  @override
  // TODO: implement props
  List<Object> get props => [];

}

class WelcomeState extends CubitStates{
  @override
  // TODO: implement props
  List<Object> get props => [];

}

class BeachLoadingState extends CubitStates {
  @override
  List<Object> get props => [];
}

class BeachesLoadedState extends CubitStates {
  final List<Beach> beaches;
  BeachesLoadedState(this.beaches);
  @override
  List<Object> get props => [beaches];
}

class BeachErrorState extends CubitStates {
  final String message;
  BeachErrorState(this.message);
  @override
  List<Object> get props => [message];
}