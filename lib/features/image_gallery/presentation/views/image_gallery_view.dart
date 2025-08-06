import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/app/di/service_locator.dart';
import 'package:very_good_coffee/features/image_gallery/presentation/bloc/image_gallery_bloc.dart';
import 'package:very_good_coffee/features/image_gallery/presentation/bloc/image_gallery_event.dart';
import 'package:very_good_coffee/features/image_gallery/presentation/bloc/image_gallery_state.dart';
import 'package:very_good_coffee/features/image_gallery/presentation/widgets/gallery_grid.dart';
import 'package:very_good_coffee/i18n/strings.g.dart';
import 'package:very_good_coffee/shared/theme/ui_constants.dart';

class ImageGalleryView extends StatelessWidget {
  const ImageGalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ImageGalleryBloc(sl())..add(LoadGalleryImagesRequested()),
      child: BlocConsumer<ImageGalleryBloc, ImageGalleryState>(
        listener: (context, state) {
          if (state is ImageGalleryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return switch (state) {
            ImageGalleryInitial() ||
            ImageGalleryLoading() ||
            ImageSaving() => const _LoadingState(),
            ImageGalleryLoaded() => GalleryGrid(images: state.images),
            ImageSaved() => const GalleryGrid(images: []),
            ImageGalleryError() => _ErrorState(message: state.message),
            ImageSaveError() => _ErrorState(message: state.message),
            _ => const GalleryGrid(images: []),
          };
        },
      ),
    );
  }
}

// Private widget classes for better organization
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: UIConstants.spacing16),
          Text(t.gallery.loading),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: UIConstants.iconSplash,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: UIConstants.spacing16),
          Text(
            t.gallery.error.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: UIConstants.spacing8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: UIConstants.spacing16),
          ElevatedButton(
            onPressed: () => context.read<ImageGalleryBloc>().add(
              LoadGalleryImagesRequested(),
            ),
            child: Text(t.gallery.error.retry),
          ),
        ],
      ),
    );
  }
}
