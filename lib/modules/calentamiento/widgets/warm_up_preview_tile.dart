import 'package:flutter/material.dart';

import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/modules/calentamiento/models/warm_up.dart';

class WarmUpPreviewTile extends StatelessWidget {
  const WarmUpPreviewTile({
    super.key,
    required this.warmUp,
    this.interactive = false,
    this.isCompleted = false,
    this.onToggle,
    this.onReplace,
    this.onEdit,
  });

  final WarmUp warmUp;
  final bool interactive;
  final bool isCompleted;
  final ValueChanged<bool>? onToggle;
  final VoidCallback? onReplace;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final accentColor = colorScheme.tertiary;
    final background = Color.alphaBlend(
      accentColor.withOpacity(
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
        border: Border.all(color: accentColor.withOpacity(0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: interactive && onToggle != null
                    ? () => onToggle!(!isCompleted)
                    : null,
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (interactive)
                      AbsorbPointer(
                        child: Checkbox(
                          value: isCompleted,
                          activeColor: accentColor,
                          onChanged: (_) {},
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(top: 2, right: 12),
                        child: Icon(
                          Icons.local_fire_department,
                          color: accentColor,
                          size: 20,
                        ),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.warmUpTitle,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: accentColor,
                              decoration:
                                  isCompleted ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            warmUp.description,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              decoration:
                                  isCompleted ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.warmUpMinutesFormat(warmUp.minutes),
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              decoration:
                                  isCompleted ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (onReplace != null || onEdit != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onReplace != null)
                  IconButton(
                    onPressed: onReplace,
                    icon: const Icon(Icons.swap_horiz, size: 20),
                    tooltip: l10n.changeWarmUp,
                    visualDensity: VisualDensity.compact,
                  ),
                if (onEdit != null)
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    tooltip: l10n.editWarmUpTemplate,
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
