import 'package:cloud_firestore/cloud_firestore.dart'; // Importiert Firestore zur Nutzung von Datenbankfunktionen
import '../models/beach.dart'; // Importiert das Modell 'Beach' für die Datenstruktur

class ApiService { // Definiert eine Service-Klasse zur Kommunikation mit Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Erstellt eine Instanz von Firestore

  Future<List<Beach>> fetchBeaches() async { // Asynchrone Methode zum Abrufen einer Liste von Stränden
    final snapshot = await _firestore.collection('beaches').get(); // Holt alle Dokumente aus der 'beaches'-Sammlung
    return snapshot.docs.map((doc) { // Wandelt jedes Dokument in ein Beach-Objekt um
      final data = doc.data(); // Extrahiert die Daten aus dem Dokument
      return Beach.fromJson(data); // Erstellt ein Beach-Objekt aus den JSON-Daten
    }).toList(); // Gibt eine Liste von Beach-Objekten zurück
  }
}
