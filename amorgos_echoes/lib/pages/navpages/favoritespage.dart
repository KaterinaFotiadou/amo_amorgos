import 'package:flutter/material.dart';
import 'package:amorgos_echoes/l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/explore_detail_items.dart';
import '../detail_page.dart';
import '../favorites_manager.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Future<List<ExploreDetailItem>> favoriteItems;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    setState(() {
      favoriteItems = _getFavorites();
    });
  }

  String getItemId(ExploreDetailItem item) {
    final id = item.title['en']?.trim() ?? item.name['en']?.trim() ?? '';
    return id;
  }

  Future<List<ExploreDetailItem>> _getFavorites() async {
    final favoriteIds = await FavoritesManager.getFavorites();
    final allItems = await _fetchAllItemsFromAllCollections();

    return allItems.where((item) {
      final id = getItemId(item);
      return id.isNotEmpty && favoriteIds.contains(id);
    }).toList();
  }

  Future<List<ExploreDetailItem>> _fetchAllItemsFromAllCollections() async {
    final List<ExploreDetailItem> allItems = [];
    final collections = [
      'beaches',
      'food',
      'sights',
      'stores',
      'places_to_stay',
      'explore_details'
    ];

    for (final collection in collections) {
      final snapshot = await FirebaseFirestore.instance.collection(collection).get();
      allItems.addAll(snapshot.docs.map((doc) => ExploreDetailItem.fromJson(doc.data())));
    }

    return allItems;
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<ExploreDetailItem>>(
        future: favoriteItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data ?? [];

          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: Text(
                    AppLocalizations.of(context)!.favorites,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: items.isEmpty
                      ? Center(
                    child: Text(
                      AppLocalizations.of(context)!.noFavoritesYet,
                      style: const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  )
                      : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final id = getItemId(item);
                      final title = item.title[locale]?.trim().isNotEmpty ?? false
                          ? item.title[locale]!.trim()
                          : item.name[locale]?.trim().isNotEmpty ?? false
                          ? item.name[locale]!.trim()
                          : item.title['en']?.trim() ?? item.name['en']?.trim() ?? '';
                      final description = item.description[locale]?.trim() ?? item.description['en']?.trim() ?? '';

                      return Stack(
                        children: [
                          Row(
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4), // space under the heart
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
                                    const SizedBox(height: 6),
                                    Text(
                                      description.isNotEmpty
                                          ? (description.length > 100 ? '${description.substring(0, 100)}...' : description)
                                          : '',
                                      style: const TextStyle(fontSize: 13, color: Colors.black87),
                                    ),
                                    const SizedBox(height: 10),
                                    GestureDetector(
                                      onTap: () async {
                                        await Navigator.of(context).push(MaterialPageRoute(
                                          builder: (_) => DetailPage(
                                            name: title,
                                            imageUrl: item.imageUrl,
                                            description: description,
                                            latitude: item.latitude ?? 0.0,
                                            longitude: item.longitude ?? 0.0,
                                            affiliateLink: item.affiliateLink,
                                          ),
                                        ));
                                        _loadFavorites();
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
                            ],
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 20,
                              ),
                              onPressed: () async {
                                await FavoritesManager.toggleFavorite(id);
                                _loadFavorites();
                              },
                            ),
                          ),
                        ],
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
