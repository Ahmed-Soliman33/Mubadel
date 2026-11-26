// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'مُبدل';

  @override
  String get tagline => 'مساحتك للتبديل';

  @override
  String get slogan => 'خلّي اللي مش محتاجه يلاقي صاحب جديد';

  @override
  String get start => 'ابدأ';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navFavorites => 'المفضلة';

  @override
  String get navAdd => 'أضف';

  @override
  String get navMessages => 'رسائلي';

  @override
  String get navProfile => 'حسابي';

  @override
  String get retry => 'حاول تاني';

  @override
  String get errorGeneric => 'حصل خطأ، حاول تاني';

  @override
  String get emptyNoResults => 'مفيش نتائج';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get currencyEgp => 'ج.م';

  @override
  String get configMissingTitle => 'الإعدادات ناقصة';

  @override
  String get configMissingBody =>
      'مفاتيح Supabase مش موجودة. أضف ملف env.json في جذر المشروع وشغّل التطبيق بـ --dart-define-from-file=env.json';

  @override
  String get conditionNew => 'جديد';

  @override
  String get conditionLikeNew => 'شبه جديد';

  @override
  String get conditionUsed => 'مستعمل';

  @override
  String get listingBoth => 'بيع أو تبديل';

  @override
  String get listingSwap => 'للتبديل فقط';

  @override
  String get listingSale => 'للبيع فقط';

  @override
  String get priceSwap => 'للتبديل';

  @override
  String get statusAvailable => 'متاح';

  @override
  String get statusReserved => 'محجوز';

  @override
  String get statusSwapped => 'تم التبديل';

  @override
  String get statusSold => 'تم البيع';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get save => 'حفظ';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String ratingsCount(String num) {
    return '($num تقييم)';
  }

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get loginSubtitle => 'املأ البيانات لدخول حسابك';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get emailHint => 'ادخل بريدك الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get passwordHint => 'ادخل كلمة المرور';

  @override
  String get rememberMe => 'تذكرني';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get noAccount => 'إنشاء حساب جديد؟';

  @override
  String get signUpNow => 'سجل دلوقتي';

  @override
  String get signupTitle => 'إنشاء حساب جديد';

  @override
  String get signupSubtitle => 'املأ البيانات لإنشاء حسابك الجديد';

  @override
  String get fullName => 'الاسم بالكامل';

  @override
  String get fullNameHint => 'ادخل اسمك بالكامل';

  @override
  String get phone => 'رقم التليفون';

  @override
  String get phoneHint => '010xxxxxxxx';

  @override
  String get governorate => 'المحافظة';

  @override
  String get selectGovernorate => 'اختر المحافظة';

  @override
  String get address => 'العنوان';

  @override
  String get addressHint => 'ادخل عنوانك';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get haveAccount => 'عندك حساب؟';

  @override
  String get loginNow => 'سجّل دخول';

  @override
  String get errEmailInvalid => 'ادخل بريد إلكتروني صحيح';

  @override
  String get errPasswordShort => 'كلمة المرور لازم تكون ٦ حروف على الأقل';

  @override
  String get errRequired => 'الحقل ده مطلوب';

  @override
  String get errPhoneInvalid => 'ادخل رقم موبايل مصري صحيح';

  @override
  String get errNameShort => 'الاسم لازم يكون ٣ حروف على الأقل';

  @override
  String get errInvalidCredentials => 'البريد أو كلمة المرور غير صحيحة';

  @override
  String get errEmailTaken => 'البريد ده مسجّل قبل كده';

  @override
  String get errInvalidCode => 'الكود غير صحيح أو منتهي';

  @override
  String get errNetwork => 'مفيش اتصال بالإنترنت';

  @override
  String get errPasswordsMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get forgotTitle => 'نسيت كلمة المرور؟';

  @override
  String get forgotSubtitle => 'ادخل بريدك وهنبعتلك كود لإعادة التعيين';

  @override
  String get sendCode => 'إرسال الكود';

  @override
  String get resetTitle => 'إعادة تعيين كلمة المرور';

  @override
  String resetSubtitle(String email) {
    return 'ادخل الكود اللي وصلك على $email وكلمة المرور الجديدة';
  }

  @override
  String get code => 'الكود';

  @override
  String get codeHint => 'ادخل الكود المكوّن من ٦ أرقام';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get savePassword => 'حفظ كلمة المرور';

  @override
  String get backToLogin => 'رجوع لتسجيل الدخول';

  @override
  String get splashLanguage => 'English';

  @override
  String get searchHint => 'بتدور على إيه النهارده؟';

  @override
  String get bannerText => 'اللي مش محتاجه .. ممكن يكون كنز لحد تاني';

  @override
  String get bannerButton => 'ابدأ التبديل';

  @override
  String get browseCategories => 'تصفّح الأقسام';

  @override
  String get featured => 'لقطات ممكن تعجبك';

  @override
  String get searchTitle => 'بحث';

  @override
  String get filterCategory => 'القسم';

  @override
  String get filterType => 'النوع';

  @override
  String get filterCondition => 'الحالة';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterSale => 'بيع';

  @override
  String get filterSwap => 'تبديل';

  @override
  String get productDetailsTitle => 'تفاصيل المنتج';

  @override
  String get productDetailsSubtitle => 'راجع التفاصيل قبل ما تبعت عرض';

  @override
  String get ownerSection => 'صاحب المنتج';

  @override
  String memberSince(String year) {
    return 'عضو من $year';
  }

  @override
  String get makeOffer => 'اعرض تبديل';

  @override
  String get buy => 'اشتري';

  @override
  String get messageSeller => 'راسل البائع';

  @override
  String get edit => 'تعديل';

  @override
  String get delete => 'حذف';

  @override
  String get deleteConfirmTitle => 'حذف المنتج';

  @override
  String get deleteConfirmBody => 'متأكد إنك عايز تحذف المنتج ده؟';

  @override
  String get productUnavailable => 'المنتج غير متاح حاليًا';

  @override
  String get offerSent => 'تم إرسال عرضك';

  @override
  String get categoryLabel => 'القسم';

  @override
  String get conditionLabel => 'الحالة';

  @override
  String get addProductTitle => 'أضف منتجك';

  @override
  String get addProductSubtitle => 'خلّي حاجتك تلاقي استخدام جديد';

  @override
  String get editProductTitle => 'تعديل المنتج';

  @override
  String get productImages => 'صور المنتج';

  @override
  String get addImages => 'أضف صور';

  @override
  String get photoTip => 'صوّر المنتج في إضاءة كويسة';

  @override
  String get productData => 'بيانات المنتج';

  @override
  String get productName => 'اسم المنتج';

  @override
  String get productNameHint => 'مثال: موبايل سامسونج A54';

  @override
  String get descriptionLabel => 'الوصف';

  @override
  String get descriptionHint => 'اكتب وصف المنتج وحالته';

  @override
  String get selectCategory => 'اختر القسم';

  @override
  String get productCondition => 'حالة المنتج';

  @override
  String get howToList => 'عايز تعرضه إزاي؟';

  @override
  String get priceLabel => 'السعر المطلوب (جنيه)';

  @override
  String get priceHint => 'مثال: ٥٠٠';

  @override
  String get publish => 'انشر المنتج';

  @override
  String get saveChanges => 'حفظ التعديلات';

  @override
  String get errImagesRequired => 'أضف صورة واحدة على الأقل';

  @override
  String get errCategoryRequired => 'اختر القسم';

  @override
  String get errPriceRequired => 'ادخل السعر';

  @override
  String get errConditionRequired => 'اختر حالة المنتج';

  @override
  String get maxImages => 'الحد الأقصى ٦ صور';

  @override
  String get coverLabel => 'الغلاف';

  @override
  String get camera => 'الكاميرا';

  @override
  String get gallery => 'المعرض';

  @override
  String get productPublished => 'تم نشر المنتج';

  @override
  String get productSaved => 'تم حفظ التعديلات';

  @override
  String get productDeleted => 'تم حذف المنتج';

  @override
  String get listingSaleShort => 'للبيع';

  @override
  String get listingSwapShort => 'للتبديل';

  @override
  String get favoritesTitle => 'المفضلة';

  @override
  String get favoritesSubtitle => 'المنتجات اللي حفظتها';

  @override
  String get noFavorites => 'لسه مفيش حاجة في المفضلة';

  @override
  String get noFavoritesHint => 'اضغط على القلب لحفظ المنتجات';

  @override
  String get noProducts => 'مفيش منتجات';

  @override
  String get buyRequestTitle => 'طلب شراء';

  @override
  String get cashOnDelivery => 'الدفع عند الاستلام';

  @override
  String get noteOptional => 'ملاحظة (اختياري)';

  @override
  String get noteHint => 'اكتب ملاحظتك للبائع';

  @override
  String get sendBuyRequest => 'إرسال طلب الشراء';

  @override
  String get buyRequestSent => 'تم إرسال طلب الشراء';

  @override
  String get makeOfferTitle => 'اعرض تبديل';

  @override
  String get makeOfferSubtitle => 'اختار حاجة من عندك مقابل المنتج';

  @override
  String get requestedProduct => 'المنتج المطلوب';

  @override
  String byOwner(String name, String city) {
    return 'بواسطة $name · $city';
  }

  @override
  String byOwnerNoCity(String name) {
    return 'بواسطة $name';
  }

  @override
  String get chooseYourProduct => 'اختار منتجك اللي هتعرضه';

  @override
  String get noProductsToOffer => 'مفيش عندك منتجات متاحة';

  @override
  String get noProductsToOfferHint => 'أضف منتج الأول عشان تقدر تعرضه للتبديل';

  @override
  String get addProduct => 'أضف منتج';

  @override
  String get cashDiff => 'فرق نقدي (اختياري)';

  @override
  String get cashDiffHint => 'مثال: هدفع ٢,٥٠٠ ج.م زيادة';

  @override
  String get cashDiffNote => 'الفرق النهائي بيتحدد بالاتفاق بين الطرفين.';

  @override
  String get sendSwapOffer => 'إرسال عرض التبديل';

  @override
  String get swapOfferSent => 'تم إرسال عرض التبديل';

  @override
  String get errSelectProduct => 'اختار منتج للتبديل';

  @override
  String get messagesTitle => 'رسائلي';

  @override
  String get messagesSubtitle => 'محادثاتك وعروضك في مكان واحد';

  @override
  String get tabConversations => 'المحادثات';

  @override
  String get tabOffers => 'العروض';

  @override
  String get offersIncoming => 'واردة';

  @override
  String get offersOutgoing => 'صادرة';

  @override
  String get accept => 'قبول';

  @override
  String get reject => 'رفض';

  @override
  String get cancelOffer => 'إلغاء العرض';

  @override
  String get openChat => 'فتح المحادثة';

  @override
  String get offerBuyLabel => 'شراء';

  @override
  String offerCash(String amount) {
    return 'فرق نقدي: $amount';
  }

  @override
  String offerWith(String name) {
    return 'مع $name';
  }

  @override
  String get offerStatusPending => 'قيد الانتظار';

  @override
  String get offerStatusAccepted => 'تم القبول';

  @override
  String get offerStatusRejected => 'مرفوض';

  @override
  String get offerStatusCancelled => 'ملغي';

  @override
  String get offerStatusCompleted => 'تمت الصفقة';

  @override
  String get noIncomingOffers => 'مفيش عروض واردة';

  @override
  String get noOutgoingOffers => 'مفيش عروض صادرة';

  @override
  String get offerAccepted => 'تم قبول العرض';

  @override
  String get offerRejected => 'تم رفض العرض';

  @override
  String get offerCancelled => 'تم إلغاء العرض';

  @override
  String get noConversations => 'مفيش محادثات لسه';

  @override
  String get noConversationsHint => 'راسل بائع من صفحة المنتج وابدأ المحادثة';

  @override
  String get dealAcceptedSwap => '✓ تم قبول طلب التبادل';

  @override
  String get dealAcceptedBuy => '✓ تم قبول طلب الشراء';

  @override
  String get dealCompleted => 'تمت الصفقة بنجاح 🎉';

  @override
  String get dealCancelled => 'تم إلغاء الاتفاق';

  @override
  String get swapDetails => 'تفاصيل التبادل';

  @override
  String get buyDetails => 'تفاصيل الطلب';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String get typeMessage => 'اكتب رسالة...';

  @override
  String get viewProduct => 'عرض المنتج';

  @override
  String get confirmComplete => 'تأكيد إتمام الصفقة';

  @override
  String get cancelDeal => 'إلغاء الاتفاق';

  @override
  String get confirmCompleteBody =>
      'هل تمت الصفقة فعلاً؟ هيتم تغيير حالة المنتجات.';

  @override
  String get cancelDealBody =>
      'هيتم إلغاء الاتفاق وإرجاع المنتجات متاحة. متأكد؟';

  @override
  String get dealCompletedSnack => 'تم تأكيد إتمام الصفقة';

  @override
  String get dealCancelledSnack => 'تم إلغاء الاتفاق';

  @override
  String rateExperience(String name) {
    return 'قيّم تجربتك مع $name';
  }

  @override
  String get rateNow => 'قيّم دلوقتي';

  @override
  String get writeComment => 'اكتب تعليقك (اختياري)';

  @override
  String get submitReview => 'إرسال التقييم';

  @override
  String get reviewSent => 'شكرًا على تقييمك';

  @override
  String get errChooseRating => 'اختار عدد النجوم';

  @override
  String get callPeer => 'اتصال';

  @override
  String get phoneUnavailable => 'رقم التليفون غير متاح';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get verifiedMember => 'عضو موثق في مجتمع مُبدل';

  @override
  String get statRating => 'التقييم';

  @override
  String get statSwaps => 'تبديل';

  @override
  String get statItems => 'عنصر';

  @override
  String get myItems => 'عناصري';

  @override
  String get userItems => 'العناصر';

  @override
  String get tabMyProducts => 'منتجاتي';

  @override
  String get tabMyReviews => 'تقييماتي';

  @override
  String get tabProducts => 'المنتجات';

  @override
  String get tabReviews => 'التقييمات';

  @override
  String get subForSwap => 'للتبديل';

  @override
  String get subForSale => 'للبيع';

  @override
  String get subForBoth => 'بيع أو تبديل';

  @override
  String get subDone => 'تم بنجاح';

  @override
  String get noReviews => 'مفيش تقييمات لسه';

  @override
  String get noMyProducts => 'لسه مفيش منتجات';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsSubtitle => 'إدارة حسابك وتفضيلاتك';

  @override
  String get editProfileTitle => 'تعديل الملف الشخصي';

  @override
  String get changePhoto => 'تغيير الصورة';

  @override
  String get languageLabel => 'اللغة';

  @override
  String get langArabic => 'العربية';

  @override
  String get langEnglish => 'English';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutConfirm => 'متأكد إنك عايز تسجل خروج؟';

  @override
  String get profileSaved => 'تم حفظ التغييرات';

  @override
  String get accountSection => 'الحساب';
}
