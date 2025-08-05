// File: lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';

import 'cubit/connectivity_cubit.dart';
import 'cubit/app_cubit_logics.dart';
import 'cubit/app_cubits.dart';
import 'cubit/welcome_cubit.dart';
import 'cubit/locale_cubit.dart';
import 'l10n/app_localizations.dart';
import 'widgets/offline_overlay.dart';
import 'services/api_service.dart';
import 'services/welcome_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  final localeCubit = LocaleCubit();
  await localeCubit.loadSavedLocale();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ConnectivityCubit>(create: (_) => ConnectivityCubit()),
        BlocProvider<LocaleCubit>.value(value: localeCubit),
        BlocProvider<AppCubits>(create: (_) => AppCubits(ApiService())),
        BlocProvider<WelcomeCubit>(create: (_) => WelcomeCubit(WelcomeService())),
      ],
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
          supportedLocales: const [Locale('en'), Locale('el')],
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
          builder: (context, child) {
            final isOnline = context.watch<ConnectivityCubit>().state;
            return Stack(
              children: [
                child!,
                if (!isOnline)
                  OfflineOverlay(
                    onRetry: () => context.read<ConnectivityCubit>().initConnectivity(),
                  ),
              ],
            );
          },
          home: const AppCubitLogics(),
        );
      },
    );
  }
}
