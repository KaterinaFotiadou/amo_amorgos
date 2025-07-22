import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food.dart';

class FoodService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Food>> fetchFoodPlaces() async {
    try {
      final snapshot = await _firestore.collection('food').get();
      return snapshot.docs
          .map((doc) => Food.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to load food places: $e');
    }
  }
}