/*
Common professional layout patterns:

Option A — Title top, Author bottom

Most common for fiction.

Option B — Author top, Title center

Common in non-fiction / branding books.

Option C — Big center title, small author top or bottom

Modern minimal style.
 */
enum CoverLayout {
  /// Option A: Title near top, author near bottom
  titleTopAuthorBottom,

  /// Option B: Author near top, title centered
  authorTopTitleCenter,

  /// Option C: Big title centered, author/subtitle smaller (modern)
  bigCenterTitle,
}

enum CornerBadgePosition {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

enum BackgroundImageMode {
  cover,
  contain,
  stretch,
  center,
  tile,
  tileX,
  tileY,
}