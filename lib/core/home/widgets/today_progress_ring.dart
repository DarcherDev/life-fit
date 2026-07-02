import 'package:flutter/material.dart';

import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/shared/utils/routine_progress.dart';

class TodayProgressRing extends StatelessWidget {
  const TodayProgressRing({
    super.key,
    required this.summary,
    this.onTap,
  });

  final RoutineProgressSummary summary;
  final VoidCallback? onTap;

  static const _ringSize = 168.0;
  static const _strokeWidth = 14.0;
  static const _accentColor = Color(0xFF16A34A);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final subtitle = _subtitleFor(l10n);

    final content = Column(
      children: [
        SizedBox(
          width: _ringSize,
          height: _ringSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: _ringSize,
                height: _ringSize,
                child: CircularProgressIndicator(
                  value: summary.fraction.clamp(0, 1),
                  strokeWidth: _strokeWidth,
                  backgroundColor: colorScheme.surfaceVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    summary.isComplete ? _accentColor : Colors.deepOrange,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${summary.percent}%',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: summary.isComplete
                          ? _accentColor
                          : Colors.deepOrange,
                    ),
                  ),
                  if (summary.hasRoutine && summary.totalItems > 0)
                    Text(
                      l10n.homeTodayProgressCount(
                        summary.completedItems,
                        summary.totalItems,
                      ),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );

    if (onTap == null) {
      return content;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: content,
        ),
      ),
    );
  }

  String _subtitleFor(AppLocalizations l10n) {
    if (!summary.hasRoutine) {
      return l10n.homeTodayNoRoutine;
    }
    if (summary.totalItems == 0) {
      return l10n.homeTodayRoutineEmpty;
    }
    if (summary.isComplete) {
      return l10n.homeTodayRoutineComplete;
    }
    return l10n.homeTodayProgressSubtitle;
  }
}
