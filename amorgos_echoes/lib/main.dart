import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:amorgos_echoes/l10n/app_localizations.dart';
import 'cubit/locale_cubit.dart';
import 'firebase_options.dart';
import 'cubit/app_cubit_logics.dart';
import 'cubit/app_cubits.dart';
import 'services/api_service.dart';
import 'services/welcome_service.dart';
import 'cubit/welcome_cubit.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? ctx) {
    return super.createHttpClient(ctx);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  final localeCubit = LocaleCubit();
  await localeCubit.loadSavedLocale();

  await Future.delayed(const Duration(seconds: 1));

  runApp(
    BlocProvider<LocaleCubit>.value(
      value: localeCubit,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        return MaterialApp(
          title: 'Amorgos Echoes',
          debugShowCheckedModeBanner: false,
          locale: locale,
          supportedLocales: const [
            Locale('en'),
            Locale('el'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            textTheme: GoogleFonts.notoSansTextTheme(),
            scaffoldBackgroundColor: Colors.white,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          home: MultiBlocProvider(
            providers: [
              BlocProvider<AppCubits>(
                create: (_) => AppCubits(ApiService()),
              ),
              BlocProvider<WelcomeCubit>(
                create: (_) => WelcomeCubit(WelcomeService()),
              ),
            ],
            child: AppCubitLogics(),
          ),
        );
      },
    );
  }
}
