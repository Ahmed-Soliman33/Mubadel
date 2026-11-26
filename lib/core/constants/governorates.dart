/// Egyptian governorates. The Arabic name is what gets stored in `profiles.city`.
class Governorate {
  const Governorate(this.ar, this.en);
  final String ar;
  final String en;
  String name(String lang) => lang == 'ar' ? ar : en;
}

const governorates = <Governorate>[
  Governorate('القاهرة', 'Cairo'),
  Governorate('الجيزة', 'Giza'),
  Governorate('الإسكندرية', 'Alexandria'),
  Governorate('القليوبية', 'Qalyubia'),
  Governorate('الشرقية', 'Sharqia'),
  Governorate('الدقهلية', 'Dakahlia'),
  Governorate('الغربية', 'Gharbia'),
  Governorate('المنوفية', 'Monufia'),
  Governorate('البحيرة', 'Beheira'),
  Governorate('كفر الشيخ', 'Kafr El Sheikh'),
  Governorate('دمياط', 'Damietta'),
  Governorate('بورسعيد', 'Port Said'),
  Governorate('الإسماعيلية', 'Ismailia'),
  Governorate('السويس', 'Suez'),
  Governorate('شمال سيناء', 'North Sinai'),
  Governorate('جنوب سيناء', 'South Sinai'),
  Governorate('الفيوم', 'Faiyum'),
  Governorate('بني سويف', 'Beni Suef'),
  Governorate('المنيا', 'Minya'),
  Governorate('أسيوط', 'Asyut'),
  Governorate('سوهاج', 'Sohag'),
  Governorate('قنا', 'Qena'),
  Governorate('الأقصر', 'Luxor'),
  Governorate('أسوان', 'Aswan'),
  Governorate('البحر الأحمر', 'Red Sea'),
  Governorate('الوادي الجديد', 'New Valley'),
  Governorate('مطروح', 'Matrouh'),
];

/// Display name for a stored (Arabic) city value.
String cityLabel(String? stored, String lang) {
  if (stored == null || stored.isEmpty) return '';
  if (lang == 'ar') return stored;
  for (final g in governorates) {
    if (g.ar == stored) return g.en;
  }
  return stored;
}
