import 'package:flutter/material.dart';

import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/shared/models/routine_card.dart';
import 'package:life_fit/shared/utils/locale_format.dart';
import 'package:life_fit/shared/widgets/routine_picker_list.dart';

class RoutineAssignSheet {
  RoutineAssignSheet._();

  /// Returns selected [routineId], empty string if remove was chosen,
  /// or null if the user dismissed the sheet.
  static Future<String?> show(
    BuildContext context, {
    required DateTime date,
    required List<RoutineCard> routines,
    String? currentRoutineId,
    bool allowRemove = false,
    String? title,
  }) {
    final l10n = AppLocalizations.of(context);
    final formattedDate = formatShortDate(context, date);
    final sheetTitle = title ??
        (currentRoutineId == null
            ? l10n.assignRoutineForDate(formattedDate)
            : l10n.changeRoutineForDate(formattedDate));

    return showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        final sheetHeight = mediaQuery.size.height * 0.5;

        return Padding(
          padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
          child: SizedBox(
            height: sheetHeight,
            child: _RoutineAssignSheetBody(
              title: sheetTitle,
              routines: routines,
              currentRoutineId: currentRoutineId,
              allowRemove: allowRemove,
            ),
          ),
        );
      },
    );
  }
}

class _RoutineAssignSheetBody extends StatelessWidget {
  const _RoutineAssignSheetBody({
    required this.title,
    required this.routines,
    required this.currentRoutineId,
    required this.allowRemove,
  });

  final String title;
  final List<RoutineCard> routines;
  final String? currentRoutineId;
  final bool allowRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Expanded(
            child: RoutinePickerList(
              routines: routines,
              currentRoutineId: currentRoutineId,
              onSelected: (routineId) => Navigator.of(context).pop(routineId),
            ),
          ),
          if (allowRemove && currentRoutineId != null)
            ListTile(
              leading: const Icon(Icons.event_busy),
              title: Text(l10n.removeRoutineFromDay),
              onTap: () => Navigator.of(context).pop(''),
            ),
        ],
      ),
    );
  }
}
