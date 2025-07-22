import 'package:flutter/material.dart';
import '../../models/beach.dart';
import '../../services/beaches_service.dart';
import 'home_page.dart';
import 'mustdopage.dart';
import 'favoritespage.dart';
import 'my_page.dart';
import 'package:amorgos_echoes/l10n/app_localizations.dart';



class MainPage extends StatefulWidget {
  final List<Beach> beaches;

  const MainPage({super.key, required this.beaches});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  late Future<List<Beach>> beachesFuture;

  @override
  void initState() {
    super.initState();
    beachesFuture = fetchBeaches();
  }

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return FutureBuilder<List<Beach>>(
      future: beachesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                "${localizations.errorLoading}: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        } else {
          final beaches = snapshot.data ?? [];

          final List<Widget> pages = [
            HomePage(beaches: beaches),
            MustDoPage(),
            FavoritesPage(),
            MyPage(),
          ];

          return Scaffold(
            body: pages[currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: onTap,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: Colors.grey,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.travel_explore),
                  label: localizations.discover,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.task_alt),
                  label: localizations.mustDo,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.favorite_border),
                  label: localizations.favorites,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person_outline),
                  label: localizations.myProfile,
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
