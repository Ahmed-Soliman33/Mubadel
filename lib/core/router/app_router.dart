import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/favorites/presentation/favorites_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/products/presentation/product_details_screen.dart';
import '../../features/products/presentation/product_form_screen.dart';
import '../../features/products/presentation/search_screen.dart';
import '../../features/chat/presentation/messages_screen.dart';
import '../../features/offers/presentation/make_offer_screen.dart';
import '../../features/chat/presentation/chat_screen.dart';
import '../widgets/placeholder_screen.dart';
import 'main_shell.dart';

class AppRoutes {
  const AppRoutes._();
  static const splash = '/splash';
  static const login = '/login';
  static const signup = '/signup';
  static const forgot = '/forgot-password';
  static const home = '/home';
  static const favorites = '/favorites';
  static const add = '/add';
  static const messages = '/messages';
  static const profile = '/profile';
  static const search = '/search';
  static const settings = '/settings';
  static const editProfile = '/settings/edit-profile';
  static String product(String id) => '/product/$id';
  static String productEdit(String id) => '/product/$id/edit';
  static String productOffer(String id) => '/product/$id/offer';
  static String user(String id) => '/user/$id';
  static String chat(String id) => '/chat/$id';
}

const _publicRoutes = {
  AppRoutes.splash,
  AppRoutes.login,
  AppRoutes.signup,
  AppRoutes.forgot,
};

/// Re-evaluates the router redirect whenever the auth state changes.
class _AuthRefresh extends ChangeNotifier {
  _AuthRefresh(Stream<AuthState> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }
  late final StreamSubscription<AuthState> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final auth = Supabase.instance.client.auth;
  final refresh = _AuthRefresh(auth.onAuthStateChange);
  ref.onDispose(refresh.dispose);

  final router = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refresh,
    redirect: (context, state) {
      final loggedIn = auth.currentSession != null;
      final loc = state.matchedLocation;
      if (!loggedIn && !_publicRoutes.contains(loc)) return AppRoutes.login;
      // Signed-in users never sit on login/signup (splash decides itself).
      if (loggedIn && (loc == AppRoutes.login || loc == AppRoutes.signup)) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      GoRoute(
          path: AppRoutes.splash,
          builder: (_, _) => const SplashScreen()),
      GoRoute(
          path: AppRoutes.login,
          builder: (_, _) => const LoginScreen()),
      GoRoute(
          path: AppRoutes.signup,
          builder: (_, _) => const SignupScreen()),
      GoRoute(
          path: AppRoutes.forgot,
          builder: (_, _) => const ForgotPasswordScreen()),
      ShellRoute(
        builder: (context, state, child) =>
            MainShell(location: state.matchedLocation, child: child),
        routes: [
          GoRoute(
              path: AppRoutes.home,
              pageBuilder: (_, _) => const NoTransitionPage(child: HomeScreen())),
          GoRoute(
              path: AppRoutes.favorites,
              pageBuilder: (_, _) => const NoTransitionPage(child: FavoritesScreen())),
          GoRoute(
              path: AppRoutes.add,
              pageBuilder: (_, _) =>
                  const NoTransitionPage(child: ProductFormScreen())),
          GoRoute(
              path: AppRoutes.messages,
              pageBuilder: (_, _) => const NoTransitionPage(child: MessagesScreen())),
          GoRoute(
              path: AppRoutes.profile,
              pageBuilder: (_, _) => const NoTransitionPage(
                  child: PlaceholderScreen('profile'))),
        ],
      ),
      GoRoute(
        path: '/product/:id',
        builder: (_, s) =>
            ProductDetailsScreen(productId: s.pathParameters['id']!),
        routes: [
          GoRoute(
              path: 'edit',
              builder: (_, s) =>
                  ProductEditScreen(productId: s.pathParameters['id']!)),
          GoRoute(
              path: 'offer',
              builder: (_, s) =>
                  MakeOfferScreen(productId: s.pathParameters['id']!)),
        ],
      ),
      GoRoute(
          path: AppRoutes.search,
          builder: (_, s) => SearchScreen(
              categoryId: int.tryParse(s.uri.queryParameters['category'] ?? ''))),
      GoRoute(
          path: '/user/:id',
          builder: (_, s) => PlaceholderScreen('user')),
      GoRoute(
          path: '/chat/:id',
          builder: (_, s) =>
              ChatScreen(conversationId: s.pathParameters['id']!)),
      GoRoute(
        path: AppRoutes.settings,
        builder: (_, _) => const PlaceholderScreen('settings'),
        routes: [
          GoRoute(
              path: 'edit-profile',
              builder: (_, _) => const PlaceholderScreen('edit profile')),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
