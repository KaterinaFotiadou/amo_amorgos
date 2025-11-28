import 'package:cloud_firestore/cloud_firestore.dart'; // Importiert Firestore für Datenbankoperationen
import '../models/beach.dart'; // Importiert das Datenmodell 'Beach'

Future<List<Beach>> fetchBeaches() async { // Asynchrone Funktion, die eine Liste von Beach-Objekten zurückgibt
  final snapshot = await FirebaseFirestore.instance.collection('beaches').get(); // Holt alle Dokumente aus der Collection 'beaches'
  return snapshot.docs.map((doc) => Beach.fromJson(doc.data())).toList(); // Wandelt jedes Dokument in ein Beach-Objekt um und gibt eine Liste zurück
}
