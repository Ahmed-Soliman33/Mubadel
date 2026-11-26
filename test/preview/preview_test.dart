// Renders every screen with fake data (no Supabase) to PNGs in
// test/preview/out/ so they can be compared with design/ in RTL and LTR.
//
//   flutter test test/preview --update-goldens
import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mubadel/core/locale/locale_provider.dart';
import 'package:mubadel/core/supabase/supabase_provider.dart';
import 'package:mubadel/core/theme/app_theme.dart';
import 'package:mubadel/core/widgets/app_bottom_nav.dart';
import 'package:mubadel/features/auth/presentation/forgot_password_screen.dart';
import 'package:mubadel/features/auth/presentation/login_screen.dart';
import 'package:mubadel/features/auth/presentation/signup_screen.dart';
import 'package:mubadel/features/auth/presentation/splash_screen.dart';
import 'package:mubadel/features/chat/data/chat_models.dart';
import 'package:mubadel/features/chat/data/chat_providers.dart';
import 'package:mubadel/features/chat/presentation/chat_screen.dart';
import 'package:mubadel/features/chat/presentation/messages_screen.dart';
import 'package:mubadel/features/favorites/presentation/favorites_screen.dart';
import 'package:mubadel/features/home/presentation/home_screen.dart';
import 'package:mubadel/features/offers/data/offer_models.dart';
import 'package:mubadel/features/offers/data/offer_providers.dart';
import 'package:mubadel/features/offers/presentation/make_offer_screen.dart';
import 'package:mubadel/features/products/data/product_models.dart';
import 'package:mubadel/features/products/data/product_repository.dart';
import 'package:mubadel/features/products/presentation/product_details_screen.dart';
import 'package:mubadel/features/products/presentation/product_form_screen.dart';
import 'package:mubadel/features/products/presentation/search_screen.dart';
import 'package:mubadel/features/profile/data/profile_repository.dart';
import 'package:mubadel/features/profile/presentation/edit_profile_screen.dart';
import 'package:mubadel/features/profile/presentation/profile_screens.dart';
import 'package:mubadel/features/profile/presentation/settings_screen.dart';
import 'package:mubadel/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ---------------------------------------------------------------- fake data

final _cats = [
  const Category(id: 1, slug: 'home', nameAr: 'منزل', nameEn: 'Home', icon: '🛋️', color: '#EAE6FA'),
  const Category(id: 2, slug: 'tools', nameAr: 'أدوات', nameEn: 'Tools', icon: '🔧', color: '#FFF4D6'),
  const Category(id: 3, slug: 'clothes', nameAr: 'ملابس', nameEn: 'Clothes', icon: '👕', color: '#FFE9D6'),
  const Category(id: 4, slug: 'electronics', nameAr: 'إلكترونيات', nameEn: 'Electronics', icon: '🎧', color: '#DEEAF9'),
  const Category(id: 5, slug: 'mobiles', nameAr: 'موبايلات', nameEn: 'Mobiles', icon: '📱', color: '#DBF2E8'),
];

final _owner = ProfileLite(
  id: 'owner',
  fullName: 'محمد أحمد',
  city: 'القاهرة',
  ratingAvg: 4.8,
  ratingCount: 12,
  swapsCount: 8,
  isVerified: true,
  createdAt: DateTime(2025, 3, 1),
);

Product _p(String id, String title, num? price, ListingType t,
        ProductCondition c, {ProductStatus s = ProductStatus.available, String owner = 'owner'}) =>
    Product(
      id: id,
      ownerId: owner,
      title: title,
      description: 'حالة ممتازة، البطارية بحالة جيدة، مع الكابل الأصلي. متاح للمعاينة قبل الاتفاق.',
      categoryId: 5,
      condition: c,
      listingType: t,
      price: price,
      city: 'القاهرة',
      images: const [],
      status: s,
      createdAt: DateTime(2026, 11, 1),
      category: _cats[4],
      owner: _owner,
    );

final _products = [
  _p('1', 'iPhone 12', 12500, ListingType.both, ProductCondition.used),
  _p('2', 'سماعة لاسلكية', 1200, ListingType.swap, ProductCondition.likeNew),
  _p('3', 'جاكيت شتوي', 800, ListingType.sale, ProductCondition.newItem),
  _p('4', 'AirPods Max', 9000, ListingType.both, ProductCondition.used),
];

final _mine = [
  _p('m1', 'لابتوب Lenovo', 10000, ListingType.both, ProductCondition.used, owner: 'me'),
  _p('m2', 'يد تحكم ألعاب', 1500, ListingType.both, ProductCondition.used, owner: 'me'),
  _p('m3', 'ساعة ذكية', 2000, ListingType.swap, ProductCondition.used, owner: 'me'),
  _p('m4', 'حقيبة ظهر', 600, ListingType.swap, ProductCondition.used,
      s: ProductStatus.swapped, owner: 'me'),
];

const _meProfile = ProfileLite(
  id: 'me',
  fullName: 'نورا سعيد',
  city: 'القاهرة',
  ratingAvg: 4.8,
  ratingCount: 12,
  swapsCount: 8,
  isVerified: true,
);

ProductMini _mini(String id, String title, num price) =>
    ProductMini(id: id, title: title, images: const [], price: price);

final _offerSwap = Offer(
  id: 'o1',
  type: OfferType.swap,
  productId: '1',
  offeredProductId: 'm1',
  senderId: 'owner',
  receiverId: 'me',
  cashAmount: 2500,
  note: null,
  status: OfferStatus.pending,
  createdAt: DateTime(2026, 11, 25),
  product: _mini('1', 'iPhone 12', 12500),
  offered: _mini('m1', 'لابتوب Lenovo', 10000),
  sender: _owner,
  receiver: _meProfile,
);

final _offerBuy = Offer(
  id: 'o2',
  type: OfferType.buy,
  productId: 'm2',
  offeredProductId: null,
  senderId: 'owner',
  receiverId: 'me',
  cashAmount: 1500,
  note: null,
  status: OfferStatus.accepted,
  createdAt: DateTime(2026, 11, 24),
  product: _mini('m2', 'يد تحكم ألعاب', 1500),
  sender: _owner,
  receiver: _meProfile,
);

Conversation _conv(Offer? offer) => Conversation(
      id: 'c1',
      productId: '1',
      offerId: offer?.id,
      user1Id: 'owner',
      user2Id: 'me',
      lastMessage: 'تمام، نحدد وقت التسليم؟',
      lastMessageAt: DateTime.now(),
      product: _mini('1', 'iPhone 12', 12500),
      offer: offer,
      user1: const ProfileLite(id: 'owner', fullName: 'نورا سعيد', city: 'القاهرة'),
      user2: _meProfile,
    );

final _offerChat = Offer(
  id: 'o3',
  type: OfferType.swap,
  productId: 'p',
  offeredProductId: 'q',
  senderId: 'owner',
  receiverId: 'me',
  cashAmount: 0,
  note: null,
  status: OfferStatus.accepted,
  createdAt: DateTime.now(),
  product: _mini('p', 'حقيبة نورا', 600),
  offered: _mini('q', 'سماعات سارة', 1200),
);

List<Message> _msgs() {
  final t = DateTime.now();
  Message m(String id, String from, String body, int min, {bool read = true}) => Message(
        id: id,
        conversationId: 'c1',
        senderId: from,
        body: body,
        readAt: read ? t : null,
        createdAt: DateTime(t.year, t.month, t.day, 10, min),
      );
  return [
    m('1', 'me', 'مرحباً نورا ، هل المنتج لا يزال متاحاً للتبادل؟', 32),
    m('2', 'owner', 'أهلاً سارة ، نعم متاح وما زال جديداً', 33),
    m('3', 'me', 'ممتاز، أرغب في تبديله بالحقيبة الخاصة بي', 35),
    m('4', 'owner', 'تمام، نحدد وقت التسليم؟', 36, read: false),
  ];
}

// ---------------------------------------------------------------- fakes

SupabaseClient _dummyClient() => SupabaseClient('https://x.supabase.co', 'k',
    authOptions: const AuthClientOptions(autoRefreshToken: false));

class _FakeProductRepo extends ProductRepository {
  _FakeProductRepo() : super(_dummyClient());
  @override
  Future<List<Category>> categories() async => _cats;
  @override
  Future<List<Product>> feed(int page) async => page == 0 ? _products : [];
  @override
  Future<List<Product>> search(SearchQuery s, int page) async => page == 0 ? _products : [];
  @override
  Future<Product> byId(String id) async => _products.first;
  @override
  Future<List<Product>> byOwner(String ownerId, {bool availableOnly = false}) async =>
      ownerId == 'me' ? _mine : _products;
  @override
  Future<Set<String>> favoriteIds() async => {'1'};
  @override
  Future<List<Product>> favoriteProducts() async => _products.take(2).toList();
}

class _FakeProfileRepo extends ProfileRepository {
  _FakeProfileRepo() : super(_dummyClient());
  @override
  Future<ProfileLite> byId(String id) async => id == 'me' ? _meProfile : _owner;
  @override
  Future<List<Review>> reviewsFor(String userId) async => [
        Review(
          id: 'r1',
          offerId: 'o',
          reviewerId: 'owner',
          rating: 5,
          comment: 'تعامل ممتاز وسريع، المنتج زي الوصف بالظبط.',
          createdAt: DateTime(2026, 11, 20),
          reviewer: _owner,
        ),
      ];
}

// ---------------------------------------------------------------- harness

final _size = Size(double.parse(Platform.environment['W'] ?? '390'), 844);

List<Override> _overrides(SharedPreferences prefs, {String lang = 'ar'}) => [
      sharedPrefsProvider.overrideWithValue(prefs),
      supabaseProvider.overrideWithValue(_dummyClient()),
      currentUserIdProvider.overrideWithValue('me'),
      productRepositoryProvider.overrideWithValue(_FakeProductRepo()),
      profileRepositoryProvider.overrideWithValue(_FakeProfileRepo()),
      myProfileProvider.overrideWith((ref) async =>
          const MyProfile(base: _meProfile, phone: '01012345678', address: 'مدينة نصر')),
      incomingOffersProvider.overrideWith((ref) async => [_offerSwap, _offerBuy]),
      outgoingOffersProvider.overrideWith((ref) async => [_offerBuy]),
      hasPendingOfferProvider.overrideWith((ref, id) async => false),
      conversationsProvider.overrideWith((ref) async => [_conv(_offerChat)]),
      unreadCountsProvider.overrideWith((ref) async => {'c1': 2}),
      conversationProvider.overrideWith((ref, id) async => _conv(_offerChat)),
      messagesProvider.overrideWith((ref, id) => Stream.value(_msgs())),
      hasReviewedProvider.overrideWith((ref, id) async => false),
    ];

Future<void> _shot(
  WidgetTester tester,
  String name,
  Widget screen, {
  required String lang,
  int? nav,
  List<Override> extra = const [],
}) async {
  SharedPreferences.setMockInitialValues({'locale': lang});
  final prefs = await SharedPreferences.getInstance();
  tester.view.physicalSize = _size * 2;
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);

  Widget body = screen;
  if (nav != null) {
    body = Scaffold(
      body: SafeArea(bottom: false, child: screen),
      bottomNavigationBar: AppBottomNav(index: nav, onTap: (_) {}, messagesBadge: 3),
    );
  }

  await tester.runAsync(() async {
    final ctx = (await _precache());
    return ctx;
  });
  await tester.pumpWidget(ProviderScope(
    overrides: [..._overrides(prefs, lang: lang), ...extra],
    child: MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      locale: Locale(lang),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: GoRouter(routes: [GoRoute(path: '/', builder: (_, _) => body)]),
    ),
  ));
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 150));
  }
  await expectLater(find.byType(MaterialApp), matchesGoldenFile('out/${name}_$lang.png'));
}

Future<void> _precache() async {
  // Decode the logo for real (outside fake async) so it shows in the PNG.
  final data = await rootBundle.load('assets/images/logo.png');
  final codec = await instantiateImageCodec(data.buffer.asUint8List());
  await codec.getNextFrame();
}

void main() {
  // Opt-in: PREVIEW=1 flutter test test/preview --update-goldens
  if (Platform.environment['PREVIEW'] != '1') {
    test('screen previews (set PREVIEW=1 to render)', () {}, skip: true);
    return;
  }
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    // Real Cairo weights.
    for (final w in [300, 400, 500, 600, 700, 800]) {
      GoogleFonts.cairo(fontWeight: FontWeight.values[(w ~/ 100) - 1]);
    }
    await GoogleFonts.pendingFonts();
    // Material icons (flutter_test does not load them by default).
    final flutterRoot = Platform.environment['FLUTTER_ROOT'] ?? '';
    final icons = File('$flutterRoot/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf');
    if (icons.existsSync()) {
      final loader = FontLoader('MaterialIcons')
        ..addFont(Future.value(ByteData.sublistView(icons.readAsBytesSync())));
      await loader.load();
    }
  });

  for (final lang in ['ar', 'en']) {
    group(lang, () {
      testWidgets('splash', (t) => _shot(t, 'splash', const SplashScreen(), lang: lang));
      testWidgets('login', (t) => _shot(t, 'login', const LoginScreen(), lang: lang));
      testWidgets('signup', (t) => _shot(t, 'signup', const SignupScreen(), lang: lang));
      testWidgets('forgot', (t) => _shot(t, 'forgot', const ForgotPasswordScreen(), lang: lang));
      testWidgets('home', (t) => _shot(t, 'home', const HomeScreen(), lang: lang, nav: 0));
      testWidgets('search', (t) => _shot(t, 'search', const SearchScreen(), lang: lang));
      testWidgets('details',
          (t) => _shot(t, 'details', const ProductDetailsScreen(productId: '1'), lang: lang));
      testWidgets('offer',
          (t) => _shot(t, 'offer', const MakeOfferScreen(productId: '1'), lang: lang));
      testWidgets('add', (t) => _shot(t, 'add', const ProductFormScreen(), lang: lang, nav: 2));
      testWidgets('favorites',
          (t) => _shot(t, 'favorites', const FavoritesScreen(), lang: lang, nav: 1));
      testWidgets('messages',
          (t) => _shot(t, 'messages', const MessagesScreen(), lang: lang, nav: 3));
      testWidgets('chat',
          (t) => _shot(t, 'chat', const ChatScreen(conversationId: 'c1'), lang: lang));
      testWidgets('profile',
          (t) => _shot(t, 'profile', const MyProfileScreen(), lang: lang, nav: 4));
      testWidgets('public',
          (t) => _shot(t, 'public', const PublicProfileScreen(userId: 'owner'), lang: lang));
      testWidgets('settings', (t) => _shot(t, 'settings', const SettingsScreen(), lang: lang));
      testWidgets('edit_profile',
          (t) => _shot(t, 'edit_profile', const EditProfileScreen(), lang: lang));
    });
  }
}
