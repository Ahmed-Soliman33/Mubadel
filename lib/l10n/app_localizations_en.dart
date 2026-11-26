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
  String ratingsCount(String num) {
    return '($num reviews)';
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

  @override
  String get searchHint => 'What are you looking for today?';

  @override
  String get bannerText =>
      'What you don\'\'t need could be a treasure to someone else';

  @override
  String get bannerButton => 'Start swapping';

  @override
  String get browseCategories => 'Browse categories';

  @override
  String get featured => 'Picks you may like';

  @override
  String get searchTitle => 'Search';

  @override
  String get filterCategory => 'Category';

  @override
  String get filterType => 'Type';

  @override
  String get filterCondition => 'Condition';

  @override
  String get filterAll => 'All';

  @override
  String get filterSale => 'Sale';

  @override
  String get filterSwap => 'Swap';

  @override
  String get productDetailsTitle => 'Product details';

  @override
  String get productDetailsSubtitle =>
      'Review the details before sending an offer';

  @override
  String get ownerSection => 'Product owner';

  @override
  String memberSince(String year) {
    return 'Member since $year';
  }

  @override
  String get makeOffer => 'Offer a swap';

  @override
  String get buy => 'Buy';

  @override
  String get messageSeller => 'Message seller';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get deleteConfirmTitle => 'Delete product';

  @override
  String get deleteConfirmBody =>
      'Are you sure you want to delete this product?';

  @override
  String get productUnavailable => 'This product is currently unavailable';

  @override
  String get offerSent => 'Your offer was sent';

  @override
  String get categoryLabel => 'Category';

  @override
  String get conditionLabel => 'Condition';

  @override
  String get addProductTitle => 'Add your product';

  @override
  String get addProductSubtitle => 'Give your item a new life';

  @override
  String get editProductTitle => 'Edit product';

  @override
  String get productImages => 'Product photos';

  @override
  String get addImages => 'Add photos';

  @override
  String get photoTip => 'Shoot the product in good lighting';

  @override
  String get productData => 'Product details';

  @override
  String get productName => 'Product name';

  @override
  String get productNameHint => 'e.g. Samsung A54 phone';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get descriptionHint => 'Describe the product and its condition';

  @override
  String get selectCategory => 'Select category';

  @override
  String get productCondition => 'Condition';

  @override
  String get howToList => 'How do you want to list it?';

  @override
  String get priceLabel => 'Asking price (EGP)';

  @override
  String get priceHint => 'e.g. 500';

  @override
  String get publish => 'Publish product';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get errImagesRequired => 'Add at least one photo';

  @override
  String get errCategoryRequired => 'Select a category';

  @override
  String get errPriceRequired => 'Enter the price';

  @override
  String get errConditionRequired => 'Select the condition';

  @override
  String get maxImages => 'Maximum 6 photos';

  @override
  String get coverLabel => 'Cover';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get productPublished => 'Product published';

  @override
  String get productSaved => 'Changes saved';

  @override
  String get productDeleted => 'Product deleted';

  @override
  String get listingSaleShort => 'For sale';

  @override
  String get listingSwapShort => 'For swap';

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String get favoritesSubtitle => 'Products you saved';

  @override
  String get noFavorites => 'Nothing in favorites yet';

  @override
  String get noFavoritesHint => 'Tap the heart to save products';

  @override
  String get noProducts => 'No products';

  @override
  String get buyRequestTitle => 'Buy request';

  @override
  String get cashOnDelivery => 'Cash on delivery';

  @override
  String get noteOptional => 'Note (optional)';

  @override
  String get noteHint => 'Write a note to the seller';

  @override
  String get sendBuyRequest => 'Send buy request';

  @override
  String get buyRequestSent => 'Buy request sent';

  @override
  String get makeOfferTitle => 'Offer a swap';

  @override
  String get makeOfferSubtitle => 'Pick one of your items in exchange';

  @override
  String get requestedProduct => 'Requested product';

  @override
  String byOwner(String name, String city) {
    return 'By $name · $city';
  }

  @override
  String byOwnerNoCity(String name) {
    return 'By $name';
  }

  @override
  String get chooseYourProduct => 'Choose the item you\'\'ll offer';

  @override
  String get noProductsToOffer => 'You have no available products';

  @override
  String get noProductsToOfferHint => 'Add a product first so you can offer it';

  @override
  String get addProduct => 'Add product';

  @override
  String get cashDiff => 'Cash difference (optional)';

  @override
  String get cashDiffHint => 'e.g. I\'\'ll add EGP 2,500';

  @override
  String get cashDiffNote =>
      'The final difference is agreed between both parties.';

  @override
  String get sendSwapOffer => 'Send swap offer';

  @override
  String get swapOfferSent => 'Swap offer sent';

  @override
  String get errSelectProduct => 'Choose a product to swap';

  @override
  String get messagesTitle => 'Messages';

  @override
  String get messagesSubtitle => 'Your chats and offers in one place';

  @override
  String get tabConversations => 'Chats';

  @override
  String get tabOffers => 'Offers';

  @override
  String get offersIncoming => 'Incoming';

  @override
  String get offersOutgoing => 'Outgoing';

  @override
  String get accept => 'Accept';

  @override
  String get reject => 'Reject';

  @override
  String get cancelOffer => 'Cancel offer';

  @override
  String get openChat => 'Open chat';

  @override
  String get offerBuyLabel => 'Buy';

  @override
  String offerCash(String amount) {
    return 'Cash difference: $amount';
  }

  @override
  String offerWith(String name) {
    return 'With $name';
  }

  @override
  String get offerStatusPending => 'Pending';

  @override
  String get offerStatusAccepted => 'Accepted';

  @override
  String get offerStatusRejected => 'Rejected';

  @override
  String get offerStatusCancelled => 'Cancelled';

  @override
  String get offerStatusCompleted => 'Completed';

  @override
  String get noIncomingOffers => 'No incoming offers';

  @override
  String get noOutgoingOffers => 'No outgoing offers';

  @override
  String get offerAccepted => 'Offer accepted';

  @override
  String get offerRejected => 'Offer rejected';

  @override
  String get offerCancelled => 'Offer cancelled';

  @override
  String get noConversations => 'No conversations yet';

  @override
  String get noConversationsHint =>
      'Message a seller from a product page to start chatting';

  @override
  String get dealAcceptedSwap => '✓ Swap request accepted';

  @override
  String get dealAcceptedBuy => '✓ Purchase request accepted';

  @override
  String get dealCompleted => 'Deal completed successfully 🎉';

  @override
  String get dealCancelled => 'The deal was cancelled';

  @override
  String get swapDetails => 'Swap details';

  @override
  String get buyDetails => 'Request details';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get typeMessage => 'Type a message...';

  @override
  String get viewProduct => 'View product';

  @override
  String get confirmComplete => 'Confirm deal completion';

  @override
  String get cancelDeal => 'Cancel the deal';

  @override
  String get confirmCompleteBody =>
      'Was the deal really completed? Product statuses will be updated.';

  @override
  String get cancelDealBody =>
      'The deal will be cancelled and products made available again. Sure?';

  @override
  String get dealCompletedSnack => 'Deal confirmed as completed';

  @override
  String get dealCancelledSnack => 'Deal cancelled';

  @override
  String rateExperience(String name) {
    return 'Rate your experience with $name';
  }

  @override
  String get rateNow => 'Rate now';

  @override
  String get writeComment => 'Write a comment (optional)';

  @override
  String get submitReview => 'Submit review';

  @override
  String get reviewSent => 'Thanks for your review';

  @override
  String get errChooseRating => 'Choose a star rating';

  @override
  String get callPeer => 'Call';

  @override
  String get phoneUnavailable => 'Phone number unavailable';

  @override
  String get profileTitle => 'Profile';

  @override
  String get verifiedMember => 'Verified Mubadel member';

  @override
  String get statRating => 'Rating';

  @override
  String get statSwaps => 'Swaps';

  @override
  String get statItems => 'Items';

  @override
  String get myItems => 'My items';

  @override
  String get userItems => 'Items';

  @override
  String get tabMyProducts => 'My products';

  @override
  String get tabMyReviews => 'My reviews';

  @override
  String get tabProducts => 'Products';

  @override
  String get tabReviews => 'Reviews';

  @override
  String get subForSwap => 'For swap';

  @override
  String get subForSale => 'For sale';

  @override
  String get subForBoth => 'Sell or swap';

  @override
  String get subDone => 'Completed';

  @override
  String get noReviews => 'No reviews yet';

  @override
  String get noMyProducts => 'No products yet';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSubtitle => 'Manage your account and preferences';

  @override
  String get editProfileTitle => 'Edit profile';

  @override
  String get changePhoto => 'Change photo';

  @override
  String get languageLabel => 'Language';

  @override
  String get langArabic => 'العربية';

  @override
  String get langEnglish => 'English';

  @override
  String get logout => 'Log out';

  @override
  String get logoutConfirm => 'Are you sure you want to log out?';

  @override
  String get profileSaved => 'Changes saved';

  @override
  String get accountSection => 'Account';
}
