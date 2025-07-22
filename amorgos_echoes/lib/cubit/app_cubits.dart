import 'package:bloc/bloc.dart';
import 'app_cubit_states.dart';
import '../services/api_service.dart';

class AppCubits extends Cubit<CubitStates> {
  final ApiService api; // API-Service für Datenzugriffe

  // Konstruktor: Startzustand ist InitialState
  AppCubits(this.api) : super(InitialState()) {
    loadWelcome(); // Beim Start wird Welcome-Status geladen
  }

  // Methode, um den Willkommenszustand auszulösen
  void loadWelcome() {
    emit(WelcomeState()); // Zustandswechsel zu WelcomeState
  }

  // Asynchrone Methode zum Laden der Strände
  Future<void> loadBeaches() async {
    emit(BeachLoadingState()); // Ladezustand wird angezeigt
    try {
      final beaches = await api.fetchBeaches(); // Daten von API holen
      print("GELADEN: ${beaches.length} Strände"); // Debug-Ausgabe
      emit(BeachesLoadedState(beaches)); // Daten sind geladen
    } catch (e) {
      print("FEHLER beim Laden: $e"); // Fehlerbehandlung
      emit(BeachErrorState(e.toString())); // Fehlerzustand emittieren
    }
  }
}
