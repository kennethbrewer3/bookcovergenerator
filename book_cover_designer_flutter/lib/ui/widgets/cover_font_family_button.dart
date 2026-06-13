import 'package:book_cover_designer_flutter/services/cover_font_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Font family picker styled like [QuillToolbarFontSizeButton].
class CoverFontFamilyButton extends StatefulWidget {
  const CoverFontFamilyButton({
    required this.controller,
    required this.items,
    required this.defaultLabel,
    this.iconSize = kDefaultIconSize,
    this.iconButtonFactor = kDefaultIconButtonFactor,
    this.toolbarHeight = kDefaultToolbarSize,
    super.key,
  });

  final QuillController controller;
  final Map<String, String> items;
  final String defaultLabel;
  final double iconSize;
  final double iconButtonFactor;
  final double toolbarHeight;

  @override
  State<CoverFontFamilyButton> createState() => _CoverFontFamilyButtonState();
}

class _CoverFontFamilyButtonState extends State<CoverFontFamilyButton> {
  final _menuController = MenuController();

  String? _displayNameForKey(String? fontKey) {
    if (fontKey == null) return null;
    for (final entry in widget.items.entries) {
      if (entry.value == fontKey) return entry.key;
    }
    return null;
  }

  String? _currentFontKey() {
    final attribute =
        widget.controller.getSelectionStyle().attributes[Attribute.font.key];
    final value = attribute?.value;
    return value is String && value.isNotEmpty ? value : null;
  }

  double get _labelFontSize => widget.iconSize / 1.15;

  TextStyle _labelStyle(BuildContext context, String? fontKey) {
    final base = TextStyle(fontSize: _labelFontSize);
    if (fontKey == null) return base;
    return CoverFontPreview.textStyle(
      fontKey: fontKey,
      base: base,
      clearColor: Theme.of(context).colorScheme.error,
    );
  }

  TextStyle _menuItemStyle(BuildContext context, String fontKey) {
    return CoverFontPreview.textStyle(
      fontKey: fontKey,
      base: TextStyle(fontSize: _labelFontSize),
      clearColor: Theme.of(context).colorScheme.error,
    );
  }

  void _toggleMenu() {
    if (_menuController.isOpen) {
      _menuController.close();
    } else {
      _menuController.open();
    }
  }

  void _selectFont(String fontKey) {
    widget.controller.formatSelection(
      Attribute.fromKeyValue(
        Attribute.font.key,
        fontKey == 'Clear' ? null : fontKey,
      ),
    );
    _menuController.close();
  }

  @override
  Widget build(BuildContext context) {
    final currentKey = _currentFontKey();
    final currentLabel = _displayNameForKey(currentKey) ?? widget.defaultLabel;

    return SizedBox(
      height: widget.toolbarHeight,
      child: MenuAnchor(
        controller: _menuController,
        menuChildren: [
          for (final entry in widget.items.entries)
            MenuItemButton(
              key: ValueKey(entry.key),
              onPressed: () => _selectFont(entry.value),
              child: Text(
                entry.key,
                style: _menuItemStyle(context, entry.value),
              ),
            ),
        ],
        child: QuillToolbarIconButton(
          isSelected: false,
          iconTheme: null,
          tooltip: FlutterQuillLocalizations.of(context)?.fontFamily ?? 'Font',
          onPressed: _toggleMenu,
          icon: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 120),
                  child: Text(
                    currentLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _labelStyle(context, currentKey),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  size: widget.iconSize * widget.iconButtonFactor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
