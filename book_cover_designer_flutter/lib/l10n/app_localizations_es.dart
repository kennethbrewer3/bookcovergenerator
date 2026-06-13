// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Diseñador de Portadas';

  @override
  String get themeSelectTooltip => 'Seleccionar tema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeMilitaryLight => 'Militar Claro';

  @override
  String get themeMilitaryDark => 'Militar Oscuro';

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get settingsTooltip => 'Configuración';

  @override
  String get settingsAppearanceSection => 'Apariencia';

  @override
  String get settingsLanguageSection => 'Idioma';

  @override
  String get settingsFontsSection => 'Fuentes personalizadas';

  @override
  String get settingsFontsDescription =>
      'Importe archivos .ttf u .otf para usar fuentes adicionales en el texto de la portada. Las fuentes se guardan localmente en este dispositivo.';

  @override
  String get settingsFontsEmpty =>
      'Aún no se han importado fuentes personalizadas.';

  @override
  String get settingsAddFont => 'Importar archivos de fuente';

  @override
  String get settingsFontImportSuccess => 'Archivos de fuente importados.';

  @override
  String settingsFontImportFailed(String fileNames) {
    return 'No se pudo importar: $fileNames';
  }

  @override
  String get settingsRemoveFontTitle => '¿Eliminar fuente?';

  @override
  String settingsRemoveFontMessage(String name) {
    return '¿Eliminar \"$name\" de sus fuentes personalizadas?';
  }

  @override
  String get settingsRemoveFontTooltip => 'Eliminar fuente';

  @override
  String get settingsFontCustomLabel => 'Fuente personalizada';

  @override
  String get settingsCancel => 'Cancelar';

  @override
  String get settingsRemove => 'Eliminar';

  @override
  String get fontClear => 'Borrar';

  @override
  String get sectionBackground => 'Color e imagen de fondo';

  @override
  String get sectionTitle => 'Título';

  @override
  String get sectionAuthor => 'Autor';

  @override
  String get sectionSubtitle => 'Subtítulo';

  @override
  String get sectionTagline => 'Eslogan';

  @override
  String get sectionSeries => 'Título de serie';

  @override
  String get sectionEdition => 'Edición';

  @override
  String get sectionBadge => 'Insignia de esquina';

  @override
  String get sectionLayout => 'Diseño de portada';

  @override
  String get sectionActions => 'Acciones';

  @override
  String get fieldEbookTitle => 'Título del libro';

  @override
  String get fieldAuthorName => 'Nombre del autor';

  @override
  String get fieldSubtitle => 'Subtítulo';

  @override
  String get fieldTagline => 'Eslogan';

  @override
  String get fieldSeriesTitle => 'Título de serie';

  @override
  String get fieldEditionLine => 'Línea de edición';

  @override
  String get fieldCornerBadge => 'Insignia de esquina';

  @override
  String get colorBackground => 'Color de fondo';

  @override
  String get colorTitleBox => 'Color de caja';

  @override
  String get colorTitleBorder => 'Color de borde';

  @override
  String get colorAuthorText => 'Color de texto del autor';

  @override
  String get colorAuthorBox => 'Color de caja del autor';

  @override
  String get colorAuthorBorder => 'Color de borde del autor';

  @override
  String get colorSubtitleText => 'Color de texto del subtítulo';

  @override
  String get colorSubtitleBox => 'Color de caja del subtítulo';

  @override
  String get colorSubtitleBorder => 'Color de borde del subtítulo';

  @override
  String get colorTaglineText => 'Color de texto del eslogan';

  @override
  String get colorTaglineBox => 'Color de caja del eslogan';

  @override
  String get colorTaglineBorder => 'Color de borde del eslogan';

  @override
  String get colorSeriesTitleText => 'Color de texto de serie';

  @override
  String get colorSeriesTitleBox => 'Color de caja de serie';

  @override
  String get colorSeriesTitleBorder => 'Color de borde de serie';

  @override
  String get colorEditionLineText => 'Color de texto de edición';

  @override
  String get colorEditionLineBox => 'Color de caja de edición';

  @override
  String get colorEditionLineBorder => 'Color de borde de edición';

  @override
  String get colorBadgeText => 'Color de texto de insignia';

  @override
  String get colorBadge => 'Color de insignia';

  @override
  String get colorBadgeBorder => 'Color de borde de insignia';

  @override
  String get colorPickerShadeSubheading => 'Seleccionar tono';

  @override
  String get coverSizeLabel => 'Tamaño de portada';

  @override
  String get backgroundImageMode => 'Modo de imagen de fondo';

  @override
  String get backgroundImageAlignment => 'Alineación de imagen de fondo';

  @override
  String get backgroundImageScaleX => 'Escala X de imagen de fondo';

  @override
  String get backgroundImageScaleY => 'Escala Y de imagen de fondo';

  @override
  String get backgroundMixMode => 'Modo de mezcla de fondo';

  @override
  String get backgroundImageOpacity => 'Opacidad de imagen de fondo';

  @override
  String get btnChooseBackgroundColor => 'Elegir color de fondo';

  @override
  String get btnChooseBackgroundImage => 'Elegir imagen de fondo';

  @override
  String get btnClearImage => 'Borrar imagen';

  @override
  String get sliderTitleTopOffset => 'Desplazamiento superior del título';

  @override
  String get sliderTitleHorizontalOffset =>
      'Desplazamiento horizontal del título';

  @override
  String get sliderAuthorTopOffset => 'Desplazamiento superior del autor';

  @override
  String get sliderAuthorLeftOffset => 'Desplazamiento izquierdo del autor';

  @override
  String get sliderSubtitleTopOffset => 'Desplazamiento superior del subtítulo';

  @override
  String get sliderSubtitleLeftOffset =>
      'Desplazamiento izquierdo del subtítulo';

  @override
  String get sliderTaglineTopOffset => 'Desplazamiento superior del eslogan';

  @override
  String get sliderTaglineLeftOffset => 'Desplazamiento izquierdo del eslogan';

  @override
  String get sliderSeriesTitleTopOffset => 'Desplazamiento superior de serie';

  @override
  String get sliderSeriesTitleLeftOffset => 'Desplazamiento izquierdo de serie';

  @override
  String get sliderEditionLineTopOffset => 'Desplazamiento superior de edición';

  @override
  String get sliderEditionLineLeftOffset =>
      'Desplazamiento izquierdo de edición';

  @override
  String get sliderTopBottomTopOffset => 'Desplazamiento superior/inferior';

  @override
  String get sliderTopCenterTopOffset => 'Desplazamiento superior/centro';

  @override
  String get layoutModern => 'Moderno';

  @override
  String get layoutTopBottom => 'Superior / Inferior';

  @override
  String get layoutTopCenter => 'Superior / Centro';

  @override
  String get layoutModernTooltip => 'Diseño con título grande centrado';

  @override
  String get layoutTopBottomTooltip => 'Título arriba, autor abajo';

  @override
  String get layoutTopCenterTooltip => 'Autor arriba, título centrado';

  @override
  String get badgePositionTopLeft => 'Arriba izquierda';

  @override
  String get badgePositionTopRight => 'Arriba derecha';

  @override
  String get badgePositionBottomLeft => 'Abajo izquierda';

  @override
  String get badgePositionBottomRight => 'Abajo derecha';

  @override
  String get imgModeCover => 'Cubrir';

  @override
  String get imgModeFit => 'Ajustar';

  @override
  String get imgModeStretch => 'Estirar';

  @override
  String get imgModeCenter => 'Centrar';

  @override
  String get imgModeTileXY => 'Mosaico X e Y';

  @override
  String get imgModeTileX => 'Mosaico X';

  @override
  String get imgModeTileY => 'Mosaico Y';

  @override
  String get blendNormal => 'Normal';

  @override
  String get blendMultiply => 'Multiplicar';

  @override
  String get blendScreen => 'Pantalla';

  @override
  String get blendOverlay => 'Superposición';

  @override
  String get blendDarken => 'Oscurecer';

  @override
  String get blendLighten => 'Aclarar';

  @override
  String get blendColorDodge => 'Subexposición de color';

  @override
  String get blendColorBurn => 'Sobreexposición de color';

  @override
  String get blendHardLight => 'Luz fuerte';

  @override
  String get blendSoftLight => 'Luz suave';

  @override
  String get blendDifference => 'Diferencia';

  @override
  String get blendExclusion => 'Exclusión';

  @override
  String get blendHue => 'Tono';

  @override
  String get blendSaturation => 'Saturación';

  @override
  String get blendColor => 'Color';

  @override
  String get blendLuminosity => 'Luminosidad';

  @override
  String get alignTopLeft => 'Arriba izquierda';

  @override
  String get alignTopCenter => 'Arriba centro';

  @override
  String get alignTopRight => 'Arriba derecha';

  @override
  String get alignCenterLeft => 'Centro izquierda';

  @override
  String get alignCenter => 'Centro';

  @override
  String get alignCenterRight => 'Centro derecha';

  @override
  String get alignBottomLeft => 'Abajo izquierda';

  @override
  String get alignBottomCenter => 'Abajo centro';

  @override
  String get alignBottomRight => 'Abajo derecha';

  @override
  String get btnGenerateCover => 'Generar portada';

  @override
  String get btnClearFields => 'Limpiar campos';

  @override
  String get btnSaveCover => 'Guardar portada';

  @override
  String get validationTitleRequired => 'El título del libro es obligatorio';

  @override
  String validationTitleTooShort(int min) {
    return 'El título debe tener al menos $min caracteres';
  }

  @override
  String get validationAuthorRequired => 'El nombre del autor es obligatorio';

  @override
  String validationAuthorTooShort(int min) {
    return 'El nombre del autor debe tener al menos $min caracteres';
  }
}
