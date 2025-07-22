import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/beach.dart';
import '../../models/explore.dart';
import '../../models/explore_detail_items.dart';
import '../../models/sight.dart';
import '../../models/food.dart';
import '../../models/places_to_stay.dart';
import '../../models/stores.dart';
import '../../services/explore_service.dart';
import '../../services/food_service.dart';
import '../../services/places_to_stay_service.dart';
import '../../services/stores_service.dart';
import '../../services/slight_service.dart';
import '../detail_page.dart';
import '../explore_detail_page.dart';
import 'package:amorgos_echoes/l10n/app_localizations.dart';



class HomePage extends StatefulWidget {
  final List<Beach> beaches;

  const HomePage({super.key, required this.beaches});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late Future<List<ExploreItem>> exploreFuture;
  late TabController _tabController;
  late Future<List<Sight>> sightFuture;
  late Future<List<Stores>> storesFuture;
  late Future<List<Food>> foodFuture;
  late Future<List<PlacesToStay>> placesToStayFuture;

  @override
  void initState() {
    super.initState();
    exploreFuture = fetchExploreItems();
    sightFuture = fetchSights();
    foodFuture = FoodService().fetchFoodPlaces();
    storesFuture = StoresService().fetchStores();
    _tabController = TabController(length: 5, vsync: this);
    placesToStayFuture = PlacesToStayService().fetchPlacesToStay();
  }

  Future<List<ExploreDetailItem>> fetchOffers(String locale) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('food')
        .where('hasOffer', isEqualTo: true)
        .get();

    return snapshot.docs.map((doc) => ExploreDetailItem.fromJson(doc.data())).toList();
  }


  Widget buildSeeAllButton(Map<String, String> categoryMap) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ExploreDetailPage(category: categoryMap),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Color(0xE6FFFFFF),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          AppLocalizations.of(context)!.seeAll,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: "https://firebasestorage.googleapis.com/v0/b/amorgosechoes.firebasestorage.app/o/yorgos-triantafyllou-kSZHnpXF7Eg-unsplash.jpg?alt=media&token=6c7350fc-0812-4526-b3c7-903fb5a02ec6",
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: Colors.grey.shade200),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  Container(
                    height: 200,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.bottomLeft,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0x4D000000), Colors.transparent],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.discoverAmorgos,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  labelPadding: const EdgeInsets.only(left: 20, right: 20),
                  controller: _tabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: CircleTabIndicator(color: Colors.black54, radius: 4),
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(text: AppLocalizations.of(context)!.natureOutdoors),
                    Tab(text: AppLocalizations.of(context)!.sightsCulture),
                    Tab(text: AppLocalizations.of(context)!.foodDrink),
                    Tab(text: AppLocalizations.of(context)!.shopsServices),
                    Tab(text: AppLocalizations.of(context)!.placesToStay),
                  ],
                ),
              ),
              Container(
                height: 300,
                padding: const EdgeInsets.only(left: 20),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Beaches
                    ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.beaches.length,
                      itemBuilder: (context, index) {
                        final beach = widget.beaches[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailPage(
                                  name: beach.name[locale] ?? beach.name['en'] ?? '',
                                  imageUrl: beach.imageUrl,
                                  description: beach.description[locale] ?? beach.description['en'] ?? '',
                                  latitude: beach.latitude,
                                  longitude: beach.longitude,
                                  title: null, // ✔️ explicitly passed
                                  nameMap: beach.name,

                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 220,
                            margin: const EdgeInsets.only(right: 15, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(beach.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 10,
                                  left: 10,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      beach.name[locale] ?? beach.name['en'] ?? '',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                if (index == widget.beaches.length - 1)
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: buildSeeAllButton({
                                      'en': 'Nature & Outdoors',
                                      'el': 'Φύση & Ύπαιθρος',
                                    }),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    // Sights
                    FutureBuilder<List<Sight>>(
                      future: sightFuture,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                        final sights = snapshot.data!;
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: sights.length,
                          itemBuilder: (context, index) {
                            final sight = sights[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetailPage(
                                      name: sight.name[locale] ?? sight.name['en'] ?? '',
                                      imageUrl: sight.imageUrl,
                                      description: sight.description[locale] ?? sight.description['en'] ?? '',
                                      latitude: sight.latitude,
                                      longitude: sight.longitude,
                                      nameMap: sight.name,
                                      title: null, // ✔️ explicitly passed

                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 220,
                                margin: const EdgeInsets.only(right: 15, top: 10, bottom: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(sight.imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: 10,
                                      left: 10,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          sight.name[locale] ?? sight.name['en'] ?? '',
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    if (index == sights.length - 1)
                                      Positioned(
                                        top: 10,
                                        right: 10,
                                        child: buildSeeAllButton({
                                          'en': 'Sights & Culture',
                                          'el': 'Αξιοθέατα & Κουλτούρα',
                                        }),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    // Food
                    FutureBuilder<List<Food>>(
                      future: foodFuture,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                        final foodList = snapshot.data!;
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: foodList.length,
                          itemBuilder: (context, index) {
                            final food = foodList[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetailPage(
                                      name: food.name[locale] ?? food.name['en'] ?? '',
                                      imageUrl: food.imageUrl,
                                      description: food.description[locale] ?? food.description['en'] ?? '',
                                      latitude: food.latitude,
                                      longitude: food.longitude,
                                      nameMap: food.name,
                                      localizedImageUrl: food.localizedImageUrl,
                                      title: null, // ✔️ explicitly passed

                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 220,
                                margin: const EdgeInsets.only(right: 15, top: 10, bottom: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(food.imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: 10,
                                      left: 10,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          food.name[locale] ?? food.name['en'] ?? '',
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    if (index == foodList.length - 1)
                                      Positioned(
                                        top: 10,
                                        right: 10,
                                        child: buildSeeAllButton({
                                          'en': 'Food & Drink',
                                          'el': 'Φαγητό & ποτό',
                                        }),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    // Stores
                    FutureBuilder<List<Stores>>(
                      future: storesFuture,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                        final storesList = snapshot.data!;
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: storesList.length,
                          itemBuilder: (context, index) {
                            final store = storesList[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetailPage(
                                      name: store.name[locale] ?? store.name['en'] ?? '',
                                      imageUrl: store.imageUrl,
                                      description: store.description[locale] ?? store.description['en'] ?? '',
                                      latitude: store.latitude,
                                      longitude: store.longitude,
                                      nameMap: store.name,
                                      title: null, // ✔️ explicitly passed

                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 220,
                                margin: const EdgeInsets.only(right: 15, top: 10, bottom: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(store.imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: 10,
                                      left: 10,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          store.name[locale] ?? store.name['en'] ?? '',
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    if (index == storesList.length - 1)
                                      Positioned(
                                        top: 10,
                                        right: 10,
                                        child: buildSeeAllButton({
                                          'en': 'Shops & Services',
                                          'el': 'Μαγαζιά & Υπηρεσίες',
                                        }),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    // Places to stay
                    FutureBuilder<List<PlacesToStay>>(
                      future: placesToStayFuture,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                        final placesList = snapshot.data!;
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: placesList.length,
                          itemBuilder: (context, index) {
                            final place = placesList[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetailPage(
                                      name: place.name[locale] ?? place.name['en'] ?? '',
                                      imageUrl: place.imageUrl,
                                      description: place.description[locale] ?? place.description['en'] ?? '',
                                      latitude: place.latitude,
                                      longitude: place.longitude,
                                      nameMap: place.name,
                                      title: null, // ✔️ explicitly passed
                                      affiliateLink: place.affiliateLink,

                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 220,
                                margin: const EdgeInsets.only(right: 15, top: 10, bottom: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(place.imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: 10,
                                      left: 10,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          place.name[locale] ?? place.name['en'] ?? '',
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    if (index == placesList.length - 1)
                                      Positioned(
                                        top: 10,
                                        right: 10,
                                          child: buildSeeAllButton({
                                            'en': 'Places to Stay',
                                            'el': 'Διαμονή',
                                          }),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  AppLocalizations.of(context)!.exploreMore,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<ExploreItem>>(
                future: exploreFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  final items = snapshot.data!;
                  return SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: items.length,
                      itemBuilder: (_, index) {
                        final item = items[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ExploreDetailPage(category: item.title),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: index == 0 ? 20 : 0, right: 20),
                            child: Column(
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(item.imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x330000FF),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: 80,
                                  child: Text(
                                    item.title[locale] ?? item.title['en'] ?? '',
                                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),

// 🔽 OFFERS SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  AppLocalizations.of(context)!.offers,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<ExploreDetailItem>>(
                future: fetchOffers(locale),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "No offers available right now.",
                        style: TextStyle(color: Colors.black54),
                      ),
                    );
                  }

                  final offerItems = snapshot.data!;

                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: offerItems.length,
                      itemBuilder: (context, index) {
                        final offer = offerItems[index];
                        final title = offer.name[locale] ?? offer.name['en'] ?? '';
                        final desc = offer.offerDescription?[locale] ??
                            offer.offerDescription?['en'] ??
                            offer.description[locale] ??
                            offer.description['en'] ??
                            '';

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailPage(
                                  name: title,
                                  imageUrl: offer.imageUrl,
                                  description: desc,
                                  latitude: offer.latitude!,
                                  longitude: offer.longitude!,
                                  affiliateLink: offer.affiliateLink,
                                  title: offer.title,
                                  nameMap: offer.name,
                                  localizedImageUrl: offer.localizedImageUrl,

                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 160,
                            margin: const EdgeInsets.only(left: 20, right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(offer.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 10,
                                  left: 10,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      title,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                if (index == offerItems.length - 1)
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ExploreDetailPage(
                                              category: {'en': 'Offers', 'el': 'Προσφορές'},
                                              isOfferMode: true,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Color(0xE6FFFFFF),
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context)!.seeAll,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),


            ],
          ),
        ),
      ),
    );
  }
}

class CircleTabIndicator extends Decoration {
  final Color color;
  final double radius;

  const CircleTabIndicator({required this.color, required this.radius});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CirclePainter(color: color, radius: radius);
  }
}

class _CirclePainter extends BoxPainter {
  final Color color;
  final double radius;

  _CirclePainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Paint paint = Paint()..color = color..isAntiAlias = true;
    final Offset circleOffset = offset + Offset(configuration.size!.width / 2, configuration.size!.height - radius - 4);
    canvas.drawCircle(circleOffset, radius, paint);
  }
}

// Widget für einzelne Tipp-Karten
class TipCard extends StatelessWidget {
  final String day; // Wochentag
  final String title; // Titel des Tipps
  final IconData icon; // Icon für den Tipp
  final String description; // Beschreibung

  const TipCard({
    super.key,
    required this.day,
    required this.title,
    required this.icon,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 56) / 2, // Breite der Karte (2 pro Reihe)
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Color(0x1A9E9E9E),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.shade50,
              radius: 20,
              child: Icon(icon, size: 20, color: Colors.blueAccent),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(day, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
                  Text(title, style: const TextStyle(fontSize: 13, color: Colors.black87)),
                  Text(description, style: const TextStyle(fontSize: 11, color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}