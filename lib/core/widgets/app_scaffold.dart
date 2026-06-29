import 'package:flutter/material.dart';

import 'package:life_fit/core/widgets/app_drawer.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.appBar,
    this.actions,
    this.floatingActionButton,
    this.centerTitle = false,
  });

  final Widget body;
  final String? title;
  final PreferredSizeWidget? appBar;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ??
          (title == null
              ? null
              : AppBar(
                  title: Text(title!),
                  centerTitle: centerTitle,
                  actions: actions,
                )),
      drawer: const AppDrawer(),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
