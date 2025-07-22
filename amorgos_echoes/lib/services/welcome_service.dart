import 'package:cloud_firestore/cloud_firestore.dart'; // Importiert Firestore für Datenbankzugriff
import '../models/slides.dart'; // oder 'welcome_slide.dart' – Importiert das Modell WelcomeSlide

class WelcomeService { // Service-Klasse zur Kommunikation mit Firestore für WelcomeSlides
  final _firestore = FirebaseFirestore.instance; // Instanz von Firestore

  Future<List<WelcomeSlide>> fetchSlides() async {
    // Asynchrone Methode zum Abrufen aller WelcomeSlide-Dokumente

    final snapshot = await _firestore.collection('welcome_slides').get();
    // Holt alle Dokumente aus der Collection 'welcome_slides'

    return snapshot.docs.map((doc) {
      return WelcomeSlide.fromJson(doc.data());
      // Wandelt jedes Dokument in ein WelcomeSlide-Objekt um
    }).toList(); // Gibt die Liste von WelcomeSlide-Objekten zurück
  }
}
