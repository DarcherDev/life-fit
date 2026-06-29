import 'package:flutter/material.dart';

import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/modules/estiramiento/models/stretching.dart';

class StretchingPreviewTile extends StatelessWidget {
  const StretchingPreviewTile({
    super.key,
    required this.item,
    this.interactive = false,
    this.isCompleted = false,
    this.onToggle,
  });

  final StretchingItem item;
  final bool interactive;
  final bool isCompleted;
  final ValueChanged<bool>? onToggle;

  static const _accentColor = Color(0xFF7C3AED);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final background = Color.alphaBlend(
      _accentColor.withOpacity(
        colorScheme.brightness == Brightness.dark ? 0.22 : 0.1,
      ),
      colorScheme.surfaceVariant,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _accentColor.withOpacity(0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (interactive)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Checkbox(
                value: isCompleted,
                activeColor: _accentColor,
                onChanged: (value) => onToggle?.call(value ?? false),
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.only(top: 2, right: 12),
              child: Icon(Icons.self_improvement, color: _accentColor, size: 20),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.description,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.stretchingRepetitionsFormat(item.repetitions),
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
