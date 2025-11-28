import 'package:flutter/material.dart';
import 'package:amorgos_echoes/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../cubit/locale_cubit.dart';
import 'package:flutter/services.dart'; // για Clipboard



class MyPage extends StatelessWidget {
  const MyPage({super.key});

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Image(
                      image: AssetImage('img/logo.png'),
                      width: 120,
                      height: 120,
                    ),
                    SizedBox(width: 12),
                    LanguageDropdown(),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                local.thankYou,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                local.businessPrompt,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(const ClipboardData(text: 'amo.discoveryapp@gmail.com'));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(local.emailCopied)),
                  );
                },
                child: Text(
                  'amo.discoveryapp@gmail.com',
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),

              const SizedBox(height: 24),
              Text(
                local.touristPrompt,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => _launchUrl('https://play.google.com/store/apps/details?id=com.example.amorgos'),
                    icon: const Icon(Icons.android, size: 28, color: Colors.green),
                    tooltip: local.rateOnPlayStore,
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: () => _launchUrl('https://apps.apple.com/app/id000000000'),
                    icon: const Icon(Icons.apple, size: 28, color: Colors.black),
                    tooltip: local.rateOnAppStore,
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: () => _launchUrl('https://instagram.com/amo_amorgos'),
                    icon: const Icon(Icons.camera_alt, size: 28, color: Colors.purple),
                    tooltip: 'Instagram',
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Text(
                local.holidayWish,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
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
