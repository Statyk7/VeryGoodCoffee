import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:very_good_coffee/app/presentation/views/gallery_view.dart';
import 'package:very_good_coffee/app/presentation/views/main_view.dart';
import 'package:very_good_coffee/app/presentation/views/splash_view.dart';
import 'package:very_good_coffee/shared/domain/models/coffee_image.dart';
import 'package:very_good_coffee/shared/logging/app_logger.dart';
import 'package:very_good_coffee/shared/widgets/full_screen_image_view.dart';

/// Definitions of Routes used by the app, using GoRouter
final appRouter = GoRouter(
  initialLocation: '/splash',
  observers: [
    // GoRouter logging with Talker
    TalkerRouteObserver(AppLogger.instance),
  ],
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) => const MainView(),
    ),
    GoRoute(
      path: '/gallery',
      builder: (context, state) => const GalleryView(),
    ),
    GoRoute(
      path: '/full_screen_image',
      builder: (context, state) {
        final image = state.extra! as CoffeeImage;
        return FullScreenImageView(
          image: image,
          onClose: () => context.pop(),
        );
      },
    ),
  ],
);
