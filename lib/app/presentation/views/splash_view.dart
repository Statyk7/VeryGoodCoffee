import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_coffee/app/config/constants.dart';
import 'package:very_good_coffee/i18n/strings.g.dart';
import 'package:very_good_coffee/shared/theme/ui_constants.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _navigateToMain();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: const Duration(
        milliseconds: UIConstants.splashAnimationDuration,
      ),
      vsync: this,
    );

    _fadeAnimation =
        Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeIn,
          ),
        );

    _animationController.forward();
  }

  void _navigateToMain() {
    Future.delayed(
      const Duration(seconds: AppConstants.splashDurationSeconds),
      () {
        if (mounted) {
          context.go('/main');
        }
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.coffee,
                size: UIConstants.iconGalleryAdd,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              const SizedBox(height: UIConstants.spacing24),
              Text(
                t.splash.title,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: UIConstants.spacing8),
              Text(
                t.splash.subtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color:
                      Theme.of(
                        context,
                      ).colorScheme.onPrimary.withValues(
                        alpha: UIConstants.opacityHeavy,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
