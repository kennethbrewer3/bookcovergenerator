import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
  ];

  /// The application title shown in the app bar
  ///
  /// In en, this message translates to:
  /// **'Book Cover Designer'**
  String get appTitle;

  /// Tooltip on the theme picker button
  ///
  /// In en, this message translates to:
  /// **'Select theme'**
  String get themeSelectTooltip;

  /// Light theme label
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// Dark theme label
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// Military light theme label
  ///
  /// In en, this message translates to:
  /// **'Military Light'**
  String get themeMilitaryLight;

  /// Military dark theme label
  ///
  /// In en, this message translates to:
  /// **'Military Dark'**
  String get themeMilitaryDark;

  /// Expansion panel title for background section
  ///
  /// In en, this message translates to:
  /// **'Background Color and Image'**
  String get sectionBackground;

  /// Expansion panel title for title section
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get sectionTitle;

  /// Expansion panel title for author section
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get sectionAuthor;

  /// Expansion panel title for subtitle section
  ///
  /// In en, this message translates to:
  /// **'Subtitle'**
  String get sectionSubtitle;

  /// Expansion panel title for tagline section
  ///
  /// In en, this message translates to:
  /// **'Tagline'**
  String get sectionTagline;

  /// Expansion panel title for series title section
  ///
  /// In en, this message translates to:
  /// **'Series Title'**
  String get sectionSeries;

  /// Expansion panel title for edition section
  ///
  /// In en, this message translates to:
  /// **'Edition'**
  String get sectionEdition;

  /// Expansion panel title for corner badge section
  ///
  /// In en, this message translates to:
  /// **'Corner Badge'**
  String get sectionBadge;

  /// Expansion panel title for cover layout section
  ///
  /// In en, this message translates to:
  /// **'Cover Layout'**
  String get sectionLayout;

  /// Expansion panel title for actions section
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get sectionActions;

  /// Label for ebook title input
  ///
  /// In en, this message translates to:
  /// **'Ebook Title'**
  String get fieldEbookTitle;

  /// Label for author name input
  ///
  /// In en, this message translates to:
  /// **'Author Name'**
  String get fieldAuthorName;

  /// Label for subtitle input
  ///
  /// In en, this message translates to:
  /// **'Subtitle'**
  String get fieldSubtitle;

  /// Label for tagline input
  ///
  /// In en, this message translates to:
  /// **'Tagline'**
  String get fieldTagline;

  /// Label for series title input
  ///
  /// In en, this message translates to:
  /// **'Series Title'**
  String get fieldSeriesTitle;

  /// Label for edition line input
  ///
  /// In en, this message translates to:
  /// **'Edition Line'**
  String get fieldEditionLine;

  /// Label for corner badge text input
  ///
  /// In en, this message translates to:
  /// **'Corner Badge'**
  String get fieldCornerBadge;

  /// Label for background color button
  ///
  /// In en, this message translates to:
  /// **'Background Color'**
  String get colorBackground;

  /// Label for title box color button
  ///
  /// In en, this message translates to:
  /// **'Box Color'**
  String get colorTitleBox;

  /// Label for title border color button
  ///
  /// In en, this message translates to:
  /// **'Border Color'**
  String get colorTitleBorder;

  /// Label for author text color button
  ///
  /// In en, this message translates to:
  /// **'Author Text Color'**
  String get colorAuthorText;

  /// Label for author box color button
  ///
  /// In en, this message translates to:
  /// **'Author Box Color'**
  String get colorAuthorBox;

  /// Label for author border color button
  ///
  /// In en, this message translates to:
  /// **'Author Border Color'**
  String get colorAuthorBorder;

  /// Label for subtitle text color button
  ///
  /// In en, this message translates to:
  /// **'Subtitle Text Color'**
  String get colorSubtitleText;

  /// Label for subtitle box color button
  ///
  /// In en, this message translates to:
  /// **'Subtitle Box Color'**
  String get colorSubtitleBox;

  /// Label for subtitle border color button
  ///
  /// In en, this message translates to:
  /// **'Subtitle Border Color'**
  String get colorSubtitleBorder;

  /// Label for tagline text color button
  ///
  /// In en, this message translates to:
  /// **'Tagline Text Color'**
  String get colorTaglineText;

  /// Label for tagline box color button
  ///
  /// In en, this message translates to:
  /// **'Tagline Box Color'**
  String get colorTaglineBox;

  /// Label for tagline border color button
  ///
  /// In en, this message translates to:
  /// **'Tagline Border Color'**
  String get colorTaglineBorder;

  /// Label for series title text color button
  ///
  /// In en, this message translates to:
  /// **'Series Title Text Color'**
  String get colorSeriesTitleText;

  /// Label for series title box color button
  ///
  /// In en, this message translates to:
  /// **'Series Title Box Color'**
  String get colorSeriesTitleBox;

  /// Label for series title border color button
  ///
  /// In en, this message translates to:
  /// **'Series Title Border Color'**
  String get colorSeriesTitleBorder;

  /// Label for edition line text color button
  ///
  /// In en, this message translates to:
  /// **'Edition Line Text Color'**
  String get colorEditionLineText;

  /// Label for edition line box color button
  ///
  /// In en, this message translates to:
  /// **'Edition Line Box Color'**
  String get colorEditionLineBox;

  /// Label for edition line border color button
  ///
  /// In en, this message translates to:
  /// **'Edition Line Border Color'**
  String get colorEditionLineBorder;

  /// Label for badge text color button
  ///
  /// In en, this message translates to:
  /// **'Badge Text Color'**
  String get colorBadgeText;

  /// Label for badge color button
  ///
  /// In en, this message translates to:
  /// **'Badge Color'**
  String get colorBadge;

  /// Label for badge border color button
  ///
  /// In en, this message translates to:
  /// **'Badge Border Color'**
  String get colorBadgeBorder;

  /// Subheading in the color picker dialog
  ///
  /// In en, this message translates to:
  /// **'Select shade'**
  String get colorPickerShadeSubheading;

  /// Label for cover size dropdown
  ///
  /// In en, this message translates to:
  /// **'Cover Size'**
  String get coverSizeLabel;

  /// Label for background image mode dropdown
  ///
  /// In en, this message translates to:
  /// **'Background Image Mode'**
  String get backgroundImageMode;

  /// Label for background image alignment dropdown
  ///
  /// In en, this message translates to:
  /// **'Background Image Alignment'**
  String get backgroundImageAlignment;

  /// Label for background image scale X slider
  ///
  /// In en, this message translates to:
  /// **'Background Image Scale X'**
  String get backgroundImageScaleX;

  /// Label for background image scale Y slider
  ///
  /// In en, this message translates to:
  /// **'Background Image Scale Y'**
  String get backgroundImageScaleY;

  /// Label for background blend mode dropdown
  ///
  /// In en, this message translates to:
  /// **'Background Mix Mode'**
  String get backgroundMixMode;

  /// Label for background image opacity slider
  ///
  /// In en, this message translates to:
  /// **'Background Image Opacity'**
  String get backgroundImageOpacity;

  /// Button to pick a background color
  ///
  /// In en, this message translates to:
  /// **'Choose Background Color'**
  String get btnChooseBackgroundColor;

  /// Button to pick a background image
  ///
  /// In en, this message translates to:
  /// **'Choose Background Image'**
  String get btnChooseBackgroundImage;

  /// Button to remove the background image
  ///
  /// In en, this message translates to:
  /// **'Clear Image'**
  String get btnClearImage;

  /// Slider label for title vertical offset
  ///
  /// In en, this message translates to:
  /// **'Title Top Offset'**
  String get sliderTitleTopOffset;

  /// Slider label for title horizontal offset
  ///
  /// In en, this message translates to:
  /// **'Title Horizontal Offset'**
  String get sliderTitleHorizontalOffset;

  /// Slider label for author vertical offset
  ///
  /// In en, this message translates to:
  /// **'Author Top Offset'**
  String get sliderAuthorTopOffset;

  /// Slider label for author horizontal offset
  ///
  /// In en, this message translates to:
  /// **'Author Left Offset'**
  String get sliderAuthorLeftOffset;

  /// Slider label for subtitle vertical offset
  ///
  /// In en, this message translates to:
  /// **'Subtitle Top Offset'**
  String get sliderSubtitleTopOffset;

  /// Slider label for subtitle horizontal offset
  ///
  /// In en, this message translates to:
  /// **'Subtitle Left Offset'**
  String get sliderSubtitleLeftOffset;

  /// Slider label for tagline vertical offset
  ///
  /// In en, this message translates to:
  /// **'Tagline Top Offset'**
  String get sliderTaglineTopOffset;

  /// Slider label for tagline horizontal offset
  ///
  /// In en, this message translates to:
  /// **'Tagline Left Offset'**
  String get sliderTaglineLeftOffset;

  /// Slider label for series title vertical offset
  ///
  /// In en, this message translates to:
  /// **'Series Title Top Offset'**
  String get sliderSeriesTitleTopOffset;

  /// Slider label for series title horizontal offset
  ///
  /// In en, this message translates to:
  /// **'Series Title Left Offset'**
  String get sliderSeriesTitleLeftOffset;

  /// Slider label for edition line vertical offset
  ///
  /// In en, this message translates to:
  /// **'Edition Line Top Offset'**
  String get sliderEditionLineTopOffset;

  /// Slider label for edition line horizontal offset
  ///
  /// In en, this message translates to:
  /// **'Edition Line Left Offset'**
  String get sliderEditionLineLeftOffset;

  /// Slider label for top/bottom layout offset
  ///
  /// In en, this message translates to:
  /// **'Top / Bottom Top Offset'**
  String get sliderTopBottomTopOffset;

  /// Slider label for top/center layout offset
  ///
  /// In en, this message translates to:
  /// **'Top / Center Top Offset'**
  String get sliderTopCenterTopOffset;

  /// Layout segment button label: modern
  ///
  /// In en, this message translates to:
  /// **'Modern'**
  String get layoutModern;

  /// Layout segment button label: top/bottom
  ///
  /// In en, this message translates to:
  /// **'Top / Bottom'**
  String get layoutTopBottom;

  /// Layout segment button label: top/center
  ///
  /// In en, this message translates to:
  /// **'Top / Center'**
  String get layoutTopCenter;

  /// Tooltip for modern layout button
  ///
  /// In en, this message translates to:
  /// **'Big centered title layout'**
  String get layoutModernTooltip;

  /// Tooltip for top/bottom layout button
  ///
  /// In en, this message translates to:
  /// **'Title near top, author near bottom'**
  String get layoutTopBottomTooltip;

  /// Tooltip for top/center layout button
  ///
  /// In en, this message translates to:
  /// **'Author near top, title centered'**
  String get layoutTopCenterTooltip;

  /// Badge position: top left
  ///
  /// In en, this message translates to:
  /// **'Top Left'**
  String get badgePositionTopLeft;

  /// Badge position: top right
  ///
  /// In en, this message translates to:
  /// **'Top Right'**
  String get badgePositionTopRight;

  /// Badge position: bottom left
  ///
  /// In en, this message translates to:
  /// **'Bottom Left'**
  String get badgePositionBottomLeft;

  /// Badge position: bottom right
  ///
  /// In en, this message translates to:
  /// **'Bottom Right'**
  String get badgePositionBottomRight;

  /// Background image mode: cover
  ///
  /// In en, this message translates to:
  /// **'Cover'**
  String get imgModeCover;

  /// Background image mode: fit/contain
  ///
  /// In en, this message translates to:
  /// **'Fit'**
  String get imgModeFit;

  /// Background image mode: stretch
  ///
  /// In en, this message translates to:
  /// **'Stretch'**
  String get imgModeStretch;

  /// Background image mode: center
  ///
  /// In en, this message translates to:
  /// **'Center'**
  String get imgModeCenter;

  /// Background image mode: tile both axes
  ///
  /// In en, this message translates to:
  /// **'Tile X and Y'**
  String get imgModeTileXY;

  /// Background image mode: tile X axis
  ///
  /// In en, this message translates to:
  /// **'Tile X'**
  String get imgModeTileX;

  /// Background image mode: tile Y axis
  ///
  /// In en, this message translates to:
  /// **'Tile Y'**
  String get imgModeTileY;

  /// No description provided for @blendNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get blendNormal;

  /// No description provided for @blendMultiply.
  ///
  /// In en, this message translates to:
  /// **'Multiply'**
  String get blendMultiply;

  /// No description provided for @blendScreen.
  ///
  /// In en, this message translates to:
  /// **'Screen'**
  String get blendScreen;

  /// No description provided for @blendOverlay.
  ///
  /// In en, this message translates to:
  /// **'Overlay'**
  String get blendOverlay;

  /// No description provided for @blendDarken.
  ///
  /// In en, this message translates to:
  /// **'Darken'**
  String get blendDarken;

  /// No description provided for @blendLighten.
  ///
  /// In en, this message translates to:
  /// **'Lighten'**
  String get blendLighten;

  /// No description provided for @blendColorDodge.
  ///
  /// In en, this message translates to:
  /// **'Color Dodge'**
  String get blendColorDodge;

  /// No description provided for @blendColorBurn.
  ///
  /// In en, this message translates to:
  /// **'Color Burn'**
  String get blendColorBurn;

  /// No description provided for @blendHardLight.
  ///
  /// In en, this message translates to:
  /// **'Hard Light'**
  String get blendHardLight;

  /// No description provided for @blendSoftLight.
  ///
  /// In en, this message translates to:
  /// **'Soft Light'**
  String get blendSoftLight;

  /// No description provided for @blendDifference.
  ///
  /// In en, this message translates to:
  /// **'Difference'**
  String get blendDifference;

  /// No description provided for @blendExclusion.
  ///
  /// In en, this message translates to:
  /// **'Exclusion'**
  String get blendExclusion;

  /// No description provided for @blendHue.
  ///
  /// In en, this message translates to:
  /// **'Hue'**
  String get blendHue;

  /// No description provided for @blendSaturation.
  ///
  /// In en, this message translates to:
  /// **'Saturation'**
  String get blendSaturation;

  /// No description provided for @blendColor.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get blendColor;

  /// No description provided for @blendLuminosity.
  ///
  /// In en, this message translates to:
  /// **'Luminosity'**
  String get blendLuminosity;

  /// No description provided for @alignTopLeft.
  ///
  /// In en, this message translates to:
  /// **'Top Left'**
  String get alignTopLeft;

  /// No description provided for @alignTopCenter.
  ///
  /// In en, this message translates to:
  /// **'Top Center'**
  String get alignTopCenter;

  /// No description provided for @alignTopRight.
  ///
  /// In en, this message translates to:
  /// **'Top Right'**
  String get alignTopRight;

  /// No description provided for @alignCenterLeft.
  ///
  /// In en, this message translates to:
  /// **'Center Left'**
  String get alignCenterLeft;

  /// No description provided for @alignCenter.
  ///
  /// In en, this message translates to:
  /// **'Center'**
  String get alignCenter;

  /// No description provided for @alignCenterRight.
  ///
  /// In en, this message translates to:
  /// **'Center Right'**
  String get alignCenterRight;

  /// No description provided for @alignBottomLeft.
  ///
  /// In en, this message translates to:
  /// **'Bottom Left'**
  String get alignBottomLeft;

  /// No description provided for @alignBottomCenter.
  ///
  /// In en, this message translates to:
  /// **'Bottom Center'**
  String get alignBottomCenter;

  /// No description provided for @alignBottomRight.
  ///
  /// In en, this message translates to:
  /// **'Bottom Right'**
  String get alignBottomRight;

  /// Button to generate the ebook cover
  ///
  /// In en, this message translates to:
  /// **'Generate Cover'**
  String get btnGenerateCover;

  /// Button to clear all form fields
  ///
  /// In en, this message translates to:
  /// **'Clear Fields'**
  String get btnClearFields;

  /// Button to save the generated cover
  ///
  /// In en, this message translates to:
  /// **'Save Cover'**
  String get btnSaveCover;

  /// Validation error when title is empty
  ///
  /// In en, this message translates to:
  /// **'Ebook title is required'**
  String get validationTitleRequired;

  /// Validation error when title is too short
  ///
  /// In en, this message translates to:
  /// **'Ebook title must be at least {min} characters'**
  String validationTitleTooShort(int min);

  /// Validation error when author is empty
  ///
  /// In en, this message translates to:
  /// **'Author name is required'**
  String get validationAuthorRequired;

  /// Validation error when author name is too short
  ///
  /// In en, this message translates to:
  /// **'Author name must be at least {min} characters'**
  String validationAuthorTooShort(int min);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
