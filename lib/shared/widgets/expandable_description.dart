import 'package:flutter/material.dart';

import 'package:life_fit/l10n/app_localizations.dart';

/// Texto recortado a [collapsedLines] con "Ver más" solo si no cabe.
///
/// Expandido, el texto queda limitado a [expandedMaxHeight] con scroll propio
/// para que descripciones muy largas no rompan el contenedor.
class ExpandableDescription extends StatefulWidget {
  const ExpandableDescription(
    this.text, {
    super.key,
    this.collapsedLines = 3,
    this.expandedMaxHeight = 160,
  });

  final String text;
  final int collapsedLines;
  final double expandedMaxHeight;

  @override
  State<ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<ExpandableDescription> {
  var _expanded = false;

  bool _exceedsCollapsedLines(
    TextStyle? style,
    double maxWidth,
    TextDirection textDirection,
    double textScaleFactor,
  ) {
    final painter = TextPainter(
      text: TextSpan(text: widget.text, style: style),
      maxLines: widget.collapsedLines,
      textDirection: textDirection,
      textScaleFactor: textScaleFactor,
    )..layout(maxWidth: maxWidth);
    final exceeds = painter.didExceedMaxLines;
    painter.dispose();
    return exceeds;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final canExpand = _exceedsCollapsedLines(
          style,
          constraints.maxWidth,
          Directionality.of(context),
          MediaQuery.textScaleFactorOf(context),
        );

        final Widget text;
        if (_expanded && canExpand) {
          text = ConstrainedBox(
            constraints: BoxConstraints(maxHeight: widget.expandedMaxHeight),
            child: SingleChildScrollView(
              child: Text(widget.text, style: style),
            ),
          );
        } else {
          text = Text(
            widget.text,
            style: style,
            maxLines: widget.collapsedLines,
            overflow: TextOverflow.ellipsis,
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            text,
            if (canExpand)
              TextButton(
                onPressed: () => setState(() => _expanded = !_expanded),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(_expanded ? l10n.seeLess : l10n.seeMore),
              ),
          ],
        );
      },
    );
  }
}
