import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_el.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('el'),
    Locale('en')
  ];

  /// No description provided for @errorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading'**
  String get errorLoading;

  /// No description provided for @discoverAmorgos.
  ///
  /// In en, this message translates to:
  /// **'Discover Amorgos'**
  String get discoverAmorgos;

  /// No description provided for @natureOutdoors.
  ///
  /// In en, this message translates to:
  /// **'Nature & Outdoors'**
  String get natureOutdoors;

  /// No description provided for @sightsCulture.
  ///
  /// In en, this message translates to:
  /// **'Sights & Culture'**
  String get sightsCulture;

  /// No description provided for @foodDrink.
  ///
  /// In en, this message translates to:
  /// **'Food & Drink'**
  String get foodDrink;

  /// No description provided for @shopsServices.
  ///
  /// In en, this message translates to:
  /// **'Shops & Services'**
  String get shopsServices;

  /// No description provided for @placesToStay.
  ///
  /// In en, this message translates to:
  /// **'Places to Stay'**
  String get placesToStay;

  /// No description provided for @exploreMore.
  ///
  /// In en, this message translates to:
  /// **'Explore more'**
  String get exploreMore;

  /// No description provided for @tipsOfTheWeek.
  ///
  /// In en, this message translates to:
  /// **'Tips of the Week'**
  String get tipsOfTheWeek;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @discover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discover;

  /// No description provided for @mustDo.
  ///
  /// In en, this message translates to:
  /// **'Must Do'**
  String get mustDo;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'About us'**
  String get myProfile;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get showMore;

  /// No description provided for @locationNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Location not available'**
  String get locationNotAvailable;

  /// No description provided for @offers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get offers;

  /// No description provided for @thankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank you for downloading our app!'**
  String get thankYou;

  /// No description provided for @businessPrompt.
  ///
  /// In en, this message translates to:
  /// **'Own a business in Amorgos?\nIf you\'d like to be listed, contact us at:'**
  String get businessPrompt;

  /// No description provided for @touristPrompt.
  ///
  /// In en, this message translates to:
  /// **'Are you a visitor and want to help us improve?\nSend us an email or leave a review:'**
  String get touristPrompt;

  /// No description provided for @businessEmail.
  ///
  /// In en, this message translates to:
  /// **'amo.discoveryapp@gmail.com'**
  String get businessEmail;

  /// No description provided for @holidayWish.
  ///
  /// In en, this message translates to:
  /// **'Enjoy your holiday in Amorgos!'**
  String get holidayWish;

  /// No description provided for @rateOnPlayStore.
  ///
  /// In en, this message translates to:
  /// **'Rate on Play Store'**
  String get rateOnPlayStore;

  /// No description provided for @rateOnAppStore.
  ///
  /// In en, this message translates to:
  /// **'Rate on App Store'**
  String get rateOnAppStore;

  /// No description provided for @noFavoritesYet.
  ///
  /// In en, this message translates to:
  /// **'No Favorites Yet'**
  String get noFavoritesYet;

  /// No description provided for @visitWebsite.
  ///
  /// In en, this message translates to:
  /// **'Visit Website'**
  String get visitWebsite;

  /// No description provided for @showOnMap.
  ///
  /// In en, this message translates to:
  /// **'Show on Map'**
  String get showOnMap;

  /// No description provided for @errorOpeningWebsite.
  ///
  /// In en, this message translates to:
  /// **'Could not open the website'**
  String get errorOpeningWebsite;

  /// No description provided for @offer.
  ///
  /// In en, this message translates to:
  /// **'Offer'**
  String get offer;

  /// No description provided for @emailSubject.
  ///
  /// In en, this message translates to:
  /// **'Contact from the app'**
  String get emailSubject;

  /// No description provided for @emailBody.
  ///
  /// In en, this message translates to:
  /// **'Hello, I would like to get in touch.'**
  String get emailBody;

  /// No description provided for @noEmailAppFound.
  ///
  /// In en, this message translates to:
  /// **'No email app found on your device.'**
  String get noEmailAppFound;

  /// No description provided for @emailCopied.
  ///
  /// In en, this message translates to:
  /// **'Email copied to clipboard'**
  String get emailCopied;

  /// No description provided for @internetNotice.
  ///
  /// In en, this message translates to:
  /// **'Connect to the internet to load all app data.'**
  String get internetNotice;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['el', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'el': return AppLocalizationsEl();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
