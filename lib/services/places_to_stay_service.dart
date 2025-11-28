import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/places_to_stay.dart';

class PlacesToStayService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<PlacesToStay>> fetchPlacesToStay() async {
    try {
      final snapshot = await _firestore.collection('places_to_stay').get();
      return snapshot.docs
          .map((doc) => PlacesToStay.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to load PlacesToStay : $e');
    }
  }
}