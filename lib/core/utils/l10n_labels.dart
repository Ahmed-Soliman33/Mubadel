import 'package:flutter/widgets.dart';

import '../../features/products/data/product_models.dart';
import '../../l10n/app_localizations.dart';

extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  String get lang => Localizations.localeOf(this).languageCode;
  bool get isRtl => Directionality.of(this) == TextDirection.rtl;
}

extension ProductLabels on AppLocalizations {
  String condition(ProductCondition c) => switch (c) {
        ProductCondition.newItem => conditionNew,
        ProductCondition.likeNew => conditionLikeNew,
        ProductCondition.used => conditionUsed,
      };

  String listing(ListingType t) => switch (t) {
        ListingType.both => listingBoth,
        ListingType.swap => listingSwap,
        ListingType.sale => listingSale,
      };

  String productStatus(ProductStatus s) => switch (s) {
        ProductStatus.available => statusAvailable,
        ProductStatus.reserved => statusReserved,
        ProductStatus.swapped => statusSwapped,
        ProductStatus.sold => statusSold,
      };
}
