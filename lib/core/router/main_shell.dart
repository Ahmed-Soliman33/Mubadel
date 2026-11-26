import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/chat/data/unread_badge_provider.dart';
import '../widgets/app_bottom_nav.dart';
import 'app_router.dart';

const _tabs = [
  AppRoutes.home,
  AppRoutes.favorites,
  AppRoutes.add,
  AppRoutes.messages,
  AppRoutes.profile,
];

class MainShell extends ConsumerWidget {
  const MainShell({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = _tabs.indexWhere((t) => location.startsWith(t));
    return Scaffold(
      body: SafeArea(bottom: false, child: child),
      bottomNavigationBar: AppBottomNav(
        index: index < 0 ? 0 : index,
        messagesBadge: ref.watch(messagesBadgeProvider),
        onTap: (i) => context.go(_tabs[i]),
      ),
    );
  }
}
