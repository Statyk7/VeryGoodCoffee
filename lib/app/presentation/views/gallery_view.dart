import 'package:flutter/material.dart';
import 'package:very_good_coffee/features/image_gallery/presentation/views/image_gallery_view.dart';
import 'package:very_good_coffee/i18n/strings.g.dart';

class GalleryView extends StatelessWidget {
  const GalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.gallery.title),
      ),
      body: const ImageGalleryView(),
    );
  }
}
