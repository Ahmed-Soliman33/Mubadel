import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In ar, this message translates to:
  /// **'مُبدل'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In ar, this message translates to:
  /// **'مساحتك للتبديل'**
  String get tagline;

  /// No description provided for @slogan.
  ///
  /// In ar, this message translates to:
  /// **'خلّي اللي مش محتاجه يلاقي صاحب جديد'**
  String get slogan;

  /// No description provided for @start.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ'**
  String get start;

  /// No description provided for @navHome.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get navHome;

  /// No description provided for @navFavorites.
  ///
  /// In ar, this message translates to:
  /// **'المفضلة'**
  String get navFavorites;

  /// No description provided for @navAdd.
  ///
  /// In ar, this message translates to:
  /// **'أضف'**
  String get navAdd;

  /// No description provided for @navMessages.
  ///
  /// In ar, this message translates to:
  /// **'رسائلي'**
  String get navMessages;

  /// No description provided for @navProfile.
  ///
  /// In ar, this message translates to:
  /// **'حسابي'**
  String get navProfile;

  /// No description provided for @retry.
  ///
  /// In ar, this message translates to:
  /// **'حاول تاني'**
  String get retry;

  /// No description provided for @errorGeneric.
  ///
  /// In ar, this message translates to:
  /// **'حصل خطأ، حاول تاني'**
  String get errorGeneric;

  /// No description provided for @emptyNoResults.
  ///
  /// In ar, this message translates to:
  /// **'مفيش نتائج'**
  String get emptyNoResults;

  /// No description provided for @loading.
  ///
  /// In ar, this message translates to:
  /// **'جاري التحميل...'**
  String get loading;

  /// No description provided for @currencyEgp.
  ///
  /// In ar, this message translates to:
  /// **'ج.م'**
  String get currencyEgp;

  /// No description provided for @configMissingTitle.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات ناقصة'**
  String get configMissingTitle;

  /// No description provided for @configMissingBody.
  ///
  /// In ar, this message translates to:
  /// **'مفاتيح Supabase مش موجودة. أضف ملف env.json في جذر المشروع وشغّل التطبيق بـ --dart-define-from-file=env.json'**
  String get configMissingBody;

  /// No description provided for @conditionNew.
  ///
  /// In ar, this message translates to:
  /// **'جديد'**
  String get conditionNew;

  /// No description provided for @conditionLikeNew.
  ///
  /// In ar, this message translates to:
  /// **'شبه جديد'**
  String get conditionLikeNew;

  /// No description provided for @conditionUsed.
  ///
  /// In ar, this message translates to:
  /// **'مستعمل'**
  String get conditionUsed;

  /// No description provided for @listingBoth.
  ///
  /// In ar, this message translates to:
  /// **'بيع أو تبديل'**
  String get listingBoth;

  /// No description provided for @listingSwap.
  ///
  /// In ar, this message translates to:
  /// **'للتبديل فقط'**
  String get listingSwap;

  /// No description provided for @listingSale.
  ///
  /// In ar, this message translates to:
  /// **'للبيع فقط'**
  String get listingSale;

  /// No description provided for @priceSwap.
  ///
  /// In ar, this message translates to:
  /// **'للتبديل'**
  String get priceSwap;

  /// No description provided for @statusAvailable.
  ///
  /// In ar, this message translates to:
  /// **'متاح'**
  String get statusAvailable;

  /// No description provided for @statusReserved.
  ///
  /// In ar, this message translates to:
  /// **'محجوز'**
  String get statusReserved;

  /// No description provided for @statusSwapped.
  ///
  /// In ar, this message translates to:
  /// **'تم التبديل'**
  String get statusSwapped;

  /// No description provided for @statusSold.
  ///
  /// In ar, this message translates to:
  /// **'تم البيع'**
  String get statusSold;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد'**
  String get confirm;

  /// No description provided for @save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// No description provided for @viewAll.
  ///
  /// In ar, this message translates to:
  /// **'عرض الكل'**
  String get viewAll;

  /// No description provided for @ratingsCount.
  ///
  /// In ar, this message translates to:
  /// **'({num} تقييم)'**
  String ratingsCount(String num);

  /// No description provided for @loginTitle.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'املأ البيانات لدخول حسابك'**
  String get loginSubtitle;

  /// No description provided for @email.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In ar, this message translates to:
  /// **'ادخل بريدك الإلكتروني'**
  String get emailHint;

  /// No description provided for @password.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In ar, this message translates to:
  /// **'ادخل كلمة المرور'**
  String get passwordHint;

  /// No description provided for @rememberMe.
  ///
  /// In ar, this message translates to:
  /// **'تذكرني'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In ar, this message translates to:
  /// **'نسيت كلمة المرور؟'**
  String get forgotPassword;

  /// No description provided for @loginButton.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get loginButton;

  /// No description provided for @noAccount.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب جديد؟'**
  String get noAccount;

  /// No description provided for @signUpNow.
  ///
  /// In ar, this message translates to:
  /// **'سجل دلوقتي'**
  String get signUpNow;

  /// No description provided for @signupTitle.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب جديد'**
  String get signupTitle;

  /// No description provided for @signupSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'املأ البيانات لإنشاء حسابك الجديد'**
  String get signupSubtitle;

  /// No description provided for @fullName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم بالكامل'**
  String get fullName;

  /// No description provided for @fullNameHint.
  ///
  /// In ar, this message translates to:
  /// **'ادخل اسمك بالكامل'**
  String get fullNameHint;

  /// No description provided for @phone.
  ///
  /// In ar, this message translates to:
  /// **'رقم التليفون'**
  String get phone;

  /// No description provided for @phoneHint.
  ///
  /// In ar, this message translates to:
  /// **'010xxxxxxxx'**
  String get phoneHint;

  /// No description provided for @governorate.
  ///
  /// In ar, this message translates to:
  /// **'المحافظة'**
  String get governorate;

  /// No description provided for @selectGovernorate.
  ///
  /// In ar, this message translates to:
  /// **'اختر المحافظة'**
  String get selectGovernorate;

  /// No description provided for @address.
  ///
  /// In ar, this message translates to:
  /// **'العنوان'**
  String get address;

  /// No description provided for @addressHint.
  ///
  /// In ar, this message translates to:
  /// **'ادخل عنوانك'**
  String get addressHint;

  /// No description provided for @createAccount.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب'**
  String get createAccount;

  /// No description provided for @haveAccount.
  ///
  /// In ar, this message translates to:
  /// **'عندك حساب؟'**
  String get haveAccount;

  /// No description provided for @loginNow.
  ///
  /// In ar, this message translates to:
  /// **'سجّل دخول'**
  String get loginNow;

  /// No description provided for @errEmailInvalid.
  ///
  /// In ar, this message translates to:
  /// **'ادخل بريد إلكتروني صحيح'**
  String get errEmailInvalid;

  /// No description provided for @errPasswordShort.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور لازم تكون ٦ حروف على الأقل'**
  String get errPasswordShort;

  /// No description provided for @errRequired.
  ///
  /// In ar, this message translates to:
  /// **'الحقل ده مطلوب'**
  String get errRequired;

  /// No description provided for @errPhoneInvalid.
  ///
  /// In ar, this message translates to:
  /// **'ادخل رقم موبايل مصري صحيح'**
  String get errPhoneInvalid;

  /// No description provided for @errNameShort.
  ///
  /// In ar, this message translates to:
  /// **'الاسم لازم يكون ٣ حروف على الأقل'**
  String get errNameShort;

  /// No description provided for @errInvalidCredentials.
  ///
  /// In ar, this message translates to:
  /// **'البريد أو كلمة المرور غير صحيحة'**
  String get errInvalidCredentials;

  /// No description provided for @errEmailTaken.
  ///
  /// In ar, this message translates to:
  /// **'البريد ده مسجّل قبل كده'**
  String get errEmailTaken;

  /// No description provided for @errInvalidCode.
  ///
  /// In ar, this message translates to:
  /// **'الكود غير صحيح أو منتهي'**
  String get errInvalidCode;

  /// No description provided for @errNetwork.
  ///
  /// In ar, this message translates to:
  /// **'مفيش اتصال بالإنترنت'**
  String get errNetwork;

  /// No description provided for @errPasswordsMismatch.
  ///
  /// In ar, this message translates to:
  /// **'كلمتا المرور غير متطابقتين'**
  String get errPasswordsMismatch;

  /// No description provided for @forgotTitle.
  ///
  /// In ar, this message translates to:
  /// **'نسيت كلمة المرور؟'**
  String get forgotTitle;

  /// No description provided for @forgotSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'ادخل بريدك وهنبعتلك كود لإعادة التعيين'**
  String get forgotSubtitle;

  /// No description provided for @sendCode.
  ///
  /// In ar, this message translates to:
  /// **'إرسال الكود'**
  String get sendCode;

  /// No description provided for @resetTitle.
  ///
  /// In ar, this message translates to:
  /// **'إعادة تعيين كلمة المرور'**
  String get resetTitle;

  /// No description provided for @resetSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'ادخل الكود اللي وصلك على {email} وكلمة المرور الجديدة'**
  String resetSubtitle(String email);

  /// No description provided for @code.
  ///
  /// In ar, this message translates to:
  /// **'الكود'**
  String get code;

  /// No description provided for @codeHint.
  ///
  /// In ar, this message translates to:
  /// **'ادخل الكود المكوّن من ٦ أرقام'**
  String get codeHint;

  /// No description provided for @newPassword.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور الجديدة'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد كلمة المرور'**
  String get confirmPassword;

  /// No description provided for @savePassword.
  ///
  /// In ar, this message translates to:
  /// **'حفظ كلمة المرور'**
  String get savePassword;

  /// No description provided for @backToLogin.
  ///
  /// In ar, this message translates to:
  /// **'رجوع لتسجيل الدخول'**
  String get backToLogin;

  /// No description provided for @splashLanguage.
  ///
  /// In ar, this message translates to:
  /// **'English'**
  String get splashLanguage;

  /// No description provided for @searchHint.
  ///
  /// In ar, this message translates to:
  /// **'بتدور على إيه النهارده؟'**
  String get searchHint;

  /// No description provided for @bannerText.
  ///
  /// In ar, this message translates to:
  /// **'اللي مش محتاجه .. ممكن يكون كنز لحد تاني'**
  String get bannerText;

  /// No description provided for @bannerButton.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ التبديل'**
  String get bannerButton;

  /// No description provided for @browseCategories.
  ///
  /// In ar, this message translates to:
  /// **'تصفّح الأقسام'**
  String get browseCategories;

  /// No description provided for @featured.
  ///
  /// In ar, this message translates to:
  /// **'لقطات ممكن تعجبك'**
  String get featured;

  /// No description provided for @searchTitle.
  ///
  /// In ar, this message translates to:
  /// **'بحث'**
  String get searchTitle;

  /// No description provided for @filterCategory.
  ///
  /// In ar, this message translates to:
  /// **'القسم'**
  String get filterCategory;

  /// No description provided for @filterType.
  ///
  /// In ar, this message translates to:
  /// **'النوع'**
  String get filterType;

  /// No description provided for @filterCondition.
  ///
  /// In ar, this message translates to:
  /// **'الحالة'**
  String get filterCondition;

  /// No description provided for @filterAll.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get filterAll;

  /// No description provided for @filterSale.
  ///
  /// In ar, this message translates to:
  /// **'بيع'**
  String get filterSale;

  /// No description provided for @filterSwap.
  ///
  /// In ar, this message translates to:
  /// **'تبديل'**
  String get filterSwap;

  /// No description provided for @productDetailsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل المنتج'**
  String get productDetailsTitle;

  /// No description provided for @productDetailsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'راجع التفاصيل قبل ما تبعت عرض'**
  String get productDetailsSubtitle;

  /// No description provided for @ownerSection.
  ///
  /// In ar, this message translates to:
  /// **'صاحب المنتج'**
  String get ownerSection;

  /// No description provided for @memberSince.
  ///
  /// In ar, this message translates to:
  /// **'عضو من {year}'**
  String memberSince(String year);

  /// No description provided for @makeOffer.
  ///
  /// In ar, this message translates to:
  /// **'اعرض تبديل'**
  String get makeOffer;

  /// No description provided for @buy.
  ///
  /// In ar, this message translates to:
  /// **'اشتري'**
  String get buy;

  /// No description provided for @messageSeller.
  ///
  /// In ar, this message translates to:
  /// **'راسل البائع'**
  String get messageSeller;

  /// No description provided for @edit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get delete;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In ar, this message translates to:
  /// **'حذف المنتج'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmBody.
  ///
  /// In ar, this message translates to:
  /// **'متأكد إنك عايز تحذف المنتج ده؟'**
  String get deleteConfirmBody;

  /// No description provided for @productUnavailable.
  ///
  /// In ar, this message translates to:
  /// **'المنتج غير متاح حاليًا'**
  String get productUnavailable;

  /// No description provided for @offerSent.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال عرضك'**
  String get offerSent;

  /// No description provided for @categoryLabel.
  ///
  /// In ar, this message translates to:
  /// **'القسم'**
  String get categoryLabel;

  /// No description provided for @conditionLabel.
  ///
  /// In ar, this message translates to:
  /// **'الحالة'**
  String get conditionLabel;

  /// No description provided for @addProductTitle.
  ///
  /// In ar, this message translates to:
  /// **'أضف منتجك'**
  String get addProductTitle;

  /// No description provided for @addProductSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'خلّي حاجتك تلاقي استخدام جديد'**
  String get addProductSubtitle;

  /// No description provided for @editProductTitle.
  ///
  /// In ar, this message translates to:
  /// **'تعديل المنتج'**
  String get editProductTitle;

  /// No description provided for @productImages.
  ///
  /// In ar, this message translates to:
  /// **'صور المنتج'**
  String get productImages;

  /// No description provided for @addImages.
  ///
  /// In ar, this message translates to:
  /// **'أضف صور'**
  String get addImages;

  /// No description provided for @photoTip.
  ///
  /// In ar, this message translates to:
  /// **'صوّر المنتج في إضاءة كويسة'**
  String get photoTip;

  /// No description provided for @productData.
  ///
  /// In ar, this message translates to:
  /// **'بيانات المنتج'**
  String get productData;

  /// No description provided for @productName.
  ///
  /// In ar, this message translates to:
  /// **'اسم المنتج'**
  String get productName;

  /// No description provided for @productNameHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: موبايل سامسونج A54'**
  String get productNameHint;

  /// No description provided for @descriptionLabel.
  ///
  /// In ar, this message translates to:
  /// **'الوصف'**
  String get descriptionLabel;

  /// No description provided for @descriptionHint.
  ///
  /// In ar, this message translates to:
  /// **'اكتب وصف المنتج وحالته'**
  String get descriptionHint;

  /// No description provided for @selectCategory.
  ///
  /// In ar, this message translates to:
  /// **'اختر القسم'**
  String get selectCategory;

  /// No description provided for @productCondition.
  ///
  /// In ar, this message translates to:
  /// **'حالة المنتج'**
  String get productCondition;

  /// No description provided for @howToList.
  ///
  /// In ar, this message translates to:
  /// **'عايز تعرضه إزاي؟'**
  String get howToList;

  /// No description provided for @priceLabel.
  ///
  /// In ar, this message translates to:
  /// **'السعر المطلوب (جنيه)'**
  String get priceLabel;

  /// No description provided for @priceHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: ٥٠٠'**
  String get priceHint;

  /// No description provided for @publish.
  ///
  /// In ar, this message translates to:
  /// **'انشر المنتج'**
  String get publish;

  /// No description provided for @saveChanges.
  ///
  /// In ar, this message translates to:
  /// **'حفظ التعديلات'**
  String get saveChanges;

  /// No description provided for @errImagesRequired.
  ///
  /// In ar, this message translates to:
  /// **'أضف صورة واحدة على الأقل'**
  String get errImagesRequired;

  /// No description provided for @errCategoryRequired.
  ///
  /// In ar, this message translates to:
  /// **'اختر القسم'**
  String get errCategoryRequired;

  /// No description provided for @errPriceRequired.
  ///
  /// In ar, this message translates to:
  /// **'ادخل السعر'**
  String get errPriceRequired;

  /// No description provided for @errConditionRequired.
  ///
  /// In ar, this message translates to:
  /// **'اختر حالة المنتج'**
  String get errConditionRequired;

  /// No description provided for @maxImages.
  ///
  /// In ar, this message translates to:
  /// **'الحد الأقصى ٦ صور'**
  String get maxImages;

  /// No description provided for @coverLabel.
  ///
  /// In ar, this message translates to:
  /// **'الغلاف'**
  String get coverLabel;

  /// No description provided for @camera.
  ///
  /// In ar, this message translates to:
  /// **'الكاميرا'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In ar, this message translates to:
  /// **'المعرض'**
  String get gallery;

  /// No description provided for @productPublished.
  ///
  /// In ar, this message translates to:
  /// **'تم نشر المنتج'**
  String get productPublished;

  /// No description provided for @productSaved.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ التعديلات'**
  String get productSaved;

  /// No description provided for @productDeleted.
  ///
  /// In ar, this message translates to:
  /// **'تم حذف المنتج'**
  String get productDeleted;

  /// No description provided for @listingSaleShort.
  ///
  /// In ar, this message translates to:
  /// **'للبيع'**
  String get listingSaleShort;

  /// No description provided for @listingSwapShort.
  ///
  /// In ar, this message translates to:
  /// **'للتبديل'**
  String get listingSwapShort;

  /// No description provided for @favoritesTitle.
  ///
  /// In ar, this message translates to:
  /// **'المفضلة'**
  String get favoritesTitle;

  /// No description provided for @favoritesSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'المنتجات اللي حفظتها'**
  String get favoritesSubtitle;

  /// No description provided for @noFavorites.
  ///
  /// In ar, this message translates to:
  /// **'لسه مفيش حاجة في المفضلة'**
  String get noFavorites;

  /// No description provided for @noFavoritesHint.
  ///
  /// In ar, this message translates to:
  /// **'اضغط على القلب لحفظ المنتجات'**
  String get noFavoritesHint;

  /// No description provided for @noProducts.
  ///
  /// In ar, this message translates to:
  /// **'مفيش منتجات'**
  String get noProducts;

  /// No description provided for @buyRequestTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلب شراء'**
  String get buyRequestTitle;

  /// No description provided for @cashOnDelivery.
  ///
  /// In ar, this message translates to:
  /// **'الدفع عند الاستلام'**
  String get cashOnDelivery;

  /// No description provided for @noteOptional.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظة (اختياري)'**
  String get noteOptional;

  /// No description provided for @noteHint.
  ///
  /// In ar, this message translates to:
  /// **'اكتب ملاحظتك للبائع'**
  String get noteHint;

  /// No description provided for @sendBuyRequest.
  ///
  /// In ar, this message translates to:
  /// **'إرسال طلب الشراء'**
  String get sendBuyRequest;

  /// No description provided for @buyRequestSent.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال طلب الشراء'**
  String get buyRequestSent;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
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
