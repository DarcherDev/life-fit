import 'package:flutter/material.dart';

import 'package:life_fit/core/profile/widgets/my_process_form.dart';
import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/shared/widgets/app_popup_dialog.dart';

class MyProcessDialog {
  MyProcessDialog._();

  static Future<void> show(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final formKey = GlobalKey<MyProcessFormState>();

    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AppPopupDialog(
        title: l10n.myProcessTitle,
        actions: [
          IconButton(
            onPressed: () async {
              final saved = await formKey.currentState?.save() ?? false;
              if (!dialogContext.mounted || !saved) {
                return;
              }
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.profileSaved)),
                );
              }
              Navigator.of(dialogContext).pop();
            },
            icon: const Icon(Icons.check, color: Colors.green),
            tooltip: l10n.save,
          ),
        ],
        child: MyProcessForm(key: formKey),
      ),
    );
  }
}
