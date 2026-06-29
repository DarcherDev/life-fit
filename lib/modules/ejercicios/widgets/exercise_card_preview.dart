import 'package:flutter/material.dart';

import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/modules/calentamiento/models/warm_up.dart';
import 'package:life_fit/modules/calentamiento/models/warm_up_placement.dart';
import 'package:life_fit/modules/calentamiento/widgets/warm_up_preview_tile.dart';
import 'package:life_fit/shared/models/checklist_item.dart';
import 'package:life_fit/shared/models/routine_card.dart';
import 'package:life_fit/shared/utils/checklist_l10n.dart';

/// Vista previa de una tarjeta del módulo **Ejercicios** (con calentamiento opcional).
class ExerciseCardPreview extends StatelessWidget {
  const ExerciseCardPreview({
    super.key,
    required this.routine,
    this.completedItemIds = const {},
    this.interactive = false,
    this.onItemToggle,
    this.compact = false,
  });

  final RoutineCard routine;
  final Set<String> completedItemIds;
  final bool interactive;
  final void Function(String itemId, bool completed)? onItemToggle;
  final bool compact;

  static const _accentColor = Color(0xFF16A34A);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final warmUp = routine.warmUp;
    final showWarmUpAtStart =
        warmUp != null && routine.warmUpPlacement == WarmUpPlacement.start;
    final showWarmUpAtEnd =
        warmUp != null && routine.warmUpPlacement == WarmUpPlacement.end;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 4,
            color: _accentColor,
          ),
          Padding(
            padding: EdgeInsets.all(compact ? 16 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  routine.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                ),
                if (routine.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    routine.description,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: _accentColor,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                        ),
                  ),
                ],
                if (showWarmUpAtStart) ...[
                  SizedBox(height: compact ? 12 : 16),
                  _buildWarmUpTile(warmUp),
                ],
                if (routine.items.isNotEmpty) ...[
                  SizedBox(height: compact ? 12 : 16),
                  ...routine.items.map((item) => _buildItem(context, item, l10n)),
                ],
                if (showWarmUpAtEnd) ...[
                  SizedBox(height: compact ? 12 : 16),
                  _buildWarmUpTile(warmUp),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarmUpTile(WarmUp warmUp) {
    return WarmUpPreviewTile(
      warmUp: warmUp,
      interactive: interactive,
      isCompleted: completedItemIds.contains(warmUpProgressItemId),
      onToggle: onItemToggle == null
          ? null
          : (completed) => onItemToggle!(warmUpProgressItemId, completed),
    );
  }

  Widget _buildItem(
    BuildContext context,
    ChecklistItem item,
    AppLocalizations l10n,
  ) {
    final isCompleted = completedItemIds.contains(item.id);
    final subtitle = item.localizedSubtitle(l10n);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
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
                onChanged: (value) {
                  onItemToggle?.call(item.id, value ?? false);
                },
              ),
            )
          else
            Container(
              width: 18,
              height: 18,
              margin: const EdgeInsets.only(top: 3, right: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400, width: 2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    decoration:
                        isCompleted ? TextDecoration.lineThrough : null,
                    color: isCompleted ? Colors.grey : Colors.black87,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      decoration:
                          isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
