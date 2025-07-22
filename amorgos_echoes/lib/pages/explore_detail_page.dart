import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/explore_detail_items.dart';
import '../pages/detail_page.dart';
import 'favorites_manager.dart';
import 'package:amorgos_echoes/l10n/app_localizations.dart';


class ExploreDetailPage extends StatefulWidget {
  final Map<String, String> category;
  final bool isOfferMode;

  const ExploreDetailPage({
    super.key,
    required this.category,
    this.isOfferMode = false,
  });

  @override
  State<ExploreDetailPage> createState() => _ExploreDetailPageState();
}

class _ExploreDetailPageState extends State<ExploreDetailPage> with SingleTickerProviderStateMixin {
  late Future<List<ExploreDetailItem>> detailFuture;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;
  late String locale;
  late String localizedCategory;
  late String englishCategory;
  late String collection;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    locale = Localizations.localeOf(context).languageCode;

    localizedCategory = widget.isOfferMode
        ? AppLocalizations.of(context)!.offers
        : widget.category[locale] ?? widget.category['en'] ?? '';

    englishCategory = widget.category['en'] ?? '';
    collection = getCollectionName(englishCategory);
    detailFuture = fetchItemsByCategory();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String getCollectionName(String englishCategoryName) {
    switch (englishCategoryName) {
      case "Nature & Outdoors":
        return "beaches";
      case "Sights & Culture":
        return "sights";
      case "Food & Drink":
        return "food";
      case "Shops & Services":
        return "stores";
      case "Places to Stay":
        return "places_to_stay";
      default:
        return "explore_details";
    }
  }

  Future<List<ExploreDetailItem>> fetchItemsByCategory() async {
    if (widget.isOfferMode) {
      final foodSnapshot = await FirebaseFirestore.instance
          .collection('food')
          .where('hasOffer', isEqualTo: true)
          .get();

      final storesSnapshot = await FirebaseFirestore.instance
          .collection('stores')
          .where('hasOffer', isEqualTo: true)
          .get();

      final placesSnapshot = await FirebaseFirestore.instance
          .collection('places_to_stay')
          .where('hasOffer', isEqualTo: true)
          .get();

      final foodItems = foodSnapshot.docs.map((doc) => ExploreDetailItem.fromJson(doc.data())).toList();
      final storeItems = storesSnapshot.docs.map((doc) => ExploreDetailItem.fromJson(doc.data())).toList();
      final placeItems = placesSnapshot.docs.map((doc) => ExploreDetailItem.fromJson(doc.data())).toList();

      return [...foodItems, ...storeItems, ...placeItems];
    }

    final snapshot = await FirebaseFirestore.instance.collection(collection).get();
    final items = snapshot.docs.map((doc) => ExploreDetailItem.fromJson(doc.data())).toList();

    if (collection == 'explore_details') {
      return items.where((item) =>
      item.category[locale] == localizedCategory || item.category['en'] == englishCategory).toList();
    } else {
      return items;
    }
  }

  String resolveLocalizedField(Map<String, dynamic>? mapField, String locale) {
    if (mapField == null) return '';
    if (mapField.containsKey(locale)) {
      return mapField[locale];
    } else if (mapField.containsKey('en')) {
      return mapField['en'];
    } else {
      return '';
    }
  }

  String getItemId(ExploreDetailItem item) {
    return item.title['en']?.trim() ?? item.name['en']?.trim() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<ExploreDetailItem>>(
        future: detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final items = snapshot.data ?? [];

          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Colors.black12,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.black),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AnimatedBuilder(
                          animation: _controller,
                          builder: (_, __) => SlideTransition(
                            position: _slideAnimation,
                            child: FadeTransition(
                              opacity: _opacityAnimation,
                              child: Text(
                                widget.category[locale] ?? widget.category['en'] ?? '',
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final title = resolveLocalizedField(item.name, locale).trim().isNotEmpty
                          ? resolveLocalizedField(item.name, locale).trim()
                          : resolveLocalizedField(item.title, locale).trim();

                      final desc = widget.isOfferMode && item.offerDescription != null
                          ? resolveLocalizedField(item.offerDescription!, locale).trim()
                          : resolveLocalizedField(item.description, locale).trim();

                      return FutureBuilder<bool>(
                        future: FavoritesManager.isFavorite(getItemId(item)),
                        builder: (context, snapshot) {
                          final isFavorite = snapshot.data ?? false;

                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    item.imageUrl,
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 32.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              desc.length > 150 ? '${desc.substring(0, 150)}...' : desc,
                                              style: const TextStyle(fontSize: 13, color: Colors.black87),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 10),
                                            GestureDetector(
                                              onTap: () async {
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) => DetailPage(
                                                        name: title,
                                                        imageUrl: item.imageUrl,
                                                        localizedImageUrl: item.localizedImageUrl,
                                                        description: desc,
                                                        latitude: item.latitude,
                                                        longitude: item.longitude ,
                                                        affiliateLink: item.affiliateLink,
                                                        title: item.title,
                                                        nameMap: item.name,
                                                      ),
                                                    ),
                                                  );
                                                  setState(() {}); // 🔁 refresh state
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  AppLocalizations.of(context)!.showMore,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: IconButton(
                                          icon: Icon(
                                            isFavorite ? Icons.favorite : Icons.favorite_border,
                                            color: isFavorite ? Colors.red : Colors.grey,
                                            size: 20,
                                          ),
                                          onPressed: () async {
                                            await FavoritesManager.toggleFavorite(getItemId(item));
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
