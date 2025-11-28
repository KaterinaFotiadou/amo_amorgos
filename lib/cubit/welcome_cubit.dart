import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/slides.dart';
import '../services/welcome_service.dart';

// Definition der möglichen States für WelcomeCubit
abstract class WelcomeState {}

class WelcomeLoading extends WelcomeState {} // Ladezustand

class WelcomeLoaded extends WelcomeState { // Zustand bei Erfolg
  final List<WelcomeSlide> slides; // Geladene Slides
  WelcomeLoaded(this.slides);
}

class WelcomeError extends WelcomeState { // Fehlerzustand
  final String message;
  WelcomeError(this.message);
}

// Cubit zum Laden der Welcome-Slides
class WelcomeCubit extends Cubit<WelcomeState> {
  final WelcomeService service; // Service, der Slides holt

  // Start mit Loading-Zustand, danach werden Slides geladen
  WelcomeCubit(this.service) : super(WelcomeLoading()) {
    loadSlides();
  }

  // Async-Funktion zum Slides laden
  Future<void> loadSlides() async {
    try {
      final slides = await service.fetchSlides(); // Service anfragen
      emit(WelcomeLoaded(slides)); // Erfolg: Slides geladen
    } catch (e) {
      emit(WelcomeError(e.toString())); // Fehler zustand
    }
  }
}


