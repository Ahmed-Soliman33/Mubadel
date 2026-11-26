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
  String ratingsCount(int count) {
    return '($count تقييم)';
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
}
