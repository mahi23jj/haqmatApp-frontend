import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_am.dart';
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
/// import 'gen/app_localizations.dart';
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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('am'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Haqmate Teff'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'From Farm to Home'**
  String get appTagline;

  /// No description provided for @homeTitleAm.
  ///
  /// In en, this message translates to:
  /// **'ሐቅማት ጤፍ'**
  String get homeTitleAm;

  /// No description provided for @homeTitleEn.
  ///
  /// In en, this message translates to:
  /// **'Haqmate Teff'**
  String get homeTitleEn;

  /// No description provided for @homeSubtitleAm.
  ///
  /// In en, this message translates to:
  /// **'ከእርሻ እስከ ቤትዎ'**
  String get homeSubtitleAm;

  /// No description provided for @homeSubtitleEn.
  ///
  /// In en, this message translates to:
  /// **'From Farm to Home'**
  String get homeSubtitleEn;

  /// No description provided for @ordersTitleAm.
  ///
  /// In en, this message translates to:
  /// **'የእኔ ትዕዛዞች'**
  String get ordersTitleAm;

  /// No description provided for @ordersTitleEn.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get ordersTitleEn;

  /// No description provided for @orderDetailTitleAm.
  ///
  /// In en, this message translates to:
  /// **'የትዕዛዝ ዝርዝር'**
  String get orderDetailTitleAm;

  /// No description provided for @orderDetailTitleEn.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetailTitleEn;

  /// No description provided for @checkoutTitleAm.
  ///
  /// In en, this message translates to:
  /// **'የግዢ ሂደት'**
  String get checkoutTitleAm;

  /// No description provided for @checkoutTitleEn.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkoutTitleEn;

  /// No description provided for @manualPaymentTitleAm.
  ///
  /// In en, this message translates to:
  /// **'ክፍያ ያረጋግጡ'**
  String get manualPaymentTitleAm;

  /// No description provided for @manualPaymentTitleEn.
  ///
  /// In en, this message translates to:
  /// **'Confirm Payment'**
  String get manualPaymentTitleEn;

  /// No description provided for @profileTitleAm.
  ///
  /// In en, this message translates to:
  /// **'መገለጫ'**
  String get profileTitleAm;

  /// No description provided for @profileTitleEn.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitleEn;

  /// No description provided for @reviewsTitleAm.
  ///
  /// In en, this message translates to:
  /// **'ግምገማዎች እና ደረጃዎች'**
  String get reviewsTitleAm;

  /// No description provided for @reviewsTitleEn.
  ///
  /// In en, this message translates to:
  /// **'Reviews and Ratings'**
  String get reviewsTitleEn;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['am', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'am':
      return AppLocalizationsAm();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
