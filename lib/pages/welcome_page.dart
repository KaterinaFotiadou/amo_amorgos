import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:amorgos_echoes/widgets/app_large_text.dart';
import 'package:amorgos_echoes/widgets/app_text.dart';
import 'package:amorgos_echoes/cubit/welcome_cubit.dart';
import 'package:amorgos_echoes/cubit/locale_cubit.dart';
import '../l10n/app_localizations.dart';
import 'navpages/main_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final Map<String, String> buttonTexts = {
      'en': 'Begin your journey',
      'el': 'Ξεκίνα το ταξίδι σου',
    };

    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<WelcomeCubit, WelcomeState>(
        builder: (context, state) {
          if (state is WelcomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WelcomeLoaded) {
            final originalSlides = state.slides;

// π.χ. νέα σειρά: slide 2, slide 0, slide 1
            final slides = [
              originalSlides[1],
              originalSlides[2],
              originalSlides[0],
            ];
            return Stack(
              children: [
                PageView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: slides.length,
                  itemBuilder: (context, index) {
                    final slide = slides[index];

                    return Stack(
                      children: [
                        Positioned.fill(
                          child: CachedNetworkImage(
                            imageUrl: slide.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Container(color: Colors.black12),
                            errorWidget: (context, url, error) =>
                            const Center(child: Icon(Icons.error, color: Colors.red)),
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,colors: [
                                const Color(0x99000000), // 0x99 = 60% opacity
                                Colors.transparent,
                              ],

                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 60, left: 20, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppLargeText(
                                text: slide.title[locale] ?? slide.title['en'] ?? '',
                                size: 42,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 10),
                              AppText(
                                text: slide.subtitle[locale] ?? slide.subtitle['en'] ?? '',
                                size: 26,
                                color: Colors.white70,
                              ),
                              const SizedBox(height: 25),
                              SizedBox(
                                width: 300,
                                child: AppText(
                                  text: slide.text[locale] ?? slide.text['en'] ?? '',
                                  size: 15,
                                  color: Colors.white70
                                  ,
                                  fontWeight : FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 50),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (_) => const MainPage(beaches: []),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0x33000000),
                                              blurRadius: 8,
                                              offset: const Offset(0, 3),

                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            buttonTexts[locale] ?? buttonTexts['en']!,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const LanguageDropdown(),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 60,
                          right: 20,
                          child: Column(
                            children: List.generate(slides.length, (indexDots) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                width: 8,
                                height: index == indexDots ? 23 : 8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: index == indexDots
                                      ? Colors.white
                                      : const Color(0x4DFFFFFF),

                                ),
                              );
                            }),
                          ),
                        ),
                        Positioned(
                          bottom: 50,
                          left: 20,
                          right: 20,
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.internetNotice,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            );
          }

          if (state is WelcomeError) {
            return Center(child: Text("Error: ${state.message}"));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context).languageCode;
    final localeCubit = context.read<LocaleCubit>();

    final Map<String, String> flags = {
      'en': 'img/en.jpg',
      'el': 'img/el.jpg',
    };

    return PopupMenuButton<String>(
      onSelected: (value) {
        localeCubit.setLocale(Locale(value));
      },
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      icon: ClipOval(
        child: Image.asset(
          flags[currentLocale] ?? flags['en']!,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
        ),
      ),
      itemBuilder: (_) => flags.entries.map((entry) {
        return PopupMenuItem<String>(
          value: entry.key,
          child: Row(
            children: [
              Image.asset(entry.value, width: 24, height: 24),
              const SizedBox(width: 8),
              Text(entry.key == 'en' ? 'English' : 'Ελληνικά'),
            ],
          ),
        );
      }).toList(),
    );
  }
}
