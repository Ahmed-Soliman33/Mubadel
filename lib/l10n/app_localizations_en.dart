// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Mubadel';

  @override
  String get tagline => 'Your space to swap';

  @override
  String get slogan => 'Let what you don\'\'t need find a new owner';

  @override
  String get start => 'Start';

  @override
  String get navHome => 'Home';

  @override
  String get navFavorites => 'Favorites';

  @override
  String get navAdd => 'Add';

  @override
  String get navMessages => 'Messages';

  @override
  String get navProfile => 'Profile';

  @override
  String get retry => 'Try again';

  @override
  String get errorGeneric => 'Something went wrong, try again';

  @override
  String get emptyNoResults => 'No results';

  @override
  String get loading => 'Loading...';

  @override
  String get currencyEgp => 'EGP';

  @override
  String get configMissingTitle => 'Missing configuration';

  @override
  String get configMissingBody =>
      'Supabase keys are missing. Add env.json to the project root and run with --dart-define-from-file=env.json';

  @override
  String get conditionNew => 'New';

  @override
  String get conditionLikeNew => 'Like new';

  @override
  String get conditionUsed => 'Used';

  @override
  String get listingBoth => 'Sell or swap';

  @override
  String get listingSwap => 'Swap only';

  @override
  String get listingSale => 'Sale only';

  @override
  String get priceSwap => 'For swap';

  @override
  String get statusAvailable => 'Available';

  @override
  String get statusReserved => 'Reserved';

  @override
  String get statusSwapped => 'Swapped';

  @override
  String get statusSold => 'Sold';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get save => 'Save';

  @override
  String get viewAll => 'View all';

  @override
  String ratingsCount(int count) {
    return '($count reviews)';
  }
}
