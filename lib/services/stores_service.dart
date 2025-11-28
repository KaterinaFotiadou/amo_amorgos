import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/stores.dart';

class StoresService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Stores>> fetchStores() async {
    try {
      final snapshot = await _firestore.collection('stores').get();
      return snapshot.docs
          .map((doc) => Stores.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to load stores : $e');
    }
  }
}