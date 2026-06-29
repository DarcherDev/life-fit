import 'package:flutter/material.dart';

import 'package:life_fit/core/widgets/app_scaffold.dart';
import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/core/services/local_storage_service.dart';
import 'package:life_fit/modules/ejercicios/models/exercise_template.dart';
import 'package:life_fit/modules/ejercicios/screens/exercise_template_form_screen.dart';
import 'package:life_fit/shared/utils/template_l10n.dart';
import 'package:life_fit/shared/widgets/confirm_dialog.dart';

class ExerciseLibraryScreen extends StatefulWidget {
  const ExerciseLibraryScreen({
    super.key,
    this.creationMode = false,
    this.returnCreatedId = false,
  });

  final bool creationMode;
  final bool returnCreatedId;

  @override
  State<ExerciseLibraryScreen> createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends State<ExerciseLibraryScreen> {
  final _storage = LocalStorageService.instance;
  List<ExerciseTemplate> _templates = [];

  @override
  void initState() {
    super.initState();
    _load();
    if (widget.creationMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _templates.isEmpty) {
          _openForm();
        }
      });
    }
  }

  void _load() {
    setState(() => _templates = _storage.getExerciseTemplates());
  }

  Future<void> _openForm({ExerciseTemplate? template}) async {
    final createdId = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => ExerciseTemplateFormScreen(template: template),
      ),
    );
    if (!mounted) {
      return;
    }

    if (widget.creationMode || widget.returnCreatedId) {
      Navigator.of(context).pop(createdId);
      return;
    }

    if (createdId != null) {
      _load();
    }
  }

  Future<void> _delete(ExerciseTemplate template) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await ConfirmDialog.show(
      context,
      title: l10n.deleteExerciseTemplateTitle,
      message: l10n.deleteExerciseTemplateMessage(template.title),
      confirmLabel: l10n.delete,
    );
    if (!confirmed) {
      return;
    }

    final deleted = await _storage.deleteExerciseTemplate(template.id);
    if (!mounted) {
      return;
    }
    if (!deleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.templateInUseMessage)),
      );
      return;
    }
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final hideFab = widget.creationMode && _templates.isEmpty;

    return AppScaffold(
      title: l10n.exerciseLibraryTitle,
      floatingActionButton: hideFab
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _openForm(),
              icon: const Icon(Icons.add),
              label: Text(l10n.newExerciseTemplate),
            ),
      body: _templates.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.exerciseLibraryEmpty,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _templates.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final template = _templates[index];
                return Card(
                  child: ListTile(
                    title: Text(template.title),
                    subtitle: Text(template.localizedSubtitle(l10n)),
                    onTap: () => _openForm(template: template),
                    onLongPress: () => _delete(template),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _delete(template),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
