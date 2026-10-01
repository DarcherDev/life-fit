import 'package:flutter/material.dart';

import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/modules/calentamiento/models/warm_up_placement.dart';

/// Pregunta si un calentamiento va al inicio o al final de la rutina.
class WarmUpPlacementDialog {
  /// [startOccupiedBy] / [endOccupiedBy]: nombre del calentamiento que se
  /// reemplazaría en esa posición. Devuelve `null` si se cancela.
  static Future<WarmUpPlacement?> show(
    BuildContext context, {
    String? startOccupiedBy,
    String? endOccupiedBy,
  }) {
    return showDialog<WarmUpPlacement>(
      context: context,
      builder: (dialogContext) {
        final l10n = AppLocalizations.of(dialogContext);

        Widget option({
          required WarmUpPlacement placement,
          required IconData icon,
          required String label,
          String? occupiedBy,
        }) {
          return ListTile(
            leading: Icon(icon),
            title: Text(label),
            subtitle: occupiedBy == null
                ? null
                : Text(l10n.warmUpReplacesFormat(occupiedBy)),
            onTap: () => Navigator.of(dialogContext).pop(placement),
          );
        }

        return SimpleDialog(
          title: Text(l10n.warmUpPlacementTitle),
          children: [
            option(
              placement: WarmUpPlacement.start,
              icon: Icons.vertical_align_top,
              label: l10n.warmUpPlacementStart,
              occupiedBy: startOccupiedBy,
            ),
            option(
              placement: WarmUpPlacement.end,
              icon: Icons.vertical_align_bottom,
              label: l10n.warmUpPlacementEnd,
              occupiedBy: endOccupiedBy,
            ),
          ],
        );
      },
    );
  }
}
