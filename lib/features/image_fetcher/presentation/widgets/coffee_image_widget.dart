import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/features/image_fetcher/presentation/bloc/image_fetcher_bloc.dart';
import 'package:very_good_coffee/features/image_fetcher/presentation/bloc/image_fetcher_event.dart';
import 'package:very_good_coffee/features/image_fetcher/presentation/bloc/image_fetcher_state.dart';
import 'package:very_good_coffee/i18n/strings.g.dart';
import 'package:very_good_coffee/shared/domain/models/coffee_image.dart';

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
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: BlocBuilder<ImageFetcherBloc, ImageFetcherState>(
              builder: (context, state) {
                return Card(
                  child: SizedBox(
                    width: double.infinity,
                    child: _buildImageContent(context, state),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildImageContent(BuildContext context, ImageFetcherState state) {
    if (state is ImageFetcherInitial) {
      return _buildInitialState(context);
    } else if (state is ImageFetcherLoading) {
      return _buildLoadingState();
    } else if (state is ImageFetcherSuccess) {
      return _buildImageState(state.image);
    } else if (state is ImageFetcherError) {
      return _buildErrorState(context, state.message);
    } else {
      return _buildInitialState(context);
    }
  }

  Widget _buildInitialState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.coffee,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            t.main.welcome,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            t.main.instruction,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
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
          Text(t.main.loading),
        ],
      ),
    );
  }

  Widget _buildImageState(CoffeeImage image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
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
            t.main.error.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return BlocBuilder<ImageFetcherBloc, ImageFetcherState>(
      builder: (context, fetcherState) {
        return Wrap(
          spacing: 12,
          runSpacing: 8,
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
                        width: 16,
                        height: 16,
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
