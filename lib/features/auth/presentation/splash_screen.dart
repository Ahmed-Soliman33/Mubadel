import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/locale/locale_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/l10n_labels.dart';
import '../data/auth_repository.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _boot());
  }

  Future<void> _boot() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.enforceRememberMe();
    if (!mounted) return;
    if (repo.session != null) {
      context.go(AppRoutes.home);
    } else {
      setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final isAr = context.lang == 'ar';
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: Stack(
        children: [
          // Logo area
          Positioned.fill(
            bottom: size.height * 0.42,
            child: Center(
              child: Image.asset('assets/images/logo.png',
                  width: size.width * 0.72, fit: BoxFit.contain),
            ),
          ),
          // Green curved bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: size.height * 0.5,
            child: ClipPath(
              clipper: _ArcClipper(),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: AlignmentDirectional.topStart,
                    end: AlignmentDirectional.bottomEnd,
                    colors: [
                      AppColors.forestGreen,
                      AppColors.forestGreen,
                      AppColors.splashGreenEnd,
                    ],
                    stops: [0, 0.45, 1],
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        l.appName,
                        style: TextStyle(
                          fontSize: isAr ? 64 : 52,
                          fontWeight: FontWeight.w800,
                          color: AppColors.citrus,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        l.tagline,
                        style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w300,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          l.slogan,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: size.width * 0.45,
                        height: 52,
                        child: Material(
                          color: const Color(0xFFE6E8E7),
                          elevation: 3,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: _checking
                                ? null
                                : () => context.go(AppRoutes.login),
                            child: Center(
                              child: Text(l.start,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.deepPine)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Language toggle (top, start side — as in the design)
          PositionedDirectional(
            top: 0,
            start: 20,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _LangToggle(
                  isArabic: isAr,
                  onTap: () => ref.read(localeProvider.notifier).toggle(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const arc = 44.0;
    return Path()
      ..moveTo(0, arc)
      ..quadraticBezierTo(size.width / 2, -arc, size.width, arc)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _LangToggle extends StatelessWidget {
  const _LangToggle({required this.isArabic, required this.onTap});
  final bool isArabic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Widget seg(String t, bool active) => Container(
          width: 46,
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? AppColors.softMint : Colors.transparent,
            shape: BoxShape.circle,
            border: active
                ? Border.all(color: Colors.white.withValues(alpha: 0.9), width: 2)
                : null,
          ),
          child: Text(t,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: active ? AppColors.forestGreen : Colors.white)),
        );
    return GestureDetector(
      onTap: onTap,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: AppColors.forestGreen,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [seg('ع', isArabic), seg('en', !isArabic)],
          ),
        ),
      ),
    );
  }
}
