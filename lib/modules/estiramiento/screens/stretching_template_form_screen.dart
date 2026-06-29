import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/core/services/local_storage_service.dart';
import 'package:life_fit/modules/estiramiento/models/stretching_template.dart';

class StretchingTemplateFormScreen extends StatefulWidget {
  const StretchingTemplateFormScreen({super.key, this.template});

  final StretchingTemplate? template;

  @override
  State<StretchingTemplateFormScreen> createState() =>
      _StretchingTemplateFormScreenState();
}

class _StretchingTemplateFormScreenState
    extends State<StretchingTemplateFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storage = LocalStorageService.instance;
  final _descriptionController = TextEditingController();
  final _repetitionsController = TextEditingController();
  final _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    final template = widget.template;
    if (template != null) {
      _descriptionController.text = template.description;
      _repetitionsController.text = template.repetitions.toString();
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _repetitionsController.dispose();
    super.dispose();
  }

  int? _parsePositiveInt(String value) {
    final parsed = int.tryParse(value.trim());
    if (parsed == null || parsed <= 0) {
      return null;
    }
    return parsed;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final repetitions = _parsePositiveInt(_repetitionsController.text);
    if (repetitions == null) {
      return;
    }

    final template = StretchingTemplate(
      id: widget.template?.id ?? _uuid.v4(),
      description: _descriptionController.text.trim(),
      repetitions: repetitions,
    );

    await _storage.upsertStretchingTemplate(template);
    if (mounted) {
      Navigator.of(context).pop(template.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEditing = widget.template != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? l10n.editStretchingTemplate : l10n.newStretchingTemplate,
        ),
        actions: [
          IconButton(
            onPressed: _save,
            icon: const Icon(Icons.check),
            tooltip: l10n.save,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: l10n.stretchingDescriptionHint,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.required;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _repetitionsController,
              decoration: InputDecoration(
                labelText: l10n.stretchingRepetitionsLabel,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.required;
                }
                if (_parsePositiveInt(value) == null) {
                  return l10n.validNumber;
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }
}
