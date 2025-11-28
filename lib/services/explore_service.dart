import 'package:cloud_firestore/cloud_firestore.dart'; // Importiert Firestore für den Zugriff auf die Cloud-Datenbank
import '../models/explore.dart'; // Importiert das Datenmodell 'ExploreItem'

Future<List<ExploreItem>> fetchExploreItems() async {
  // Asynchrone Funktion, die eine Liste von ExploreItem-Objekten zurückgibt

  final snapshot = await FirebaseFirestore.instance
      .collection('explore_images') // Greift auf die Firestore-Collection 'explore_images' zu
      .get(); // Führt die Abfrage aus und holt alle Dokumente

  return snapshot.docs
      .map((doc) => ExploreItem.fromJson(doc.data())) // Wandelt die Rohdaten in ExploreItem-Objekte um
      .toList(); // Gibt die Objekte als Liste zurück
}
