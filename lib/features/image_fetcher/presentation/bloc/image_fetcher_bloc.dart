import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/features/image_fetcher/presentation/bloc/image_fetcher_event.dart';
import 'package:very_good_coffee/features/image_fetcher/presentation/bloc/image_fetcher_state.dart';
import 'package:very_good_coffee/features/image_fetcher/service/image_fetcher_service.dart';
import 'package:very_good_coffee/i18n/strings.g.dart';
import 'package:very_good_coffee/shared/logging/app_logger.dart';

class ImageFetcherBloc extends Bloc<ImageFetcherEvent, ImageFetcherState> {
  ImageFetcherBloc(this._imageFetcherService) : super(ImageFetcherInitial()) {
    on<FetchNewImageRequested>(_onFetchNewImageRequested);
  }

  final ImageFetcherService _imageFetcherService;

  Future<void> _onFetchNewImageRequested(
    FetchNewImageRequested event,
    Emitter<ImageFetcherState> emit,
  ) async {
    emit(ImageFetcherLoading());
    
    try {
      AppLogger.info('Fetching new coffee image');
      final image = await _imageFetcherService.getNewRandomImage();
      emit(ImageFetcherSuccess(image));
      AppLogger.info('Successfully fetched new coffee image');
    } catch (e) {
      AppLogger.error('Failed to fetch coffee image', e);
      emit(ImageFetcherError(t.main.error.failedToLoad));
    }
  }
}