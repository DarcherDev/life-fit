import 'package:flutter/material.dart';

import 'package:life_fit/core/import_export/routine_import_service.dart';
import 'package:life_fit/core/repositories/app_repositories.dart';
import 'package:life_fit/core/services/personal_profile_service.dart';
import 'package:life_fit/core/services/weight_unit_service.dart';
import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/shared/widgets/app_popup_dialog.dart';

class ImportRoutinesDialog {
  ImportRoutinesDialog._();

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => const _ImportRoutinesDialogBody(),
    );
  }
}

class _ImportRoutinesDialogBody extends StatefulWidget {
  const _ImportRoutinesDialogBody();

  @override
  State<_ImportRoutinesDialogBody> createState() =>
      _ImportRoutinesDialogBodyState();
}

class _ImportRoutinesDialogBodyState extends State<_ImportRoutinesDialogBody> {
  final _controller = TextEditingController();
  bool _importing = false;
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _confirmAndImport() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (confirmContext) => AlertDialog(
        title: Text(l10n.importRoutinesConfirmTitle),
        content: Text(l10n.importRoutinesConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(confirmContext).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(confirmContext).pop(true),
            child: Text(l10n.importRoutinesConfirmAction),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) {
      return;
    }

    setState(() {
      _importing = true;
      _errorText = null;
    });

    final messenger = ScaffoldMessenger.maybeOf(context);
    final successMessage = l10n.importRoutinesSuccess;
    final rootNavigator = Navigator.of(context);

    try {
      await RoutineImportService(
        repositories: AppRepositories.instance,
        profileReader: () => PersonalProfileService.instance.profile,
        saveProfile: PersonalProfileService.instance.saveProfile,
        saveWeightUnit: WeightUnitService.instance.setUnit,
      ).importJsonString(_controller.text);

      if (!mounted) {
        return;
      }
      rootNavigator.pop();
      messenger?.showSnackBar(SnackBar(content: Text(successMessage)));
    } on RoutineImportException catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _importing = false;
        _errorText = _mapError(l10n, error.message);
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _importing = false;
        _errorText = l10n.importRoutinesErrorGeneric;
      });
    }
  }

  String _mapError(AppLocalizations l10n, String code) {
    switch (code) {
      case 'empty':
        return l10n.importRoutinesErrorEmpty;
      case 'invalid_json':
        return l10n.importRoutinesErrorInvalidJson;
      case 'unsupported_schema':
        return l10n.importRoutinesErrorSchema;
      default:
        return l10n.importRoutinesErrorGeneric;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return AppPopupDialog(
      title: l10n.importRoutinesTitle,
      actions: [
        if (_importing)
          const Padding(
            padding: EdgeInsets.all(12),
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        else
          IconButton(
            onPressed: _confirmAndImport,
            icon: const Icon(Icons.check, color: Colors.green),
            tooltip: l10n.importRoutinesAction,
          ),
      ],
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.importRoutinesDescription,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: l10n.importRoutinesHint,
                  border: const OutlineInputBorder(),
                  errorText: _errorText,
                  alignLabelWithHint: true,
                ),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
