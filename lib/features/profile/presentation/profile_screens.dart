import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/supabase/supabase_provider.dart';
import 'profile_view.dart';

/// "حسابي" tab.
class MyProfileScreen extends ConsumerWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(currentUserIdProvider);
    if (uid == null) return const SizedBox.shrink();
    return ProfileView(key: ValueKey(uid), userId: uid, isMine: true);
  }
}

/// `/user/:id`
class PublicProfileScreen extends StatelessWidget {
  const PublicProfileScreen({super.key, required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(child: ProfileView(userId: userId, isMine: false)),
      );
}
