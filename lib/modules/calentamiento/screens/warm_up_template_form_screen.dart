import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/core/services/local_storage_service.dart';
import 'package:life_fit/modules/calentamiento/models/warm_up_template.dart';

class WarmUpTemplateFormScreen extends StatefulWidget {
  const WarmUpTemplateFormScreen({super.key, this.template});

  final WarmUpTemplate? template;

  @override
  State<WarmUpTemplateFormScreen> createState() =>
      _WarmUpTemplateFormScreenState();
}

class _WarmUpTemplateFormScreenState extends State<WarmUpTemplateFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storage = LocalStorageService.instance;
  final _descriptionController = TextEditingController();
  final _minutesController = TextEditingController();
  final _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    final template = widget.template;
    if (template != null) {
      _descriptionController.text = template.description;
      _minutesController.text = template.minutes.toString();
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _minutesController.dispose();
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

    final minutes = _parsePositiveInt(_minutesController.text);
    if (minutes == null) {
      return;
    }

    final template = WarmUpTemplate(
      id: widget.template?.id ?? _uuid.v4(),
      description: _descriptionController.text.trim(),
      minutes: minutes,
    );

    await _storage.upsertWarmUpTemplate(template);
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
          isEditing ? l10n.editWarmUpTemplate : l10n.newWarmUpTemplate,
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
                labelText: l10n.warmUpDescriptionLabel,
                hintText: l10n.warmUpDescriptionHint,
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
              controller: _minutesController,
              decoration: InputDecoration(
                labelText: l10n.warmUpMinutesLabel,
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
