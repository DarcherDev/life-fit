import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/modules/calentamiento/models/warm_up_placement.dart';

class WarmUpFormSection extends StatelessWidget {
  const WarmUpFormSection({
    super.key,
    required this.enabled,
    required this.onEnabledChanged,
    required this.descriptionController,
    required this.minutesController,
    required this.placement,
    required this.onPlacementChanged,
    required this.validateMinutes,
    this.onFieldsChanged,
  });

  final bool enabled;
  final ValueChanged<bool> onEnabledChanged;
  final TextEditingController descriptionController;
  final TextEditingController minutesController;
  final WarmUpPlacement placement;
  final ValueChanged<WarmUpPlacement> onPlacementChanged;
  final String? Function(String?)? validateMinutes;
  final VoidCallback? onFieldsChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.warmUpTitle),
          subtitle: Text(l10n.warmUpEnableSubtitle),
          value: enabled,
          onChanged: onEnabledChanged,
        ),
        if (enabled) ...[
          const SizedBox(height: 8),
          TextFormField(
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: l10n.warmUpDescriptionLabel,
              hintText: l10n.warmUpDescriptionHint,
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (!enabled) {
                return null;
              }
              if (value == null || value.trim().isEmpty) {
                return l10n.required;
              }
              return null;
            },
            onChanged: (_) => onFieldsChanged?.call(),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: minutesController,
            decoration: InputDecoration(
              labelText: l10n.warmUpMinutesLabel,
              hintText: l10n.warmUpMinutesHint,
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: validateMinutes,
            onChanged: (_) => onFieldsChanged?.call(),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.warmUpPlacementTitle,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          SegmentedButton<WarmUpPlacement>(
            segments: [
              ButtonSegment(
                value: WarmUpPlacement.start,
                label: Text(l10n.warmUpPlacementStart),
                icon: const Icon(Icons.play_arrow),
              ),
              ButtonSegment(
                value: WarmUpPlacement.end,
                label: Text(l10n.warmUpPlacementEnd),
                icon: const Icon(Icons.stop),
              ),
            ],
            selected: {placement},
            onSelectionChanged: (selection) {
              onPlacementChanged(selection.first);
              onFieldsChanged?.call();
            },
          ),
        ],
      ],
    );
  }
}
