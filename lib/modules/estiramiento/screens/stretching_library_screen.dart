import 'package:flutter/material.dart';

import 'package:life_fit/core/widgets/app_scaffold.dart';
import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/core/services/local_storage_service.dart';
import 'package:life_fit/modules/estiramiento/models/stretching_template.dart';
import 'package:life_fit/modules/estiramiento/screens/stretching_template_form_screen.dart';
import 'package:life_fit/shared/widgets/confirm_dialog.dart';

class StretchingLibraryScreen extends StatefulWidget {
  const StretchingLibraryScreen({super.key});

  @override
  State<StretchingLibraryScreen> createState() =>
      _StretchingLibraryScreenState();
}

class _StretchingLibraryScreenState extends State<StretchingLibraryScreen> {
  final _storage = LocalStorageService.instance;
  List<StretchingTemplate> _templates = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    setState(() => _templates = _storage.getStretchingTemplates());
  }

  Future<void> _openForm({StretchingTemplate? template}) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => StretchingTemplateFormScreen(template: template),
      ),
    );
    if (saved == true) {
      _load();
    }
  }

  Future<void> _delete(StretchingTemplate template) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await ConfirmDialog.show(
      context,
      title: l10n.deleteStretchingTemplateTitle,
      message: l10n.deleteStretchingTemplateMessage(template.description),
      confirmLabel: l10n.delete,
    );
    if (!confirmed) {
      return;
    }

    final deleted = await _storage.deleteStretchingTemplate(template.id);
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

    return AppScaffold(
      title: l10n.stretchingLibraryTitle,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: Text(l10n.newStretchingTemplate),
      ),
      body: _templates.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.stretchingLibraryEmpty,
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
                    title: Text(template.description),
                    subtitle: Text(
                      l10n.stretchingRepetitionsFormat(template.repetitions),
                    ),
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
