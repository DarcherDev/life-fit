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
    this.settledCompletedItemIds,
    this.interactive = false,
    this.onItemToggle,
    this.onExerciseWeightEdit,
    this.onExerciseReplace,
    this.onStretchingReplace,
    this.onWarmUpReplace,
    this.onReorderExercises,
    this.onReorderStretchings,
    this.compact = false,
    this.pendingItemsFirst = false,
  });

  final ResolvedRoutine routine;
  final Set<String> completedItemIds;
  /// Si [pendingItemsFirst] es true, solo estos IDs bajan al final.
  /// Si es null, se usa [completedItemIds] (comportamiento inmediato).
  final Set<String>? settledCompletedItemIds;
  final bool interactive;
  final void Function(String itemId, bool completed)? onItemToggle;
  final void Function(ResolvedExercise exercise)? onExerciseWeightEdit;
  final void Function(ResolvedExercise exercise)? onExerciseReplace;
  final void Function(ResolvedStretching stretching)? onStretchingReplace;
  final VoidCallback? onWarmUpReplace;
  final void Function(int oldIndex, int newIndex)? onReorderExercises;
  final void Function(int oldIndex, int newIndex)? onReorderStretchings;
  final bool compact;
  final bool pendingItemsFirst;

  static const _completeStyleDuration = Duration(milliseconds: 400);

  Set<String> get _settledIds => settledCompletedItemIds ?? completedItemIds;

  List<_ChecklistEntry> _orderedEntries(List<_ChecklistEntry> entries) {
    if (!pendingItemsFirst) {
      return entries;
    }
    final settled = _settledIds;
    return [
      ...entries.where((entry) => !settled.contains(entry.itemId)),
      ...entries.where((entry) => settled.contains(entry.itemId)),
    ];
  }

  Widget _buildStaticSection(List<_ChecklistEntry> entries) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: entries
          .map(
            (entry) => Padding(
              key: ValueKey<String>('checklist-${entry.itemId}'),
              padding: const EdgeInsets.only(bottom: 10),
              child: entry.widget,
            ),
          )
          .toList(),
    );
  }

  Widget _buildReorderableSection({
    required List<_ChecklistEntry> entries,
    required void Function(int oldIndex, int newIndex) onReorder,
  }) {
    if (entries.isEmpty) {
      return const SizedBox.shrink();
    }

    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      buildDefaultDragHandles: false,
      itemCount: entries.length,
      onReorder: onReorder,
      proxyDecorator: (child, index, animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, _) {
            final elevation =
                Tween<double>(begin: 0, end: 6).evaluate(animation);
            return Material(
              elevation: elevation,
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              child: child,
            );
          },
        );
      },
      itemBuilder: (context, index) {
        final entry = entries[index];
        return ReorderableDelayedDragStartListener(
          key: ValueKey<String>('checklist-${entry.itemId}'),
          index: index,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: entry.widget,
          ),
        );
      },
    );
  }

  Widget _buildChecklistBody(BuildContext context, AppLocalizations l10n) {
    final warmUp = routine.warmUp;
    final showWarmUpAtStart =
        warmUp != null && routine.warmUpPlacement == WarmUpPlacement.start;
    final showWarmUpAtEnd =
        warmUp != null && routine.warmUpPlacement == WarmUpPlacement.end;

    final stretchingEntries = _orderedEntries(
      routine.stretchingItems
          .map(
            (item) => _ChecklistEntry(
              itemId: item.slotId,
              isCompleted: completedItemIds.contains(item.slotId),
              widget: _buildStretchingTile(item),
            ),
          )
          .toList(),
    );

    final exerciseEntries = _orderedEntries(
      routine.exercises
          .map(
            (item) => _ChecklistEntry(
              itemId: item.slotId,
              isCompleted: completedItemIds.contains(item.slotId),
              widget: _buildExercise(context, item, l10n),
            ),
          )
          .toList(),
    );

    final children = <Widget>[];

    if (showWarmUpAtStart) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _buildWarmUpTile(warmUp),
        ),
      );
    }

    if (stretchingEntries.isNotEmpty) {
      children.add(
        onReorderStretchings != null && interactive
            ? _buildReorderableSection(
                entries: stretchingEntries,
                onReorder: onReorderStretchings!,
              )
            : _buildStaticSection(stretchingEntries),
      );
    }

    if (exerciseEntries.isNotEmpty) {
      children.add(
        onReorderExercises != null && interactive
            ? _buildReorderableSection(
                entries: exerciseEntries,
                onReorder: onReorderExercises!,
              )
            : _buildStaticSection(exerciseEntries),
      );
    }

    if (showWarmUpAtEnd) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _buildWarmUpTile(warmUp),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
          Container(height: 4, color: colorScheme.primary),
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
                          color: colorScheme.primary,
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
                if (routine.hasWarmUp ||
                    routine.stretchingItems.isNotEmpty ||
                    routine.exercises.isNotEmpty) ...[
                  SizedBox(height: compact ? 12 : 16),
                  _buildChecklistBody(context, l10n),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarmUpTile(ResolvedWarmUp warmUp) {
    final canReplace =
        interactive && !warmUp.isMissing && onWarmUpReplace != null;

    return WarmUpPreviewTile(
      warmUp: WarmUp(description: warmUp.description, minutes: warmUp.minutes),
      interactive: interactive,
      isCompleted: completedItemIds.contains(warmUpProgressItemId),
      onToggle: onItemToggle == null
          ? null
          : (completed) => onItemToggle!(warmUpProgressItemId, completed),
      onReplace: canReplace ? onWarmUpReplace : null,
    );
  }

  Widget _buildStretchingTile(ResolvedStretching item) {
    final canReplace =
        interactive && !item.isMissing && onStretchingReplace != null;

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
      onReplace: canReplace ? () => onStretchingReplace!(item) : null,
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
    final canEdit =
        interactive && !item.isMissing && onExerciseWeightEdit != null;
    final canReplace =
        interactive && !item.isMissing && onExerciseReplace != null;

    return AnimatedContainer(
      duration: _completeStyleDuration,
      curve: Curves.easeOutCubic,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCompleted
            ? colorScheme.surfaceVariant.withOpacity(0.55)
            : colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: interactive && onItemToggle != null
                    ? () => onItemToggle!(item.slotId, !isCompleted)
                    : null,
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (interactive)
                      AbsorbPointer(
                        child: Checkbox(
                          value: isCompleted,
                          activeColor: colorScheme.primary,
                          onChanged: (_) {},
                        ),
                      )
                    else
                      Container(
                        width: 18,
                        height: 18,
                        margin: const EdgeInsets.only(top: 3, right: 12),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: colorScheme.outline, width: 2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedDefaultTextStyle(
                            duration: _completeStyleDuration,
                            curve: Curves.easeOutCubic,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: item.isMissing
                                  ? colorScheme.error
                                  : (isCompleted
                                      ? colorScheme.outline
                                      : colorScheme.onSurface),
                            ),
                            child: Text(item.title),
                          ),
                          if (subtitle.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            AnimatedDefaultTextStyle(
                              duration: _completeStyleDuration,
                              curve: Curves.easeOutCubic,
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                decoration: isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                              child: Text(subtitle),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (canReplace || canEdit)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (canReplace)
                  IconButton(
                    onPressed: () => onExerciseReplace!(item),
                    icon: const Icon(Icons.swap_horiz, size: 20),
                    tooltip: l10n.changeExercise,
                    visualDensity: VisualDensity.compact,
                  ),
                if (canEdit)
                  IconButton(
                    onPressed: () => onExerciseWeightEdit!(item),
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    tooltip: l10n.editExercise,
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _ChecklistEntry {
  const _ChecklistEntry({
    required this.itemId,
    required this.isCompleted,
    required this.widget,
  });

  final String itemId;
  final bool isCompleted;
  final Widget widget;
}
