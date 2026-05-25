import 'dart:math';
import 'dart:typed_data';

import 'package:book_cover_designer_flutter/models/ebook_cover_settings.dart';
import 'package:book_cover_designer_flutter/models/enums.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:either_dart/either.dart';
import 'package:flutter/services.dart';
import 'package:file_saver/file_saver.dart';





class GenerateEbookCoverService {
  Future<Either<String, ByteData>> generateImage({
    required EbookCoverSettings settings,
  }) async {
    final sw = Stopwatch()..start();

    try {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, settings.coverWidth, settings.coverHeight));
      final dstRect = Rect.fromLTWH(0, 0, settings.coverWidth, settings.coverHeight);

      ui.Image? bgImage;

      // 1) Paint background
      canvas.drawRect(dstRect, Paint()..color = settings.backgroundColor);

      if (settings.backgroundImageBytes != null && settings.backgroundImageBytes!.isNotEmpty) {
        bgImage = await _decodeToUiImage(settings!.backgroundImageBytes!);

        _drawBackgroundImage(
          canvas: canvas,
          image: bgImage,
          dstRect: dstRect,
          mode: settings.backgroundImageMode,
          alignment: settings.backgroundImageAlignment,
          scaleX: settings.backgroundImageScaleX,
          scaleY: settings.backgroundImageScaleY,
          blendMode: settings.backgroundBlendMode,
          opacity: settings.backgroundImageOpacity,
        );
      }

      // 2) Dynamic contrast detection (image preferred, else fallback color)
      final bgLuminance = bgImage != null
          ? await _estimateImageLuminance(bgImage)
          : _luminanceOfColor(settings.backgroundColor);

      final useDarkText = bgLuminance > 0.55;

      final shadowColor = useDarkText
          ? const Color(0x66000000)
          : const Color(0xAA000000);

      // 3) Border (optional)
      canvas.drawRect(
        dstRect,
        Paint()
          ..color = (useDarkText ? Colors.black : Colors.white).withValues(alpha: 0.20)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );

      if (settings.cornerBadgeText != null && settings.cornerBadgeText!.trim().isNotEmpty) {
        _drawCornerBadge(
          canvas: canvas,
          coverWidth: settings.coverWidth,
          coverHeight: settings.coverHeight,
          text: settings.cornerBadgeText!.trim(),
          position: settings.cornerBadgePosition,
          textColor: settings.cornerBadgeTextColor,
          backgroundColor: settings.cornerBadgeColor,
        );
      }

      _drawOptionalMetadata(
        canvas: canvas,
        coverWidth: settings.coverWidth,
        coverHeight: settings.coverHeight,
        tagline: settings.tagline,
        seriesTitle: settings.seriesTitle,
        editionLine: settings.editionLine,
        taglineTopOffset: settings.taglineTopOffset,
        seriesTitleTopOffset: settings.seriesTitleTopOffset,
        editionLineTopOffset: settings.editionLineTopOffset,
        taglineTextColor: settings.taglineTextColor,
        taglineBoxColor: settings.taglineBoxColor,
        seriesTitleTextColor: settings.seriesTitleTextColor,
        seriesTitleBoxColor: settings.seriesTitleBoxColor,
        editionLineTextColor: settings.editionLineTextColor,
        editionLineBoxColor: settings.editionLineBoxColor,
        shadowColor: shadowColor,
      );

      // 5) Draw typography by selected layout
      switch (settings.layout) {
        case CoverLayout.titleTopAuthorBottom:
          _drawLayoutA(
            canvas: canvas,
            coverWidth: settings.coverWidth,
            coverHeight: settings.coverHeight,
            title: settings.title,
            subtitle: settings.subtitle,
            author: settings.author,
            titleTextColor: settings.titleTextColor,
            subtitleTextColor: settings.subtitleTextColor,
            authorTextColor: settings.authorTextColor,
            titleBoxColor: settings.titleBoxColor,
            authorBoxColor: settings.authorBoxColor,
            subtitleBoxColor: settings.subtitleBoxColor,
            shadowColor: shadowColor,
            topOffset: settings.titleTopAuthorBottomTopOffset,
            titleTopOffset: settings.titleTopOffset,
            authorTopOffset: settings.authorTopOffset,
            subtitleTopOffset: settings.subtitleTopOffset,
          );
          break;

        case CoverLayout.authorTopTitleCenter:
          _drawLayoutB(
            canvas: canvas,
            coverWidth: settings.coverWidth,
            coverHeight: settings.coverHeight,
            title: settings.title,
            subtitle: settings.subtitle,
            author: settings.author,
            titleTextColor: settings.titleTextColor,
            subtitleTextColor: settings.subtitleTextColor,
            authorTextColor: settings.authorTextColor,
            titleBoxColor: settings.titleBoxColor,
            authorBoxColor: settings.authorBoxColor,
            subtitleBoxColor: settings.subtitleBoxColor,
            shadowColor: shadowColor,
            topOffset: settings.authorTopTitleCenterTopOffset,
            titleTopOffset: settings.titleTopOffset,
            authorTopOffset: settings.authorTopOffset,
            subtitleTopOffset: settings.subtitleTopOffset,
          );
          break;

        case CoverLayout.bigCenterTitle:
          _drawLayoutC(
            canvas: canvas,
            coverWidth: settings.coverWidth,
            coverHeight: settings.coverHeight,
            title: settings.title,
            subtitle: settings.subtitle,
            author: settings.author,
            titleTextColor: settings.titleTextColor,
            subtitleTextColor: settings.subtitleTextColor,
            authorTextColor: settings.authorTextColor,
            titleBoxColor: settings.titleBoxColor,
            authorBoxColor: settings.authorBoxColor,
            subtitleBoxColor: settings.subtitleBoxColor,
            shadowColor: shadowColor,
            titleTopOffset: settings.titleTopOffset,
            authorTopOffset: settings.authorTopOffset,
            subtitleTopOffset: settings.subtitleTopOffset,
          );
          break;
      }

      // 6) Export PNG
      final picture = recorder.endRecording();
      final img = await picture.toImage(settings.coverWidth.round(), settings.coverHeight.round());
      final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);

      if (pngBytes == null) return const Left("Failed to generate image");

      sw.stop();
      debugPrint('TOTAL: ${sw.elapsedMilliseconds}ms');
      return Right(pngBytes);
    } catch (e, st) {
      debugPrint('generateImage error: $e\n$st');
      return Left('Failed to generate cover: $e');
    }
  }

  // ----------------------------
  // Layouts (A/B/C)
  // ----------------------------

  void _drawLayoutA({
    required Canvas canvas,
    required double coverWidth,
    required double coverHeight,
    required String title,
    required String? subtitle,
    required String author,
    required Color titleTextColor,
    required Color subtitleTextColor,
    required Color authorTextColor,
    required Color titleBoxColor,
    required Color authorBoxColor,
    required Color subtitleBoxColor,
    required Color shadowColor,
    required double topOffset,
    required double titleTopOffset,
    required double authorTopOffset,
    required double subtitleTopOffset,
  }) {
    final padX = coverWidth * 0.08;
    final maxW = coverWidth - padX * 2;
    final titleBaseY = coverHeight * (0.16 + topOffset);
    final titleTopY = titleBaseY + (coverHeight * titleTopOffset);
    final authorBottomY = coverHeight * (0.86 + authorTopOffset);
    final titlePainter = _fitText(
      text: title.trim(),
      maxWidth: maxW,
      maxLines: 3,
      maxFontSize: coverWidth * 0.14,
      minFontSize: coverWidth * 0.07,
      styleBuilder: (fs) => TextStyle(
        color: titleTextColor,
        fontSize: fs,
        fontWeight: FontWeight.w900,
        height: 1.05,
        letterSpacing: 0.3,
        shadows: [Shadow(blurRadius: 14, offset: const Offset(0, 6), color: shadowColor)],
      ),
      textAlign: TextAlign.center,
    );
    final subtitlePainter = (subtitle != null && subtitle.trim().isNotEmpty)
        ? _fitText(
            text: subtitle.trim(),
            maxWidth: maxW,
            maxLines: 2,
            maxFontSize: coverWidth * 0.06,
            minFontSize: coverWidth * 0.045,
            styleBuilder: (fs) => TextStyle(
              color: subtitleTextColor,
              fontSize: fs,
              fontWeight: FontWeight.w700,
              height: 1.15,
              shadows: [Shadow(blurRadius: 10, offset: const Offset(0, 4), color: shadowColor)],
            ),
            textAlign: TextAlign.center,
          )
        : null;
    final authorPainter = _fitText(
      text: author.trim(),
      maxWidth: maxW,
      maxLines: 3,
      maxFontSize: coverWidth * 0.055,
      minFontSize: coverWidth * 0.032,
      styleBuilder: (fs) => TextStyle(
        color: authorTextColor,
        fontSize: fs,
        fontWeight: FontWeight.w800,
        height: 1.15,
        letterSpacing: 0.8,
        shadows: [Shadow(blurRadius: 10, offset: const Offset(0, 4), color: shadowColor)],
      ),
      textAlign: TextAlign.center,
    );
    _drawScrim(canvas: canvas, x: padX, y: titleTopY - 18, w: maxW, h: titlePainter.height + 36, color: titleBoxColor, radius: 18);
    titlePainter.paint(canvas, Offset((coverWidth - titlePainter.width) / 2, titleTopY));
    if (subtitlePainter != null) {
      final subY = titleBaseY + titlePainter.height + coverHeight * (0.02 + subtitleTopOffset);
      _drawScrim(canvas: canvas, x: padX, y: subY - 14, w: maxW, h: subtitlePainter.height + 28, color: subtitleBoxColor, radius: 18);
      subtitlePainter.paint(canvas, Offset((coverWidth - subtitlePainter.width) / 2, subY));
    }
    _drawScrim(canvas: canvas, x: padX, y: authorBottomY - authorPainter.height - 18, w: maxW, h: authorPainter.height + 36, color: authorBoxColor, radius: 18);
    authorPainter.paint(canvas, Offset((coverWidth - authorPainter.width) / 2, authorBottomY - authorPainter.height));
  }

  void _drawLayoutB({
    required Canvas canvas,
    required double coverWidth,
    required double coverHeight,
    required String title,
    required String? subtitle,
    required String author,
    required Color titleTextColor,
    required Color subtitleTextColor,
    required Color authorTextColor,
    required Color titleBoxColor,
    required Color authorBoxColor,
    required Color subtitleBoxColor,
    required Color shadowColor,
    required double topOffset,
    required double titleTopOffset,
    required double authorTopOffset,
    required double subtitleTopOffset,
  }) {
    final padX = coverWidth * 0.08;
    final maxW = coverWidth - padX * 2;
    final authorTopY = coverHeight * (0.12 + topOffset + authorTopOffset);
    final titleCenterY = coverHeight * 0.42;
    final authorPainter = _fitText(
      text: author.trim(),
      maxWidth: maxW,
      maxLines: 3,
      maxFontSize: coverWidth * 0.055,
      minFontSize: coverWidth * 0.032,
      styleBuilder: (fs) => TextStyle(
        color: authorTextColor,
        fontSize: fs,
        fontWeight: FontWeight.w800,
        height: 1.15,
        letterSpacing: 1.0,
        shadows: [Shadow(blurRadius: 10, offset: const Offset(0, 4), color: shadowColor)],
      ),
      textAlign: TextAlign.center,
    );
    final titlePainter = _fitText(
      text: title.trim(),
      maxWidth: maxW,
      maxLines: 3,
      maxFontSize: coverWidth * 0.16,
      minFontSize: coverWidth * 0.08,
      styleBuilder: (fs) => TextStyle(
        color: titleTextColor,
        fontSize: fs,
        fontWeight: FontWeight.w900,
        height: 1.03,
        letterSpacing: 0.2,
        shadows: [Shadow(blurRadius: 14, offset: const Offset(0, 6), color: shadowColor)],
      ),
      textAlign: TextAlign.center,
    );
    final subtitlePainter = (subtitle != null && subtitle.trim().isNotEmpty)
        ? _fitText(
            text: subtitle.trim(),
            maxWidth: maxW,
            maxLines: 2,
            maxFontSize: coverWidth * 0.065,
            minFontSize: coverWidth * 0.045,
            styleBuilder: (fs) => TextStyle(
              color: subtitleTextColor,
              fontSize: fs,
              fontWeight: FontWeight.w700,
              height: 1.15,
              shadows: [Shadow(blurRadius: 10, offset: const Offset(0, 4), color: shadowColor)],
            ),
            textAlign: TextAlign.center,
          )
        : null;
    _drawScrim(canvas: canvas, x: padX, y: authorTopY - 16, w: maxW, h: authorPainter.height + 32, color: authorBoxColor, radius: 18);
    authorPainter.paint(canvas, Offset((coverWidth - authorPainter.width) / 2, authorTopY));
    final blockH = titlePainter.height + (subtitlePainter != null ? (coverHeight * 0.02 + subtitlePainter.height) : 0);
    final blockTopBaseY = titleCenterY - (blockH / 2);
    final blockTopY = blockTopBaseY + (coverHeight * titleTopOffset);
    _drawScrim(canvas: canvas, x: padX, y: blockTopY - 18, w: maxW, h: titlePainter.height + 36, color: titleBoxColor, radius: 18);
    titlePainter.paint(canvas, Offset((coverWidth - titlePainter.width) / 2, blockTopY));
    if (subtitlePainter != null) {
      final subY = blockTopBaseY + titlePainter.height + coverHeight * (0.02 + subtitleTopOffset);
      _drawScrim(canvas: canvas, x: padX, y: subY - 14, w: maxW, h: subtitlePainter.height + 28, color: subtitleBoxColor, radius: 18);
      subtitlePainter.paint(canvas, Offset((coverWidth - subtitlePainter.width) / 2, subY));
    }
  }

  void _drawLayoutC({
    required Canvas canvas,
    required double coverWidth,
    required double coverHeight,
    required String title,
    required String? subtitle,
    required String author,
    required Color titleTextColor,
    required Color subtitleTextColor,
    required Color authorTextColor,
    required Color titleBoxColor,
    required Color authorBoxColor,
    required Color subtitleBoxColor,
    required Color shadowColor,
    required double titleTopOffset,
    required double authorTopOffset,
    required double subtitleTopOffset,
  }) {
    final padX = coverWidth * 0.08;
    final maxW = coverWidth - padX * 2;
    final centerY = coverHeight * 0.46;
    final titlePainter = _fitText(
      text: title.trim(),
      maxWidth: maxW,
      maxLines: 4,
      maxFontSize: coverWidth * 0.18,
      minFontSize: coverWidth * 0.09,
      styleBuilder: (fs) => TextStyle(
        color: titleTextColor,
        fontSize: fs,
        fontWeight: FontWeight.w900,
        height: 1.02,
        letterSpacing: 0.1,
        shadows: [Shadow(blurRadius: 16, offset: const Offset(0, 7), color: shadowColor)],
      ),
      textAlign: TextAlign.center,
    );
    final subtitlePainter = (subtitle != null && subtitle.trim().isNotEmpty)
        ? _fitText(
            text: subtitle.trim(),
            maxWidth: maxW,
            maxLines: 2,
            maxFontSize: coverWidth * 0.06,
            minFontSize: coverWidth * 0.042,
            styleBuilder: (fs) => TextStyle(
              color: subtitleTextColor,
              fontSize: fs,
              fontWeight: FontWeight.w700,
              height: 1.15,
              shadows: [Shadow(blurRadius: 10, offset: const Offset(0, 4), color: shadowColor)],
            ),
            textAlign: TextAlign.center,
          )
        : null;
    final authorPainter = _fitText(
      text: author.trim(),
      maxWidth: maxW,
      maxLines: 3,
      maxFontSize: coverWidth * 0.05,
      minFontSize: coverWidth * 0.03,
      styleBuilder: (fs) => TextStyle(
        color: authorTextColor,
        fontSize: fs,
        fontWeight: FontWeight.w800,
        height: 1.15,
        letterSpacing: 1.1,
        shadows: [Shadow(blurRadius: 10, offset: const Offset(0, 4), color: shadowColor)],
      ),
      textAlign: TextAlign.center,
    );
    final gap1 = coverHeight * 0.04;
    final gap2 = coverHeight * 0.05;
    final blockH = titlePainter.height + (subtitlePainter != null ? (gap1 + subtitlePainter.height) : 0) + gap2 + authorPainter.height;
    final topY = centerY - blockH / 2;
    final titleY = topY + (coverHeight * titleTopOffset);
    _drawScrim(canvas: canvas, x: padX, y: titleY - 18, w: maxW, h: titlePainter.height + 36, color: titleBoxColor, radius: 18);
    titlePainter.paint(canvas, Offset((coverWidth - titlePainter.width) / 2, titleY));
    double authorY = topY + titlePainter.height;
    if (subtitlePainter != null) {
      final subtitleY = topY + titlePainter.height + gap1 + (coverHeight * subtitleTopOffset);
      _drawScrim(canvas: canvas, x: padX, y: subtitleY - 14, w: maxW, h: subtitlePainter.height + 28, color: subtitleBoxColor, radius: 18);
      subtitlePainter.paint(canvas, Offset((coverWidth - subtitlePainter.width) / 2, subtitleY));
      authorY += gap1 + subtitlePainter.height;
    }
    authorY += gap2 + (coverHeight * authorTopOffset);
    _drawScrim(canvas: canvas, x: padX, y: authorY - 18, w: maxW, h: authorPainter.height + 36, color: authorBoxColor, radius: 18);
    authorPainter.paint(canvas, Offset((coverWidth - authorPainter.width) / 2, authorY));
  }

  // ----------------------------
  // Helpers: banner, scrim, text fitting, bg luminance
  // ----------------------------

  void _drawCornerBadge({
    required Canvas canvas,
    required double coverWidth,
    required double coverHeight,
    required String text,
    required CornerBadgePosition position,
    required Color textColor,
    required Color backgroundColor,
  }) {
    final bannerH = coverHeight * 0.055;
    final bannerW = coverWidth * 0.72;
    final cornerOffset = coverWidth * 0.18;
    final isLeft = position == CornerBadgePosition.topLeft ||
        position == CornerBadgePosition.bottomLeft;
    final isTop = position == CornerBadgePosition.topLeft ||
        position == CornerBadgePosition.topRight;
    final center = Offset(
      isLeft ? cornerOffset : coverWidth - cornerOffset,
      isTop ? cornerOffset : coverHeight - cornerOffset,
    );
    final angle = isLeft == isTop ? -pi / 4 : pi / 4;
    final rect = Rect.fromCenter(
      center: Offset.zero,
      width: bannerW,
      height: bannerH,
    );
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(14));

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    canvas.drawRRect(rrect, Paint()..color = backgroundColor);

    final painter = _fitText(
      text: text,
      maxWidth: bannerW - 24,
      maxLines: 1,
      maxFontSize: bannerH * 0.55,
      minFontSize: bannerH * 0.35,
      styleBuilder: (fs) => TextStyle(
        color: textColor,
        fontSize: fs,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.8,
      ),
      textAlign: TextAlign.center,
    );

    final dx = rect.left + (bannerW - painter.width) / 2;
    final dy = rect.top + (bannerH - painter.height) / 2;
    painter.paint(canvas, Offset(dx, dy));
    canvas.restore();
  }

  void _drawOptionalMetadata({
    required Canvas canvas,
    required double coverWidth,
    required double coverHeight,
    required String? tagline,
    required String? seriesTitle,
    required String? editionLine,
    required double taglineTopOffset,
    required double seriesTitleTopOffset,
    required double editionLineTopOffset,
    required Color taglineTextColor,
    required Color taglineBoxColor,
    required Color seriesTitleTextColor,
    required Color seriesTitleBoxColor,
    required Color editionLineTextColor,
    required Color editionLineBoxColor,
    required Color shadowColor,
  }) {
    final padX = coverWidth * 0.08;
    final maxW = coverWidth - padX * 2;
    final entries = <({
      String text,
      double y,
      double maxFontSize,
      Color textColor,
      Color boxColor,
    })>[
      if (seriesTitle != null && seriesTitle.trim().isNotEmpty)
        (
          text: seriesTitle.trim(),
          y: coverHeight * (0.055 + seriesTitleTopOffset),
          maxFontSize: coverWidth * 0.045,
          textColor: seriesTitleTextColor,
          boxColor: seriesTitleBoxColor,
        ),
      if (tagline != null && tagline.trim().isNotEmpty)
        (
          text: tagline.trim(),
          y: coverHeight * (0.74 + taglineTopOffset),
          maxFontSize: coverWidth * 0.05,
          textColor: taglineTextColor,
          boxColor: taglineBoxColor,
        ),
      if (editionLine != null && editionLine.trim().isNotEmpty)
        (
          text: editionLine.trim(),
          y: coverHeight * (0.915 + editionLineTopOffset),
          maxFontSize: coverWidth * 0.04,
          textColor: editionLineTextColor,
          boxColor: editionLineBoxColor,
        ),
    ];

    for (final entry in entries) {
      final painter = _fitText(
        text: entry.text,
        maxWidth: maxW,
        maxLines: 1,
        maxFontSize: entry.maxFontSize,
        minFontSize: coverWidth * 0.03,
        styleBuilder: (fs) => TextStyle(
          color: entry.textColor,
          fontSize: fs,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.7,
          shadows: [
            Shadow(
              blurRadius: 8,
              offset: const Offset(0, 3),
              color: shadowColor,
            ),
          ],
        ),
        textAlign: TextAlign.center,
      );
      _drawScrim(
        canvas: canvas,
        x: padX,
        y: entry.y - 10,
        w: maxW,
        h: painter.height + 20,
        color: entry.boxColor,
        radius: 14,
      );
      painter.paint(canvas, Offset((coverWidth - painter.width) / 2, entry.y));
    }
  }

  void _drawScrim({
    required Canvas canvas,
    required double x,
    required double y,
    required double w,
    required double h,
    required Color color,
    required double radius,
  }) {
    final rect = Rect.fromLTWH(x, y, w, h);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(radius)),
      Paint()..color = color,
    );
  }

  TextPainter _fitText({
    required String text,
    required double maxWidth,
    required int maxLines,
    required double maxFontSize,
    required double minFontSize,
    required TextStyle Function(double fontSize) styleBuilder,
    TextAlign textAlign = TextAlign.left,
  }) {
    // Binary-search the font size for best fit.
    double lo = minFontSize;
    double hi = maxFontSize;

    TextPainter best = _layoutPainter(text, styleBuilder(lo), maxWidth, maxLines, textAlign);

    for (int i = 0; i < 14; i++) {
      final mid = (lo + hi) / 2;
      final tp = _layoutPainter(text, styleBuilder(mid), maxWidth, maxLines, textAlign);

      final fits = !tp.didExceedMaxLines && tp.width <= maxWidth + 0.001;
      if (fits) {
        best = tp;
        lo = mid;
      } else {
        hi = mid;
      }
    }

    return best;
  }

  TextPainter _layoutPainter(
      String text,
      TextStyle style,
      double maxWidth,
      int maxLines,
      TextAlign textAlign,
      ) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textAlign: textAlign,
      maxLines: maxLines,
      ellipsis: '…',
    )..layout(maxWidth: maxWidth);
    return tp;
  }

  Future<ui.Image> _decodeToUiImage(Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  void _drawBackgroundImage({
    required Canvas canvas,
    required ui.Image image,
    required Rect dstRect,
    required BackgroundImageMode mode,
    required Alignment alignment,
    required double scaleX,
    required double scaleY,
    required BlendMode blendMode,
    required double opacity,
  }) {
    final paint = Paint()
      ..filterQuality = FilterQuality.high
      ..blendMode = blendMode
      ..color = Colors.white.withValues(alpha: opacity.clamp(0, 1).toDouble());

    final safeScaleX = max(0.05, scaleX.abs());
    final safeScaleY = max(0.05, scaleY.abs());
    final srcRect = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());

    Rect alignedRect(Size size) {
      final x = dstRect.left + (dstRect.width - size.width) * ((alignment.x + 1) / 2);
      final y = dstRect.top + (dstRect.height - size.height) * ((alignment.y + 1) / 2);
      return Rect.fromLTWH(x, y, size.width, size.height);
    }

    Size imageSizeForMode() {
      final imageW = image.width.toDouble();
      final imageH = image.height.toDouble();
      switch (mode) {
        case BackgroundImageMode.cover:
          final factor = max(dstRect.width / imageW, dstRect.height / imageH);
          return Size(imageW * factor * safeScaleX, imageH * factor * safeScaleY);
        case BackgroundImageMode.contain:
          final factor = min(dstRect.width / imageW, dstRect.height / imageH);
          return Size(imageW * factor * safeScaleX, imageH * factor * safeScaleY);
        case BackgroundImageMode.stretch:
          return Size(dstRect.width * safeScaleX, dstRect.height * safeScaleY);
        case BackgroundImageMode.center:
        case BackgroundImageMode.tile:
        case BackgroundImageMode.tileX:
        case BackgroundImageMode.tileY:
          return Size(imageW * safeScaleX, imageH * safeScaleY);
      }
    }

    final imageSize = imageSizeForMode();

    if (mode == BackgroundImageMode.tile || mode == BackgroundImageMode.tileX || mode == BackgroundImageMode.tileY) {
      canvas.save();
      canvas.clipRect(dstRect);
      final startRect = alignedRect(imageSize);
      final startX = mode == BackgroundImageMode.tileY ? startRect.left : dstRect.left - imageSize.width;
      final endX = mode == BackgroundImageMode.tileY ? startRect.left : dstRect.right + imageSize.width;
      final startY = mode == BackgroundImageMode.tileX ? startRect.top : dstRect.top - imageSize.height;
      final endY = mode == BackgroundImageMode.tileX ? startRect.top : dstRect.bottom + imageSize.height;

      for (double y = startY; y <= endY; y += imageSize.height) {
        for (double x = startX; x <= endX; x += imageSize.width) {
          canvas.drawImageRect(image, srcRect, Rect.fromLTWH(x, y, imageSize.width, imageSize.height), paint);
          if (mode == BackgroundImageMode.tileY) break;
        }
        if (mode == BackgroundImageMode.tileX) break;
      }
      canvas.restore();
      return;
    }

    canvas.drawImageRect(image, srcRect, alignedRect(imageSize), paint);
  }

  Rect _srcRectForCoverFit({
    required double srcW,
    required double srcH,
    required double dstW,
    required double dstH,
  }) {
    final srcAspect = srcW / srcH;
    final dstAspect = dstW / dstH;

    if (srcAspect > dstAspect) {
      final newSrcW = srcH * dstAspect;
      final x = (srcW - newSrcW) / 2;
      return Rect.fromLTWH(x, 0, newSrcW, srcH);
    } else {
      final newSrcH = srcW / dstAspect;
      final y = (srcH - newSrcH) / 2;
      return Rect.fromLTWH(0, y, srcW, newSrcH);
    }
  }

  // Dynamic contrast: estimate luminance from a small sample grid of pixels.
  Future<double> _estimateImageLuminance(ui.Image image) async {
    // Use raw RGBA to sample quickly
    final bd = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (bd == null) return 0.3; // assume dark-ish if unknown

    final bytes = bd.buffer.asUint8List();
    final w = image.width;
    final h = image.height;

    // Sample a grid (e.g. 12x12) for speed
    const gx = 12;
    const gy = 12;

    double sum = 0;
    int count = 0;

    for (int iy = 0; iy < gy; iy++) {
      final y = ((iy + 0.5) * h / gy).floor().clamp(0, h - 1);
      for (int ix = 0; ix < gx; ix++) {
        final x = ((ix + 0.5) * w / gx).floor().clamp(0, w - 1);
        final idx = (y * w + x) * 4;

        final r = bytes[idx] / 255.0;
        final g = bytes[idx + 1] / 255.0;
        final b = bytes[idx + 2] / 255.0;

        // Relative luminance (sRGB approximate)
        final lum = 0.2126 * r + 0.7152 * g + 0.0722 * b;
        sum += lum;
        count++;
      }
    }

    return count == 0 ? 0.3 : (sum / count);
  }

  double _luminanceOfColor(Color c) {
    // Color.computeLuminance() is fine and stable.
    return c.computeLuminance();
  }

  Color _generateRandomBackgroundColor(Random rd) {
    // Pick a random hue, keep saturation + lightness in aesthetic range.
    final hue = rd.nextDouble() * 360;
    final saturation = 0.45 + rd.nextDouble() * 0.35; // 0.45–0.80
    final lightness = 0.25 + rd.nextDouble() * 0.35;  // 0.25–0.60

    return HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor();
  }

  Future<String?> saveCoverPng({
    required ByteData pngBytes,
    required String fileNameWithoutExtension,
  }) async {
    final bytes = pngBytes.buffer.asUint8List();

    // Returns a path on some platforms; on Web it may return null/unused.
    final result = await FileSaver.instance.saveFile(
      name: fileNameWithoutExtension,
      bytes: bytes,
      fileExtension: 'png',
      mimeType: MimeType.png,
    );

    return result;
  }

}
