import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/features/image_fetcher/presentation/bloc/image_fetcher_bloc.dart';
import 'package:very_good_coffee/features/image_fetcher/presentation/bloc/image_fetcher_event.dart';
import 'package:very_good_coffee/features/image_fetcher/presentation/bloc/image_fetcher_state.dart';
import 'package:very_good_coffee/i18n/strings.g.dart';
import 'package:very_good_coffee/shared/domain/models/coffee_image.dart';
import 'package:very_good_coffee/shared/theme/ui_constants.dart';

class CoffeeImageWidget extends StatelessWidget {
  const CoffeeImageWidget({
    super.key,
    this.onSaveImage,
    this.isSaving = false,
  });

  final void Function(CoffeeImage image)? onSaveImage;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(UIConstants.spacing16),
      child: Column(
        children: [
          Expanded(
            child: BlocBuilder<ImageFetcherBloc, ImageFetcherState>(
              builder: (context, state) {
                return Card(
                  child: SizedBox(
                    width: double.infinity,
                    child: _ImageContent(state: state),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: UIConstants.spacing16),
          _ActionButtons(
            onSaveImage: onSaveImage,
            isSaving: isSaving,
          ),
        ],
      ),
    );
  }
}

// Private widget classes for better organization
class _ImageContent extends StatelessWidget {
  const _ImageContent({required this.state});

  final ImageFetcherState state;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      ImageFetcherInitial() => const _InitialState(),
      ImageFetcherLoading() => const _LoadingState(),
      ImageFetcherSuccess(image: final image) => _ImageState(image: image),
      ImageFetcherError(message: final message) => _ErrorState(
        message: message,
      ),
      _ => const _InitialState(),
    };
  }
}

class _InitialState extends StatelessWidget {
  const _InitialState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.coffee,
            size: UIConstants.iconSplash,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: UIConstants.spacing16),
          Text(
            t.main.welcome,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: UIConstants.spacing8),
          Text(
            t.main.instruction,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

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
          Text(t.main.loading),
        ],
      ),
    );
  }
}

class _ImageState extends StatelessWidget {
  const _ImageState({required this.image});

  final CoffeeImage image;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(UIConstants.radiusLarge),
      child: Image.memory(
        image.bytes,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Text(t.main.error.failedToLoad),
          );
        },
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
            t.main.error.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: UIConstants.spacing8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.onSaveImage,
    required this.isSaving,
  });

  final void Function(CoffeeImage image)? onSaveImage;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageFetcherBloc, ImageFetcherState>(
      builder: (context, fetcherState) {
        return Wrap(
          spacing: UIConstants.spacing12,
          runSpacing: UIConstants.spacing8,
          alignment: WrapAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: fetcherState is ImageFetcherLoading
                  ? null
                  : () => context.read<ImageFetcherBloc>().add(
                      FetchNewImageRequested(),
                    ),
              icon: const Icon(Icons.refresh),
              label: Text(t.main.newCoffeeButton),
            ),
            if (fetcherState is ImageFetcherSuccess && onSaveImage != null)
              ElevatedButton.icon(
                onPressed: isSaving
                    ? null
                    : () => onSaveImage!(fetcherState.image),
                icon: isSaving
                    ? const SizedBox(
                        width: UIConstants.spacing16,
                        height: UIConstants.spacing16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.favorite),
                label: Text(t.main.saveButton),
              ),
          ],
        );
      },
    );
  }
}
