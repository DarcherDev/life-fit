import 'package:flutter/material.dart';

import 'package:life_fit/core/services/locale_service.dart';
import 'package:life_fit/l10n/app_localizations.dart';

/// Muestra un diálogo de idioma la primera vez si el dispositivo no es es/en.
class LocalePromptHost extends StatefulWidget {
  const LocalePromptHost({super.key, required this.child});

  final Widget child;

  @override
  State<LocalePromptHost> createState() => _LocalePromptHostState();
}

class _LocalePromptHostState extends State<LocalePromptHost> {
  final _localeService = LocaleService.instance;
  bool _promptScheduled = false;

  @override
  void initState() {
    super.initState();
    _localeService.addListener(_onLocaleChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowPrompt());
  }

  @override
  void dispose() {
    _localeService.removeListener(_onLocaleChanged);
    super.dispose();
  }

  void _onLocaleChanged() {
    if (_localeService.hasStoredLocale && mounted) {
      setState(() {});
    }
  }

  void _maybeShowPrompt() {
    if (!mounted || _promptScheduled || _localeService.hasStoredLocale) {
      return;
    }

    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
    if (!_localeService.needsLocalePrompt(deviceLocale)) {
      return;
    }

    _promptScheduled = true;
    _showLocalePrompt();
  }

  Future<void> _showLocalePrompt() async {
    if (!mounted) {
      return;
    }

    final l10n = AppLocalizations.of(context);

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.localePromptTitle),
          content: Text(l10n.localePromptMessage),
          actions: [
            TextButton(
              onPressed: () async {
                await _localeService.setLocale(const Locale('es'));
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: Text(l10n.languageSpanish),
            ),
            FilledButton(
              onPressed: () async {
                await _localeService.setLocale(const Locale('en'));
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: Text(l10n.languageEnglish),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
