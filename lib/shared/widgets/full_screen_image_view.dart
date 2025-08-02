import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:very_good_coffee/i18n/strings.g.dart';
import 'package:very_good_coffee/shared/domain/models/coffee_image.dart';

class FullScreenImageView extends StatefulWidget {
  const FullScreenImageView({
    required this.image,
    required this.onClose,
    super.key,
  });

  /// The image to be displayed.
  final CoffeeImage image;

  /// The callback that is called when the view is closed.
  final VoidCallback onClose;

  @override
  State<FullScreenImageView> createState() => _FullScreenImageViewState();
}

class _FullScreenImageViewState extends State<FullScreenImageView> {
  bool _showAppBar = true;
  final TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    // Hide system UI for immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    // Restore system UI when leaving
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _transformationController.dispose();
    super.dispose();
  }

  void _toggleAppBarVisibility() {
    setState(() {
      _showAppBar = !_showAppBar;
    });
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: _showAppBar
          ? AppBar(
              backgroundColor: Colors.black54,
              elevation: 0,
              leading: IconButton(
                onPressed: () => widget.onClose(),
                icon: const Icon(Icons.close, color: Colors.white),
                tooltip: t.common.cancel,
              ),
              title: Text(
                t.fullScreen.title,
                style: const TextStyle(color: Colors.white),
              ),
              actions: [
                if (widget.image.savedAt != null)
                  IconButton(
                    onPressed: () => _showImageInfo(context),
                    icon: const Icon(Icons.info_outline, color: Colors.white),
                    tooltip: t.fullScreen.imageInfo,
                  ),
                IconButton(
                  onPressed: _resetZoom,
                  icon: const Icon(Icons.zoom_out_map, color: Colors.white),
                  tooltip: t.fullScreen.resetZoom,
                ),
              ],
            )
          : null,
      body: GestureDetector(
        onTap: _toggleAppBarVisibility,
        child: Center(
          child: Hero(
            tag: 'coffee_image_${widget.image.id ?? widget.image.hashCode}',
            child: InteractiveViewer(
              transformationController: _transformationController,
              minScale: 0.5,
              maxScale: 4,
              onInteractionStart: (_) {
                _hideAppBarTemporarily();
              },
              onInteractionEnd: (_) {
                HapticFeedback.selectionClick();
              },
              child: Image.memory(
                widget.image.bytes,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.grey[900],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.broken_image,
                          size: 64,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          t.fullScreen.imageLoadError,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _hideAppBarTemporarily() {
    if (_showAppBar) {
      setState(() {
        _showAppBar = false;
      });
      // Auto-show app bar after a delay during interaction
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && !_showAppBar) {
          setState(() {
            _showAppBar = true;
          });
        }
      });
    }
  }

  void _showImageInfo(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.fullScreen.imageInfoDialog.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.image.savedAt != null) ...[
              Text(
                '${t.fullScreen.imageInfoDialog.savedAt}: '
                '${_formatDate(widget.image.savedAt!)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
            ],
            Text(
              '${t.fullScreen.imageInfoDialog.source}: '
              '${widget.image.sourceUrl}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(t.common.cancel),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
