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

  @override
  String get loginTitle => 'Log in';

  @override
  String get loginSubtitle => 'Enter your details to access your account';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'Enter your email';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get loginButton => 'Log in';

  @override
  String get noAccount => 'New here?';

  @override
  String get signUpNow => 'Sign up';

  @override
  String get signupTitle => 'Create account';

  @override
  String get signupSubtitle => 'Fill in your details to create your account';

  @override
  String get fullName => 'Full name';

  @override
  String get fullNameHint => 'Enter your full name';

  @override
  String get phone => 'Phone number';

  @override
  String get phoneHint => '010xxxxxxxx';

  @override
  String get governorate => 'Governorate';

  @override
  String get selectGovernorate => 'Select governorate';

  @override
  String get address => 'Address';

  @override
  String get addressHint => 'Enter your address';

  @override
  String get createAccount => 'Create account';

  @override
  String get haveAccount => 'Already have an account?';

  @override
  String get loginNow => 'Log in';

  @override
  String get errEmailInvalid => 'Enter a valid email';

  @override
  String get errPasswordShort => 'Password must be at least 6 characters';

  @override
  String get errRequired => 'This field is required';

  @override
  String get errPhoneInvalid => 'Enter a valid Egyptian mobile number';

  @override
  String get errNameShort => 'Name must be at least 3 characters';

  @override
  String get errInvalidCredentials => 'Incorrect email or password';

  @override
  String get errEmailTaken => 'This email is already registered';

  @override
  String get errInvalidCode => 'The code is invalid or expired';

  @override
  String get errNetwork => 'No internet connection';

  @override
  String get errPasswordsMismatch => 'Passwords do not match';

  @override
  String get forgotTitle => 'Forgot password?';

  @override
  String get forgotSubtitle =>
      'Enter your email and we\'\'ll send you a reset code';

  @override
  String get sendCode => 'Send code';

  @override
  String get resetTitle => 'Reset password';

  @override
  String resetSubtitle(String email) {
    return 'Enter the code sent to $email and your new password';
  }

  @override
  String get code => 'Code';

  @override
  String get codeHint => 'Enter the 6-digit code';

  @override
  String get newPassword => 'New password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get savePassword => 'Save password';

  @override
  String get backToLogin => 'Back to login';

  @override
  String get splashLanguage => 'العربية';
}
