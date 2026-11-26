import 'package:intl/intl.dart';

/// Locale-aware formatting. `lang` is 'ar' or 'en'.
class Fmt {
  const Fmt._();

  static String _loc(String lang) => lang == 'ar' ? 'ar_EG' : 'en_US';

  static String number(num n, String lang) =>
      NumberFormat.decimalPattern(_loc(lang)).format(n);

  /// `١٢,٥٠٠ ج.م` / `EGP 12,500`
  static String price(num n, String lang) => lang == 'ar'
      ? '${number(n, lang)} ج.م'
      : 'EGP ${number(n, lang)}';

  /// `10:32 ص` / `10:32 AM`
  static String time(DateTime d, String lang) =>
      DateFormat('h:mm a', _loc(lang)).format(d.toLocal());

  static String date(DateTime d, String lang) =>
      DateFormat.yMMMd(_loc(lang)).format(d.toLocal());

  static String year(DateTime d, String lang) =>
      NumberFormat('0', _loc(lang)).format(d.toLocal().year);

  /// `4.8` with locale digits.
  static String rating(num r, String lang) =>
      NumberFormat('0.0', _loc(lang)).format(r);

  static bool sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
