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
  });

  final WarmUp warmUp;
  final bool interactive;
  final bool isCompleted;
  final ValueChanged<bool>? onToggle;

  static const _accentColor = Color(0xFFEA580C);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
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
              child: Icon(Icons.local_fire_department, color: _accentColor, size: 20),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.warmUpTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: _accentColor,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  warmUp.description,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.warmUpMinutesFormat(warmUp.minutes),
                  style: TextStyle(
                    color: Colors.grey.shade700,
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
