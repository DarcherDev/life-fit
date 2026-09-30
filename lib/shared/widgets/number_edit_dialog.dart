import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:life_fit/l10n/app_localizations.dart';

/// Diálogo genérico para editar un único valor entero positivo.
class NumberEditDialog {
  /// Devuelve el valor nuevo o `null` si se cancela.
  static Future<int?> show(
    BuildContext context, {
    required String title,
    required String itemName,
    required String label,
    required int initialValue,
  }) {
    return showDialog<int>(
      context: context,
      builder: (dialogContext) => _NumberEditDialog(
        title: title,
        itemName: itemName,
        label: label,
        initialValue: initialValue,
      ),
    );
  }
}

class _NumberEditDialog extends StatefulWidget {
  const _NumberEditDialog({
    required this.title,
    required this.itemName,
    required this.label,
    required this.initialValue,
  });

  final String title;
  final String itemName;
  final String label;
  final int initialValue;

  @override
  State<_NumberEditDialog> createState() => _NumberEditDialogState();
}

class _NumberEditDialogState extends State<_NumberEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue > 0 ? widget.initialValue.toString() : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int? _parsePositiveInt(String value) {
    final parsed = int.tryParse(value.trim());
    if (parsed == null || parsed <= 0) {
      return null;
    }
    return parsed;
  }

  String? _validate(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.required;
    }
    if (_parsePositiveInt(value) == null) {
      return l10n.validNumber;
    }
    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    Navigator.of(context).pop(_parsePositiveInt(_controller.text));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.itemName,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                labelText: widget.label,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) => _validate(value, l10n),
              onFieldSubmitted: (_) => _save(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _save,
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
