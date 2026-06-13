import 'package:book_cover_designer_flutter/app/app_services.dart';
import 'package:book_cover_designer_flutter/l10n/app_localizations.dart';
import 'package:book_cover_designer_flutter/models/custom_font.dart';
import 'package:book_cover_designer_flutter/services/locale_service.dart';
import 'package:book_cover_designer_flutter/ui/theme/app_text_styles.dart';
import 'package:book_cover_designer_flutter/ui/theme/app_theme.dart';
import 'package:book_cover_designer_flutter/ui/theme/app_tokens.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _importingFonts = false;

  String _themeLabel(AppLocalizations l10n, AppThemeVariant variant) {
    return switch (variant) {
      AppThemeVariant.light => l10n.themeLight,
      AppThemeVariant.dark => l10n.themeDark,
      AppThemeVariant.militaryLight => l10n.themeMilitaryLight,
      AppThemeVariant.militaryDark => l10n.themeMilitaryDark,
    };
  }

  Future<void> _importFonts(AppLocalizations l10n) async {
    setState(() => _importingFonts = true);
    try {
      final countBefore = customFontService.fonts.value.length;
      final error = await customFontService.importFonts();
      if (!mounted) return;
      final imported = customFontService.fonts.value.length - countBefore;
      if (imported > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settingsFontImportSuccess)),
        );
      }
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settingsFontImportFailed(error))),
        );
      }
    } finally {
      if (mounted) setState(() => _importingFonts = false);
    }
  }

  Future<void> _confirmRemoveFont(
    BuildContext context,
    AppLocalizations l10n,
    CustomFont font,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsRemoveFontTitle),
        content: Text(l10n.settingsRemoveFontMessage(font.displayName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.settingsCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.settingsRemove),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    await customFontService.removeFont(font);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _SectionHeader(title: l10n.settingsAppearanceSection),
          Card(
            child: ValueListenableBuilder<AppThemeVariant>(
              valueListenable: themeService.variant,
              builder: (context, current, _) {
                return Column(
                  children: [
                    for (final variant in AppThemeVariant.values)
                      RadioListTile<AppThemeVariant>(
                        title: Text(_themeLabel(l10n, variant)),
                        value: variant,
                        groupValue: current,
                        onChanged: (value) {
                          if (value != null) themeService.setVariant(value);
                        },
                      ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionHeader(title: l10n.settingsLanguageSection),
          Card(
            child: ValueListenableBuilder<Locale>(
              valueListenable: localeService.locale,
              builder: (context, currentLocale, _) {
                return Column(
                  children: [
                    for (final option in AppLocaleOption.all)
                      RadioListTile<Locale>(
                        title: Text('${option.flag}  ${option.label}'),
                        value: option.locale,
                        groupValue: currentLocale,
                        onChanged: (value) {
                          if (value != null) localeService.setLocale(value);
                        },
                      ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionHeader(title: l10n.settingsFontsSection),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.settingsFontsDescription,
                    style: AppTextStyles.bodyMuted(context),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ValueListenableBuilder(
                    valueListenable: customFontService.fonts,
                    builder: (context, customFonts, _) {
                      if (customFonts.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.sm,
                          ),
                          child: Text(
                            l10n.settingsFontsEmpty,
                            style: AppTextStyles.caption(context),
                          ),
                        );
                      }

                      return Column(
                        children: [
                          for (final font in customFonts)
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                font.displayName,
                                style: TextStyle(fontFamily: font.fontKey),
                              ),
                              subtitle: Text(
                                l10n.settingsFontCustomLabel,
                                style: AppTextStyles.caption(context),
                              ),
                              trailing: IconButton(
                                tooltip: l10n.settingsRemoveFontTooltip,
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: scheme.error,
                                ),
                                onPressed: () =>
                                    _confirmRemoveFont(context, l10n, font),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  FilledButton.icon(
                    onPressed: _importingFonts
                        ? null
                        : () => _importFonts(l10n),
                    icon: _importingFonts
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: scheme.onPrimary,
                            ),
                          )
                        : const Icon(Icons.upload_file_outlined),
                    label: Text(l10n.settingsAddFont),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.xs,
        bottom: AppSpacing.sm,
      ),
      child: Text(title, style: AppTextStyles.h3(context)),
    );
  }
}
