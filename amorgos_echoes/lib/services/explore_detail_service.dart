import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/explore_detail_items.dart';

Future<List<ExploreDetailItem>> fetchExploreDetails(Map<String, String> category) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('explore_details')
      .get();

  // Παίρνουμε τη γλώσσα της συσκευής (πχ 'en' ή 'el')
  // Αν δεν έχεις context, μπορείς να το στείλεις ως παράμετρο ή να βρεις άλλο τρόπο
  final locale = 'en'; // Για παράδειγμα, θα πρέπει να το περάσεις ή να το πάρεις δυναμικά

  // Φιλτράρουμε στον client με βάση το locale ή την αγγλική μετάφραση
  return snapshot.docs
      .map((doc) => ExploreDetailItem.fromJson(doc.data()))
      .where((item) =>
  item.category[locale] == category[locale] || item.category['en'] == category['en'])
      .toList();
}

Future<List<ExploreDetailItem>> fetchAllExploreDetails() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('explore_details')
      .get();

  return snapshot.docs
      .map((doc) => ExploreDetailItem.fromJson(doc.data()))
      .toList();
}
