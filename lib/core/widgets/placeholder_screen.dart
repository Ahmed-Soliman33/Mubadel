import 'package:flutter/material.dart';

import '../theme/app_text.dart';

/// Temporary screen used until the feature is implemented.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen(this.name, {super.key});
  final String name;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(child: Center(child: Text(name, style: AppText.sectionTitle))),
      );
}
