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
}
