import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/explore_detail_items.dart';
import '../detail_page.dart';
import '../favorites_manager.dart';
import 'package:amorgos_echoes/l10n/app_localizations.dart';



class MustDoPage extends StatefulWidget {
  const MustDoPage({super.key});

  @override
  State<MustDoPage> createState() => _MustDoPageState();
}

class _MustDoPageState extends State<MustDoPage> with SingleTickerProviderStateMixin {
  late Future<List<ExploreDetailItem>> mustDoFuture;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    mustDoFuture = fetchMustDoItems();

    _controller = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<List<ExploreDetailItem>> fetchMustDoItems() async {
    final List<ExploreDetailItem> mustDoItems = [];

    final collections = [
      'beaches',
      'food',
      'sights',
      'stores',
      'places_to_stay',
      'explore_details',
    ];

    for (final collection in collections) {
      final snapshot = await FirebaseFirestore.instance
          .collection(collection)
          .where('isMustDo', isEqualTo: true)
          .get();

      mustDoItems.addAll(snapshot.docs.map((doc) => ExploreDetailItem.fromJson(doc.data())));
    }

    return mustDoItems;
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
    final locale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<ExploreDetailItem>>(
        future: mustDoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: \${snapshot.error}"));
          }

          final items = snapshot.data ?? [];

          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (_, __) => SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _opacityAnimation,
                        child: Text(
                          AppLocalizations.of(context)!.mustDo,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ),
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

                      final desc = item.offerDescription != null
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
                                                      longitude: item.longitude,
                                                      affiliateLink: item.affiliateLink,
                                                      title: item.title,
                                                      nameMap: item.name,
                                                    ),
                                                  ),
                                                );
                                                setState(() {});
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
