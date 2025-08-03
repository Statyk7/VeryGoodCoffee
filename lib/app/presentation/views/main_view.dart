import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_coffee/app/config/constants.dart';
import 'package:very_good_coffee/app/di/service_locator.dart';
import 'package:very_good_coffee/features/image_fetcher/presentation/bloc/image_fetcher_bloc.dart';
import 'package:very_good_coffee/features/image_fetcher/presentation/bloc/image_fetcher_event.dart';
import 'package:very_good_coffee/features/image_fetcher/presentation/widgets/coffee_image_widget.dart';
import 'package:very_good_coffee/features/image_gallery/presentation/bloc/image_gallery_bloc.dart';
import 'package:very_good_coffee/features/image_gallery/presentation/bloc/image_gallery_event.dart';
import 'package:very_good_coffee/features/image_gallery/presentation/bloc/image_gallery_state.dart';
import 'package:very_good_coffee/i18n/strings.g.dart';
import 'package:very_good_coffee/shared/domain/models/coffee_image.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ImageFetcherBloc(sl())..add(FetchNewImageRequested()),
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
        body: BlocListener<ImageGalleryBloc, ImageGalleryState>(
          listener: (context, state) {
            if (state is ImageSaved) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(t.main.success.imageSaved),
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.only(
                    bottom: 100,
                    left: 32,
                    right: 32,
                  ),
                ),
              );
            } else if (state is ImageSaveError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Theme.of(context).colorScheme.error,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.only(
                    bottom: 100,
                    left: 32,
                    right: 32,
                  ),
                ),
              );
            }
          },
          child: BlocBuilder<ImageGalleryBloc, ImageGalleryState>(
            builder: (context, galleryState) {
              return CoffeeImageWidget(
                onSaveImage: (CoffeeImage image) {
                  context.read<ImageGalleryBloc>().add(
                    SaveImageRequested(image),
                  );
                },
                isSaving: galleryState is ImageSaving,
              );
            },
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          child: Text(
            '${t.app.versionPrefix} ${AppConstants.appVersion}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
