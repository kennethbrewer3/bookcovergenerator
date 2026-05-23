import 'package:book_cover_designer_flutter/screens/home/home_viewmodel.dart';
import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

class EbookCoverImage extends ViewModelWidget<HomeViewModel> {
  const EbookCoverImage({super.key});

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    if (viewModel.isBusy) {
      return const Center(child: CircularProgressIndicator());
    }

    final cover = viewModel.cover;
    if (cover == null) {
      return const Icon(Icons.image_not_supported);
    }

    final bytes = cover.buffer.asUint8List(
      cover.offsetInBytes,
      cover.lengthInBytes,
    );

    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: constraints.maxWidth,
              maxHeight: constraints.maxHeight,
            ),
            child: AspectRatio(
              aspectRatio: HomeViewModel.coverWidth / HomeViewModel.coverHeight,
              child: Image.memory(
                bytes,
                gaplessPlayback: true,
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }
}
