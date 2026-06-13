import 'dart:math';
import 'dart:typed_data';

import 'package:book_cover_designer_flutter/app/app_services.dart';
import 'package:book_cover_designer_flutter/app/logging/logger.dart';
import 'package:book_cover_designer_flutter/models/ebook_cover_settings.dart';
import 'package:book_cover_designer_flutter/models/enums.dart';
import 'package:either_dart/either.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui' as ui;

class GenerateEbookCoverService {
  final _log = getLogger('GenerateEbookCoverService');

  Future<void> _preloadFonts() async {
    GoogleFonts.roboto();
    GoogleFonts.merriweather();
    GoogleFonts.robotoMono();
    GoogleFonts.ibarraRealNova();
    GoogleFonts.squarePeg();
    GoogleFonts.nunito();
    GoogleFonts.pacifico();
    try {
      await GoogleFonts.pendingFonts();
      await customFontService.preloadAll();
    } catch (_) {}
  }

  TextStyle? _resolveFontStyle(String fontKey, TextStyle base) {
    final builtIn = _googleFontStyle(fontKey, base);
    if (builtIn != null) return builtIn;
    if (customFontService.isCustomFontKey(fontKey)) {
      return base.copyWith(fontFamily: fontKey);
    }
    return null;
  }

  TextStyle? _googleFontStyle(String fontKey, TextStyle base) {
    return switch (fontKey) {
      'sans-serif' => GoogleFonts.roboto(textStyle: base),
      'serif' => GoogleFonts.merriweather(textStyle: base),
      'monospace' => GoogleFonts.robotoMono(textStyle: base),
      'ibarra-real-nova' => GoogleFonts.ibarraRealNova(textStyle: base),
      'square-peg' => GoogleFonts.squarePeg(textStyle: base),
      'nunito' => GoogleFonts.nunito(textStyle: base),
      'pacifico' => GoogleFonts.pacifico(textStyle: base),
      'roboto-mono' => GoogleFonts.robotoMono(textStyle: base),
      _ => null,
    };
  }

  Future<Either<String, ByteData>> generateImage({
    required EbookCoverSettings settings,
  }) async {
    final sw = Stopwatch()..start();

    try {
      await _preloadFonts();
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(
        recorder,
        Rect.fromLTWH(0, 0, settings.coverWidth, settings.coverHeight),
      );
      final dstRect = Rect.fromLTWH(
        0,
        0,
        settings.coverWidth,
        settings.coverHeight,
      );

      ui.Image? bgImage;

      canvas.drawRect(dstRect, Paint()..color = settings.backgroundColor);

      if (settings.backgroundImageBytes != null &&
          settings.backgroundImageBytes!.isNotEmpty) {
        bgImage = await _decodeToUiImage(settings.backgroundImageBytes!);

        _drawBackgroundImage(
          canvas: canvas,
          settings: settings,
          image: bgImage,
          dstRect: dstRect,
        );
      }

      final bgLuminance = bgImage != null
          ? await _estimateImageLuminance(bgImage)
          : _luminanceOfColor(settings.backgroundColor);

      final useDarkText = bgLuminance > 0.55;

      final shadowColor = useDarkText
          ? const Color(0x66000000)
          : const Color(0xAA000000);

      canvas.drawRect(
        dstRect,
        Paint()
          ..color = (useDarkText ? Colors.black : Colors.white)
              .withValues(alpha: 0.20)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );

      if (settings.cornerBadgeText != null &&
          settings.cornerBadgeText!.trim().isNotEmpty) {
        _drawCornerBadge(
          canvas: canvas,
          settings: settings,
        );
      }

      _drawOptionalMetadata(
        canvas: canvas,
        settings: settings,
        shadowColor: shadowColor,
      );

      switch (settings.layout) {
        case CoverLayout.titleTopAuthorBottom:
          _drawLayoutA(
            canvas: canvas,
            settings: settings,
            shadowColor: shadowColor,
          );
          break;

        case CoverLayout.authorTopTitleCenter:
          _drawLayoutB(
            canvas: canvas,
            settings: settings,
            shadowColor: shadowColor,
          );
          break;

        case CoverLayout.bigCenterTitle:
          _drawLayoutC(
            canvas: canvas,
            settings: settings,
            shadowColor: shadowColor,
          );
          break;
      }

      final picture = recorder.endRecording();
      final img = await picture.toImage(
        settings.coverWidth.round(),
        settings.coverHeight.round(),
      );
      final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);

      if (pngBytes == null) return const Left('Failed to generate image');

      sw.stop();
      debugPrint('TOTAL: ${sw.elapsedMilliseconds}ms');

      return Right(pngBytes);
    } catch (e, st) {
      debugPrint('generateImage error: $e\n$st');
      return Left('Failed to generate cover: $e');
    }
  }

  double _centeredTextX({
    required double coverWidth,
    required TextPainter painter,
    required double horizontalOffset,
  }) {
    final centerX = (coverWidth / 2) + (coverWidth * horizontalOffset);
    return centerX - (painter.width / 2);
  }

  double _centeredBlockX({
    required double coverWidth,
    required double blockWidth,
    required double horizontalOffset,
  }) {
    final centerX = (coverWidth / 2) + (coverWidth * horizontalOffset);
    return centerX - (blockWidth / 2);
  }

  void _drawCenteredTextBlock({
    required Canvas canvas,
    required EbookCoverSettings settings,
    required TextPainter painter,
    required double y,
    required double blockWidth,
    required Color boxColor,
    required Color borderColor,
    required double radius,
    required double horizontalOffset,
    required double verticalPadding,
    List<Map<String, dynamic>>? delta,
    TextStyle? baseStyle,
  }) {
    final scrimX = _centeredBlockX(
      coverWidth: settings.coverWidth,
      blockWidth: blockWidth,
      horizontalOffset: horizontalOffset,
    );

    _drawScrim(
      canvas: canvas,
      x: scrimX,
      y: y - verticalPadding,
      w: blockWidth,
      h: painter.height + verticalPadding * 2,
      color: boxColor,
      borderColor: borderColor,
      radius: radius,
    );

    if (delta != null && baseStyle != null) {
      _paintTextWithScript(canvas, painter, Offset(scrimX, y), delta, baseStyle);
    } else {
      painter.paint(canvas, Offset(scrimX, y));
    }
  }

  void _drawLayoutA({
    required Canvas canvas,
    required EbookCoverSettings settings,
    required Color shadowColor,
  }) {
    _log.i(
      '_drawLayoutA - titleHorizontalOffset: ${settings.titleHorizontalOffset}',
    );

    final padX = settings.coverWidth * 0.08;
    final maxW = settings.coverWidth - padX * 2;

    final titleBaseY =
        settings.coverHeight * (0.16 + settings.titleTopAuthorBottomTopOffset);

    final titleTopY =
        titleBaseY + (settings.coverHeight * settings.titleTopOffset);

    final authorBottomY =
        settings.coverHeight * (0.86 + settings.authorTopOffset);

    final titleResult = _fitText(
      text: settings.title.trim(),
      delta: settings.titleQuillDelta,
      maxWidth: maxW,
      maxLines: 3,
      maxFontSize: settings.coverWidth * 0.14,
      minFontSize: settings.coverWidth * 0.07,
      styleBuilder: (fs) => TextStyle(
        color: settings.titleTextColor,
        fontSize: fs,
        fontWeight: FontWeight.w900,
        height: 1.05,
        letterSpacing: 0.3,
        shadows: [
          Shadow(
            blurRadius: 14,
            offset: const Offset(0, 6),
            color: shadowColor,
          ),
        ],
      ),
      textAlign: settings.titleTextAlign,
    );

    final subtitleResult =
    settings.subtitle != null && settings.subtitle!.trim().isNotEmpty
        ? _fitText(
      text: settings.subtitle!.trim(),
      delta: settings.subtitleQuillDelta,
      maxWidth: maxW,
      maxLines: 2,
      maxFontSize: settings.coverWidth * 0.06,
      minFontSize: settings.coverWidth * 0.045,
      styleBuilder: (fs) => TextStyle(
        color: settings.subtitleTextColor,
        fontSize: fs,
        fontWeight: FontWeight.w700,
        height: 1.15,
        shadows: [
          Shadow(
            blurRadius: 10,
            offset: const Offset(0, 4),
            color: shadowColor,
          ),
        ],
      ),
      textAlign: settings.subtitleTextAlign,
    )
        : null;

    final authorResult = _fitText(
      text: settings.author.trim(),
      delta: settings.authorQuillDelta,
      maxWidth: maxW,
      maxLines: 3,
      maxFontSize: settings.coverWidth * 0.055,
      minFontSize: settings.coverWidth * 0.032,
      styleBuilder: (fs) => TextStyle(
        color: settings.authorTextColor,
        fontSize: fs,
        fontWeight: FontWeight.w800,
        height: 1.15,
        letterSpacing: 0.8,
        shadows: [
          Shadow(
            blurRadius: 10,
            offset: const Offset(0, 4),
            color: shadowColor,
          ),
        ],
      ),
      textAlign: settings.authorTextAlign,
    );

    _drawCenteredTextBlock(
      canvas: canvas,
      settings: settings,
      painter: titleResult.painter,
      y: titleTopY,
      blockWidth: maxW,
      boxColor: settings.titleBoxColor,
      borderColor: settings.titleBorderColor,
      radius: 18,
      horizontalOffset: settings.titleHorizontalOffset,
      verticalPadding: 18,
      delta: settings.titleQuillDelta,
      baseStyle: titleResult.baseStyle,
    );

    if (subtitleResult != null) {
      final subtitleY = titleBaseY +
          titleResult.painter.height +
          settings.coverHeight * (0.02 + settings.subtitleTopOffset);

      _drawCenteredTextBlock(
        canvas: canvas,
        settings: settings,
        painter: subtitleResult.painter,
        y: subtitleY,
        blockWidth: maxW,
        boxColor: settings.subtitleBoxColor,
        borderColor: settings.subtitleBorderColor,
        radius: 18,
        horizontalOffset: settings.subtitleHorizontalOffset,
        verticalPadding: 14,
        delta: settings.subtitleQuillDelta,
        baseStyle: subtitleResult.baseStyle,
      );
    }

    _drawCenteredTextBlock(
      canvas: canvas,
      settings: settings,
      painter: authorResult.painter,
      y: authorBottomY - authorResult.painter.height,
      blockWidth: maxW,
      boxColor: settings.authorBoxColor,
      borderColor: settings.authorBorderColor,
      radius: 18,
      horizontalOffset: settings.authorHorizontalOffset,
      verticalPadding: 18,
      delta: settings.authorQuillDelta,
      baseStyle: authorResult.baseStyle,
    );
  }

  void _drawLayoutB({
    required Canvas canvas,
    required EbookCoverSettings settings,
    required Color shadowColor,
  }) {
    final padX = settings.coverWidth * 0.08;
    final maxW = settings.coverWidth - padX * 2;

    final authorTopY = settings.coverHeight *
        (0.12 +
            settings.authorTopTitleCenterTopOffset +
            settings.authorTopOffset);

    final titleCenterY = settings.coverHeight * 0.42;

    final authorResult = _fitText(
      text: settings.author.trim(),
      delta: settings.authorQuillDelta,
      maxWidth: maxW,
      maxLines: 3,
      maxFontSize: settings.coverWidth * 0.055,
      minFontSize: settings.coverWidth * 0.032,
      styleBuilder: (fs) => TextStyle(
        color: settings.authorTextColor,
        fontSize: fs,
        fontWeight: FontWeight.w800,
        height: 1.15,
        letterSpacing: 1.0,
        shadows: [
          Shadow(
            blurRadius: 10,
            offset: const Offset(0, 4),
            color: shadowColor,
          ),
        ],
      ),
      textAlign: settings.authorTextAlign,
    );

    final titleResult = _fitText(
      text: settings.title.trim(),
      delta: settings.titleQuillDelta,
      maxWidth: maxW,
      maxLines: 3,
      maxFontSize: settings.coverWidth * 0.16,
      minFontSize: settings.coverWidth * 0.08,
      styleBuilder: (fs) => TextStyle(
        color: settings.titleTextColor,
        fontSize: fs,
        fontWeight: FontWeight.w900,
        height: 1.03,
        letterSpacing: 0.2,
        shadows: [
          Shadow(
            blurRadius: 14,
            offset: const Offset(0, 6),
            color: shadowColor,
          ),
        ],
      ),
      textAlign: settings.titleTextAlign,
    );

    final subtitleResult =
    settings.subtitle != null && settings.subtitle!.trim().isNotEmpty
        ? _fitText(
      text: settings.subtitle!.trim(),
      delta: settings.subtitleQuillDelta,
      maxWidth: maxW,
      maxLines: 2,
      maxFontSize: settings.coverWidth * 0.065,
      minFontSize: settings.coverWidth * 0.045,
      styleBuilder: (fs) => TextStyle(
        color: settings.subtitleTextColor,
        fontSize: fs,
        fontWeight: FontWeight.w700,
        height: 1.15,
        shadows: [
          Shadow(
            blurRadius: 10,
            offset: const Offset(0, 4),
            color: shadowColor,
          ),
        ],
      ),
      textAlign: settings.subtitleTextAlign,
    )
        : null;

    _drawCenteredTextBlock(
      canvas: canvas,
      settings: settings,
      painter: authorResult.painter,
      y: authorTopY,
      blockWidth: maxW,
      boxColor: settings.authorBoxColor,
      borderColor: settings.authorBorderColor,
      radius: 18,
      horizontalOffset: settings.authorHorizontalOffset,
      verticalPadding: 16,
      delta: settings.authorQuillDelta,
      baseStyle: authorResult.baseStyle,
    );

    final blockH = titleResult.painter.height +
        (subtitleResult != null
            ? (settings.coverHeight * 0.02 + subtitleResult.painter.height)
            : 0);

    final blockTopBaseY = titleCenterY - (blockH / 2);
    final titleY =
        blockTopBaseY + (settings.coverHeight * settings.titleTopOffset);

    _drawCenteredTextBlock(
      canvas: canvas,
      settings: settings,
      painter: titleResult.painter,
      y: titleY,
      blockWidth: maxW,
      boxColor: settings.titleBoxColor,
      borderColor: settings.titleBorderColor,
      radius: 18,
      horizontalOffset: settings.titleHorizontalOffset,
      verticalPadding: 18,
      delta: settings.titleQuillDelta,
      baseStyle: titleResult.baseStyle,
    );

    if (subtitleResult != null) {
      final subtitleY = blockTopBaseY +
          titleResult.painter.height +
          settings.coverHeight * (0.02 + settings.subtitleTopOffset);

      _drawCenteredTextBlock(
        canvas: canvas,
        settings: settings,
        painter: subtitleResult.painter,
        y: subtitleY,
        blockWidth: maxW,
        boxColor: settings.subtitleBoxColor,
        borderColor: settings.subtitleBorderColor,
        radius: 18,
        horizontalOffset: settings.subtitleHorizontalOffset,
        verticalPadding: 14,
        delta: settings.subtitleQuillDelta,
        baseStyle: subtitleResult.baseStyle,
      );
    }
  }

  void _drawLayoutC({
    required Canvas canvas,
    required EbookCoverSettings settings,
    required Color shadowColor,
  }) {
    final padX = settings.coverWidth * 0.08;
    final maxW = settings.coverWidth - padX * 2;
    final centerY = settings.coverHeight * 0.46;

    final titleResult = _fitText(
      text: settings.title.trim(),
      delta: settings.titleQuillDelta,
      maxWidth: maxW,
      maxLines: 4,
      maxFontSize: settings.coverWidth * 0.18,
      minFontSize: settings.coverWidth * 0.09,
      styleBuilder: (fs) => TextStyle(
        color: settings.titleTextColor,
        fontSize: fs,
        fontWeight: FontWeight.w900,
        height: 1.02,
        letterSpacing: 0.1,
        shadows: [
          Shadow(
            blurRadius: 16,
            offset: const Offset(0, 7),
            color: shadowColor,
          ),
        ],
      ),
      textAlign: settings.titleTextAlign,
    );

    final subtitleResult =
    settings.subtitle != null && settings.subtitle!.trim().isNotEmpty
        ? _fitText(
      text: settings.subtitle!.trim(),
      delta: settings.subtitleQuillDelta,
      maxWidth: maxW,
      maxLines: 2,
      maxFontSize: settings.coverWidth * 0.06,
      minFontSize: settings.coverWidth * 0.042,
      styleBuilder: (fs) => TextStyle(
        color: settings.subtitleTextColor,
        fontSize: fs,
        fontWeight: FontWeight.w700,
        height: 1.15,
        shadows: [
          Shadow(
            blurRadius: 10,
            offset: const Offset(0, 4),
            color: shadowColor,
          ),
        ],
      ),
      textAlign: settings.subtitleTextAlign,
    )
        : null;

    final authorResult = _fitText(
      text: settings.author.trim(),
      delta: settings.authorQuillDelta,
      maxWidth: maxW,
      maxLines: 3,
      maxFontSize: settings.coverWidth * 0.05,
      minFontSize: settings.coverWidth * 0.03,
      styleBuilder: (fs) => TextStyle(
        color: settings.authorTextColor,
        fontSize: fs,
        fontWeight: FontWeight.w800,
        height: 1.15,
        letterSpacing: 1.1,
        shadows: [
          Shadow(
            blurRadius: 10,
            offset: const Offset(0, 4),
            color: shadowColor,
          ),
        ],
      ),
      textAlign: settings.authorTextAlign,
    );

    final gap1 = settings.coverHeight * 0.04;
    final gap2 = settings.coverHeight * 0.05;

    final blockH = titleResult.painter.height +
        (subtitleResult != null ? (gap1 + subtitleResult.painter.height) : 0) +
        gap2 +
        authorResult.painter.height;

    final topY = centerY - blockH / 2;
    final titleY = topY + (settings.coverHeight * settings.titleTopOffset);

    _drawCenteredTextBlock(
      canvas: canvas,
      settings: settings,
      painter: titleResult.painter,
      y: titleY,
      blockWidth: maxW,
      boxColor: settings.titleBoxColor,
      borderColor: settings.titleBorderColor,
      radius: 18,
      horizontalOffset: settings.titleHorizontalOffset,
      verticalPadding: 18,
      delta: settings.titleQuillDelta,
      baseStyle: titleResult.baseStyle,
    );

    double authorY = topY + titleResult.painter.height;

    if (subtitleResult != null) {
      final subtitleY = topY +
          titleResult.painter.height +
          gap1 +
          (settings.coverHeight * settings.subtitleTopOffset);

      _drawCenteredTextBlock(
        canvas: canvas,
        settings: settings,
        painter: subtitleResult.painter,
        y: subtitleY,
        blockWidth: maxW,
        boxColor: settings.subtitleBoxColor,
        borderColor: settings.subtitleBorderColor,
        radius: 18,
        horizontalOffset: settings.subtitleHorizontalOffset,
        verticalPadding: 14,
        delta: settings.subtitleQuillDelta,
        baseStyle: subtitleResult.baseStyle,
      );

      authorY += gap1 + subtitleResult.painter.height;
    }

    authorY += gap2 + (settings.coverHeight * settings.authorTopOffset);

    _drawCenteredTextBlock(
      canvas: canvas,
      settings: settings,
      painter: authorResult.painter,
      y: authorY,
      blockWidth: maxW,
      boxColor: settings.authorBoxColor,
      borderColor: settings.authorBorderColor,
      radius: 18,
      horizontalOffset: settings.authorHorizontalOffset,
      verticalPadding: 18,
      delta: settings.authorQuillDelta,
      baseStyle: authorResult.baseStyle,
    );
  }

  void _drawCornerBadge({
    required Canvas canvas,
    required EbookCoverSettings settings,
  }) {
    if (settings.cornerBadgeText == null) return;

    final bannerH = settings.coverHeight * 0.055;
    final bannerW = settings.coverWidth * 0.72;
    final cornerOffset = settings.coverWidth * 0.18;

    final isLeft =
        settings.cornerBadgePosition == CornerBadgePosition.topLeft ||
            settings.cornerBadgePosition == CornerBadgePosition.bottomLeft;

    final isTop = settings.cornerBadgePosition == CornerBadgePosition.topLeft ||
        settings.cornerBadgePosition == CornerBadgePosition.topRight;

    final center = Offset(
      isLeft ? cornerOffset : settings.coverWidth - cornerOffset,
      isTop ? cornerOffset : settings.coverHeight - cornerOffset,
    );

    final angle = isLeft == isTop ? -pi / 4 : pi / 4;

    final rect = Rect.fromCenter(
      center: Offset.zero,
      width: bannerW,
      height: bannerH,
    );

    final rrect = RRect.fromRectAndRadius(
      rect,
      const Radius.circular(14),
    );

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    canvas.drawRRect(rrect, Paint()..color = settings.cornerBadgeColor);
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = settings.cornerBadgeBorderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = settings.coverWidth * 0.003,
    );

    final textWidth = bannerW - 24;
    final badgeResult = _fitText(
      text: settings.cornerBadgeText!.trim(),
      delta: settings.cornerBadgeQuillDelta,
      maxWidth: textWidth,
      maxLines: 1,
      maxFontSize: bannerH * 0.55,
      minFontSize: bannerH * 0.35,
      styleBuilder: (fs) => TextStyle(
        color: settings.cornerBadgeTextColor,
        fontSize: fs,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.8,
      ),
      textAlign: settings.cornerBadgeTextAlign,
    );

    final dx = rect.left + 12;
    final dy = rect.top + (bannerH - badgeResult.painter.height) / 2;

    _paintTextWithScript(canvas, badgeResult.painter, Offset(dx, dy), settings.cornerBadgeQuillDelta, badgeResult.baseStyle);
    canvas.restore();
  }

  void _drawOptionalMetadata({
    required Canvas canvas,
    required EbookCoverSettings settings,
    required Color shadowColor,
  }) {
    final padX = settings.coverWidth * 0.08;
    final maxW = settings.coverWidth - padX * 2;

    final entries = <({
    String text,
    double y,
    double maxFontSize,
    Color textColor,
    Color boxColor,
    Color borderColor,
    double horizontalOffset,
    TextAlign textAlign,
    List<Map<String, dynamic>>? delta,
    })>[
      if (settings.seriesTitle != null &&
          settings.seriesTitle!.trim().isNotEmpty)
        (
        text: settings.seriesTitle!.trim(),
        y: settings.coverHeight * (0.055 + settings.seriesTitleTopOffset),
        maxFontSize: settings.coverWidth * 0.045,
        textColor: settings.seriesTitleTextColor,
        boxColor: settings.seriesTitleBoxColor,
        borderColor: settings.seriesTitleBorderColor,
        horizontalOffset: settings.seriesTitleHorizontalOffset,
        textAlign: settings.seriesTitleTextAlign,
        delta: settings.seriesTitleQuillDelta,
        ),
      if (settings.tagline != null && settings.tagline!.trim().isNotEmpty)
        (
        text: settings.tagline!.trim(),
        y: settings.coverHeight * (0.74 + settings.taglineTopOffset),
        maxFontSize: settings.coverWidth * 0.05,
        textColor: settings.taglineTextColor,
        boxColor: settings.taglineBoxColor,
        borderColor: settings.taglineBorderColor,
        horizontalOffset: settings.taglineHorizontalOffset,
        textAlign: settings.taglineTextAlign,
        delta: settings.taglineQuillDelta,
        ),
      if (settings.editionLine != null &&
          settings.editionLine!.trim().isNotEmpty)
        (
        text: settings.editionLine!.trim(),
        y: settings.coverHeight * (0.915 + settings.editionLineTopOffset),
        maxFontSize: settings.coverWidth * 0.04,
        textColor: settings.editionLineTextColor,
        boxColor: settings.editionLineBoxColor,
        borderColor: settings.editionLineBorderColor,
        horizontalOffset: settings.editionLineHorizontalOffset,
        textAlign: settings.editionLineTextAlign,
        delta: settings.editionLineQuillDelta,
        ),
    ];

    for (final entry in entries) {
      final entryResult = _fitText(
        text: entry.text,
        delta: entry.delta,
        maxWidth: maxW,
        maxLines: 1,
        maxFontSize: entry.maxFontSize,
        minFontSize: settings.coverWidth * 0.03,
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
        textAlign: entry.textAlign,
      );

      _drawCenteredTextBlock(
        canvas: canvas,
        settings: settings,
        painter: entryResult.painter,
        y: entry.y,
        blockWidth: maxW,
        boxColor: entry.boxColor,
        borderColor: entry.borderColor,
        radius: 14,
        horizontalOffset: entry.horizontalOffset,
        verticalPadding: 10,
        delta: entry.delta,
        baseStyle: entryResult.baseStyle,
      );
    }
  }

  void _drawScrim({
    required Canvas canvas,
    required double x,
    required double y,
    required double w,
    required double h,
    required Color color,
    required Color borderColor,
    required double radius,
  }) {
    final rect = Rect.fromLTWH(x, y, w, h);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    canvas.drawRRect(rrect, Paint()..color = color);
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.003,
    );
  }

  TextAlign _textAlignFromDelta(
    List<Map<String, dynamic>>? delta,
    TextAlign fallback,
  ) {
    if (delta == null) return fallback;
    for (final op in delta) {
      final insert = op['insert'];
      if (insert is String && insert.contains('\n')) {
        final align = (op['attributes'] as Map?)?['align'];
        if (align is String) {
          return switch (align) {
            'left' => TextAlign.left,
            'right' => TextAlign.right,
            'center' => TextAlign.center,
            'justify' => TextAlign.justify,
            _ => fallback,
          };
        }
      }
    }
    return fallback;
  }

  ({TextPainter painter, TextStyle baseStyle}) _fitText({
    required String text,
    List<Map<String, dynamic>>? delta,
    required double maxWidth,
    required int maxLines,
    required double maxFontSize,
    required double minFontSize,
    required TextStyle Function(double fontSize) styleBuilder,
    TextAlign textAlign = TextAlign.left,
  }) {
    final resolvedAlign = _textAlignFromDelta(delta, textAlign);
    double lo = minFontSize;
    double hi = maxFontSize;

    var bestStyle = styleBuilder(lo);
    TextPainter best = _layoutPainter(
      text,
      bestStyle,
      delta,
      maxWidth,
      maxLines,
      resolvedAlign,
    );

    for (int i = 0; i < 14; i++) {
      final mid = (lo + hi) / 2;
      final midStyle = styleBuilder(mid);

      final tp = _layoutPainter(
        text,
        midStyle,
        delta,
        maxWidth,
        maxLines,
        resolvedAlign,
      );

      final fits = !tp.didExceedMaxLines && tp.width <= maxWidth + 0.001;

      if (fits) {
        best = tp;
        bestStyle = midStyle;
        lo = mid;
      } else {
        hi = mid;
      }
    }

    return (painter: best, baseStyle: bestStyle);
  }

  TextPainter _layoutPainter(
      String text,
      TextStyle style,
      List<Map<String, dynamic>>? delta,
      double maxWidth,
      int maxLines,
      TextAlign textAlign,
      ) {
    final tp = TextPainter(
      text: _buildTextSpan(text: text, delta: delta, baseStyle: style),
      textDirection: TextDirection.ltr,
      textAlign: textAlign,
      maxLines: maxLines,
      ellipsis: '…',
    )..layout(
      minWidth: maxWidth,
      maxWidth: maxWidth,
    );

    return tp;
  }

  void _paintTextWithScript(
    Canvas canvas,
    TextPainter painter,
    Offset offset,
    List<Map<String, dynamic>>? delta,
    TextStyle baseStyle,
  ) {
    painter.paint(canvas, offset);

    if (delta == null) return;

    int charPos = 0;
    for (var i = 0; i < delta.length; i++) {
      final op = delta[i];
      final insert = op['insert'];
      if (insert is! String) continue;

      var segment = insert;
      if (i == delta.length - 1) {
        segment = segment.replaceFirst(RegExp(r'\n$'), '');
      }
      if (segment.isEmpty) continue;

      final script = (op['attributes'] as Map?)?['script'];
      final segLen = segment.length;

      if (script == 'super' || script == 'sub') {
        final style = _styleFromDeltaAttributes(
          baseStyle: baseStyle,
          attributes: op['attributes'],
        );
        final boxes = painter.getBoxesForSelection(
          TextSelection(baseOffset: charPos, extentOffset: charPos + segLen),
        );
        if (boxes.isNotEmpty) {
          final box = boxes.first;
          final fontSize = style.fontSize ?? baseStyle.fontSize ?? 12;
          final shiftY = script == 'super' ? -fontSize * 0.75 : fontSize * 0.35;
          final scriptPainter = TextPainter(
            text: TextSpan(text: segment, style: style.copyWith(fontFeatures: null)),
            textDirection: TextDirection.ltr,
          )..layout();
          scriptPainter.paint(
            canvas,
            Offset(offset.dx + box.left, offset.dy + box.top + shiftY),
          );
        }
      }

      charPos += segLen;
    }
  }

  TextSpan _buildTextSpan({
    required String text,
    required List<Map<String, dynamic>>? delta,
    required TextStyle baseStyle,
  }) {
    if (delta == null || delta.isEmpty) {
      return TextSpan(text: text, style: baseStyle);
    }

    final spans = <TextSpan>[];
    var plainText = '';

    for (var i = 0; i < delta.length; i++) {
      final operation = delta[i];
      final insert = operation['insert'];
      if (insert is! String) continue;

      var segment = insert;
      if (i == delta.length - 1) {
        segment = segment.replaceFirst(RegExp(r'\n$'), '');
      }
      if (segment.isEmpty) continue;

      plainText += segment;
      final script = (operation['attributes'] as Map?)?['script'];
      final style = _styleFromDeltaAttributes(
        baseStyle: baseStyle,
        attributes: operation['attributes'],
      );
      // Superscript runs are painted separately in _paintTextWithScript.
      // Render them transparent here so they still reserve the correct width.
      spans.add(
        TextSpan(
          text: segment,
          style: (script == 'super' || script == 'sub')
              ? style.copyWith(color: const Color(0x00000000))
              : style,
        ),
      );
    }

    if (spans.isEmpty || plainText.trim().isEmpty) {
      return TextSpan(text: text, style: baseStyle);
    }

    return TextSpan(style: baseStyle, children: spans);
  }

  TextStyle _styleFromDeltaAttributes({
    required TextStyle baseStyle,
    required Object? attributes,
  }) {
    if (attributes is! Map) return baseStyle;

    final script = attributes['script'];
    final scriptFeatures = _fontFeaturesFromScript(script);
    final scriptFontSize = _fontSizeForScript(script, baseStyle.fontSize);

    final overrides = baseStyle.copyWith(
      color: _colorFromDeltaAttribute(attributes['color']) ?? baseStyle.color,
      backgroundColor: _colorFromDeltaAttribute(attributes['background']),
      fontWeight: attributes['bold'] == true ? FontWeight.w900 : null,
      fontStyle: attributes['italic'] == true ? FontStyle.italic : null,
      decoration: _textDecorationFromAttributes(attributes),
      fontSize: _fontSizeFromDeltaAttribute(
        value: attributes['size'],
        baseFontSize: baseStyle.fontSize,
      ) ?? scriptFontSize,
      fontFeatures: scriptFeatures,
    );

    final fontKey = attributes['font'];
    if (fontKey is String && fontKey.trim().isNotEmpty) {
      final gfStyle = _resolveFontStyle(fontKey.trim(), overrides);
      if (gfStyle != null) return gfStyle;
    }

    return overrides;
  }

  Color? _colorFromDeltaAttribute(Object? value) {
    if (value is! String) return null;

    final normalized = value.trim();
    if (!normalized.startsWith('#')) return null;

    final hex = normalized.substring(1);
    if (hex.length == 6) {
      final colorValue = int.tryParse('FF$hex', radix: 16);
      return colorValue == null ? null : Color(colorValue);
    }

    if (hex.length == 8) {
      final colorValue = int.tryParse(hex, radix: 16);
      return colorValue == null ? null : Color(colorValue);
    }

    return null;
  }


  double? _fontSizeFromDeltaAttribute({
    required Object? value,
    required double? baseFontSize,
  }) {
    if (baseFontSize == null) return null;

    if (value is num) return value.toDouble();

    if (value is String) {
      final normalized = value.trim().toLowerCase();
      final parsed = double.tryParse(normalized.replaceAll('px', ''));
      if (parsed != null) return parsed;

      return switch (normalized) {
        'small' => baseFontSize * 0.8,
        'large' => baseFontSize * 1.2,
        'huge' => baseFontSize * 1.5,
        _ => null,
      };
    }

    return null;
  }

  List<FontFeature>? _fontFeaturesFromScript(Object? value) {
    if (value == 'sub') return const [FontFeature.subscripts()];
    if (value == 'super') return const [FontFeature.superscripts()];
    return null;
  }

  double? _fontSizeForScript(Object? value, double? baseFontSize) {
    if ((value == 'sub' || value == 'super') && baseFontSize != null) {
      return baseFontSize * 0.65;
    }
    return null;
  }

  TextDecoration? _textDecorationFromAttributes(Map attributes) {
    final decorations = <TextDecoration>[];
    if (attributes['underline'] == true) decorations.add(TextDecoration.underline);
    if (attributes['strike'] == true) decorations.add(TextDecoration.lineThrough);
    if (decorations.isEmpty) return null;
    return TextDecoration.combine(decorations);
  }

  Future<ui.Image> _decodeToUiImage(Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();

    return frame.image;
  }

  void _drawBackgroundImage({
    required Canvas canvas,
    required EbookCoverSettings settings,
    required ui.Image image,
    required Rect dstRect,
  }) {
    final paint = Paint()
      ..filterQuality = FilterQuality.high
      ..blendMode = settings.backgroundBlendMode
      ..color = Colors.white.withValues(
        alpha: settings.backgroundImageOpacity.clamp(0, 1).toDouble(),
      );

    final safeScaleX = max(0.05, settings.backgroundImageScaleX.abs());
    final safeScaleY = max(0.05, settings.backgroundImageScaleY.abs());

    final srcRect = Rect.fromLTWH(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );

    Rect alignedRect(Size size) {
      final x = dstRect.left +
          (dstRect.width - size.width) *
              ((settings.backgroundImageAlignment.x + 1) / 2);

      final y = dstRect.top +
          (dstRect.height - size.height) *
              ((settings.backgroundImageAlignment.y + 1) / 2);

      return Rect.fromLTWH(x, y, size.width, size.height);
    }

    Size imageSizeForMode() {
      final imageW = image.width.toDouble();
      final imageH = image.height.toDouble();

      switch (settings.backgroundImageMode) {
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

    if (settings.backgroundImageMode == BackgroundImageMode.tile ||
        settings.backgroundImageMode == BackgroundImageMode.tileX ||
        settings.backgroundImageMode == BackgroundImageMode.tileY) {
      canvas.save();
      canvas.clipRect(dstRect);

      final startRect = alignedRect(imageSize);

      final startX = settings.backgroundImageMode == BackgroundImageMode.tileY
          ? startRect.left
          : dstRect.left - imageSize.width;

      final endX = settings.backgroundImageMode == BackgroundImageMode.tileY
          ? startRect.left
          : dstRect.right + imageSize.width;

      final startY = settings.backgroundImageMode == BackgroundImageMode.tileX
          ? startRect.top
          : dstRect.top - imageSize.height;

      final endY = settings.backgroundImageMode == BackgroundImageMode.tileX
          ? startRect.top
          : dstRect.bottom + imageSize.height;

      for (double y = startY; y <= endY; y += imageSize.height) {
        for (double x = startX; x <= endX; x += imageSize.width) {
          canvas.drawImageRect(
            image,
            srcRect,
            Rect.fromLTWH(x, y, imageSize.width, imageSize.height),
            paint,
          );

          if (settings.backgroundImageMode == BackgroundImageMode.tileY) break;
        }

        if (settings.backgroundImageMode == BackgroundImageMode.tileX) break;
      }

      canvas.restore();
      return;
    }

    canvas.drawImageRect(
      image,
      srcRect,
      alignedRect(imageSize),
      paint,
    );
  }

  Future<double> _estimateImageLuminance(ui.Image image) async {
    final bd = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (bd == null) return 0.3;

    final bytes = bd.buffer.asUint8List();
    final w = image.width;
    final h = image.height;

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

        final lum = 0.2126 * r + 0.7152 * g + 0.0722 * b;

        sum += lum;
        count++;
      }
    }

    return count == 0 ? 0.3 : (sum / count);
  }

  double _luminanceOfColor(Color c) {
    return c.computeLuminance();
  }

  Future<String?> saveCoverPng({
    required ByteData pngBytes,
    required String fileNameWithoutExtension,
  }) async {
    final bytes = pngBytes.buffer.asUint8List();

    final result = await FileSaver.instance.saveFile(
      name: fileNameWithoutExtension,
      bytes: bytes,
      fileExtension: 'png',
      mimeType: MimeType.png,
    );

    return result;
  }
}