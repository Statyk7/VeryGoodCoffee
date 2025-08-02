import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_coffee/app/config/constants.dart';
import 'package:very_good_coffee/app/di/service_locator.dart';
import 'package:very_good_coffee/features/image_fetcher/presentation/bloc/image_fetcher_bloc.dart';
import 'package:very_good_coffee/features/image_fetcher/presentation/bloc/image_fetcher_event.dart';
import 'package:very_good_coffee/features/image_fetcher/presentation/widgets/coffee_image_widget.dart';
import 'package:very_good_coffee/features/image_gallery/presentation/bloc/image_gallery_bloc.dart';
import 'package:very_good_coffee/i18n/strings.g.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ImageFetcherBloc(sl())..add(FetchNewImageRequested()),
        ),
        BlocProvider(
          create: (context) => ImageGalleryBloc(sl()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(t.main.title),
          actions: [
            IconButton(
              onPressed: () => context.push('/gallery'),
              icon: const Icon(Icons.photo_library),
              tooltip: t.main.galleryButton,
            ),
          ],
        ),
        body: const CoffeeImageWidget(),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          child: Text(
            '${t.app.versionPrefix} ${AppConstants.appVersion}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
