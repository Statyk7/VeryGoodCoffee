import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/app/di/service_locator.dart';
import 'package:very_good_coffee/features/image_gallery/presentation/bloc/image_gallery_bloc.dart';
import 'package:very_good_coffee/features/image_gallery/presentation/bloc/image_gallery_event.dart';
import 'package:very_good_coffee/features/image_gallery/presentation/bloc/image_gallery_state.dart';
import 'package:very_good_coffee/features/image_gallery/presentation/widgets/gallery_grid.dart';
import 'package:very_good_coffee/i18n/strings.g.dart';

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
            ImageGalleryInitial() || ImageGalleryLoading() => 
              _buildLoadingState(),
            ImageGalleryLoaded() => GalleryGrid(images: state.images),
            ImageGalleryError() => _buildErrorState(context, state.message),
            _ => const GalleryGrid(images: []),
          };
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(t.gallery.loading),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            t.gallery.error.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context
                .read<ImageGalleryBloc>()
                .add(LoadGalleryImagesRequested()),
            child: Text(t.gallery.error.retry),
          ),
        ],
      ),
    );
  }
}