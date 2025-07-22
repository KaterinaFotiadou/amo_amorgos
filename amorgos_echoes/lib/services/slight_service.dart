import 'package:cloud_firestore/cloud_firestore.dart'; // Importiert Firestore für den Zugriff auf die Cloud-Datenbank
import '../models/sight.dart'; // Importiert das Datenmodell 'Sight'

Future<List<Sight>> fetchSights() async {
  // Asynchrone Funktion, die eine Liste von Sight-Objekten aus der Datenbank zurückgibt

  final snapshot = await FirebaseFirestore.instance
      .collection('sights') // Greift auf die Collection 'sights' in Firestore zu
      .get(); // Führt die Abfrage aus und holt alle Dokumente aus dieser Collection

  return snapshot.docs
      .map((doc) => Sight.fromJson(doc.data())) // Wandelt jedes Dokument in ein Sight-Objekt um
      .toList(); // Gibt alle Objekte als Liste zurück
}
