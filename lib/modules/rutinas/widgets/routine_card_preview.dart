import 'package:flutter/material.dart';

import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/modules/calentamiento/models/warm_up.dart';
import 'package:life_fit/shared/utils/template_l10n.dart';
import 'package:life_fit/modules/calentamiento/models/warm_up_placement.dart';
import 'package:life_fit/modules/calentamiento/widgets/warm_up_preview_tile.dart';
import 'package:life_fit/modules/estiramiento/models/stretching.dart';
import 'package:life_fit/modules/estiramiento/widgets/stretching_preview_tile.dart';
import 'package:life_fit/shared/models/resolved_routine.dart';

class RoutineCardPreview extends StatelessWidget {
  const RoutineCardPreview({
    super.key,
    required this.routine,
    this.completedItemIds = const {},
    this.interactive = false,
    this.onItemToggle,
    this.onExerciseWeightEdit,
    this.compact = false,
  });

  final ResolvedRoutine routine;
  final Set<String> completedItemIds;
  final bool interactive;
  final void Function(String itemId, bool completed)? onItemToggle;
  final void Function(ResolvedExercise exercise)? onExerciseWeightEdit;
  final bool compact;

  static const _accentColor = Color(0xFF16A34A);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final warmUp = routine.warmUp;
    final showWarmUpAtStart =
        warmUp != null && routine.warmUpPlacement == WarmUpPlacement.start;
    final showWarmUpAtEnd =
        warmUp != null && routine.warmUpPlacement == WarmUpPlacement.end;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(height: 4, color: _accentColor),
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
                if (routine.hasMissingItems) ...[
                  const SizedBox(height: 8),
                  Text(
                    l10n.missingTemplateWarning,
                    style: TextStyle(
                      color: colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                if (showWarmUpAtStart) ...[
                  SizedBox(height: compact ? 12 : 16),
                  _buildWarmUpTile(warmUp),
                ],
                if (routine.stretchingItems.isNotEmpty) ...[
                  SizedBox(height: compact ? 12 : 16),
                  ...routine.stretchingItems.map(_buildStretchingTile),
                ],
                if (routine.exercises.isNotEmpty) ...[
                  SizedBox(height: compact ? 12 : 16),
                  ...routine.exercises
                      .map((item) => _buildExercise(context, item, l10n)),
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

  Widget _buildWarmUpTile(ResolvedWarmUp warmUp) {
    return WarmUpPreviewTile(
      warmUp: WarmUp(description: warmUp.description, minutes: warmUp.minutes),
      interactive: interactive,
      isCompleted: completedItemIds.contains(warmUpProgressItemId),
      onToggle: onItemToggle == null
          ? null
          : (completed) => onItemToggle!(warmUpProgressItemId, completed),
    );
  }

  Widget _buildStretchingTile(ResolvedStretching item) {
    return StretchingPreviewTile(
      item: StretchingItem(
        id: item.slotId,
        description: item.description,
        repetitions: item.repetitions,
      ),
      interactive: interactive,
      isCompleted: completedItemIds.contains(item.slotId),
      onToggle: onItemToggle == null
          ? null
          : (completed) => onItemToggle!(item.slotId, completed),
    );
  }

  Widget _buildExercise(
    BuildContext context,
    ResolvedExercise item,
    AppLocalizations l10n,
  ) {
    final isCompleted = completedItemIds.contains(item.slotId);
    final subtitle = item.localizedSubtitle(l10n);
    final colorScheme = Theme.of(context).colorScheme;
    final canEditWeight =
        interactive && !item.isMissing && onExerciseWeightEdit != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant,
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
                  onItemToggle?.call(item.slotId, value ?? false);
                },
              ),
            )
          else
            Container(
              width: 18,
              height: 18,
              margin: const EdgeInsets.only(top: 3, right: 12),
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.outline, width: 2),
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
                    color: item.isMissing
                        ? colorScheme.error
                        : (isCompleted
                            ? colorScheme.outline
                            : colorScheme.onSurface),
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      decoration:
                          isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (canEditWeight)
            IconButton(
              onPressed: () => onExerciseWeightEdit!(item),
              icon: const Icon(Icons.edit_outlined, size: 20),
              tooltip: l10n.editExerciseWeight,
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }
}
