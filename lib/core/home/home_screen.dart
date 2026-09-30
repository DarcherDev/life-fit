import 'package:flutter/material.dart';

import 'package:life_fit/core/home/home_menu_option.dart';
import 'package:life_fit/core/home/widgets/today_progress_ring.dart';
import 'package:life_fit/core/navigation/app_navigation.dart';
import 'package:life_fit/core/repositories/app_repositories.dart';
import 'package:life_fit/core/services/home_menu_order_service.dart';
import 'package:life_fit/core/widgets/app_scaffold.dart';
import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/shared/utils/routine_progress.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final _repos = AppRepositories.instance;
  final _menuOrderService = HomeMenuOrderService.instance;
  RoutineProgressSummary _progressSummary = const RoutineProgressSummary(
    hasRoutine: false,
    totalItems: 0,
    completedItems: 0,
  );
  List<HomeMenuOption> _menuOrder = List<HomeMenuOption>.from(
    HomeMenuOption.defaultOrder,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _menuOrder = List<HomeMenuOption>.from(_menuOrderService.order);
    _menuOrderService.addListener(_onMenuOrderChanged);
    _loadTodayProgress();
  }

  @override
  void dispose() {
    _menuOrderService.removeListener(_onMenuOrderChanged);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onMenuOrderChanged() {
    setState(() {
      _menuOrder = List<HomeMenuOption>.from(_menuOrderService.order);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadTodayProgress();
    }
  }

  void _loadTodayProgress() {
    final dateKey = AppNavigation.todayDateKey;
    final assignment = _repos.assignments.getAssignmentForDate(dateKey);
    final routine = assignment == null
        ? null
        : _repos.routines.getRoutineById(assignment.routineId);
    final progress = _repos.progress.getDayProgress(dateKey);

    setState(() {
      _progressSummary = calculateRoutineProgress(
        routine: routine,
        completedItemIds: progress.completedItemIds,
      );
    });
  }

  Future<void> _openTodayGym() async {
    await AppNavigation.openTodayGym(context);
    if (mounted) {
      _loadTodayProgress();
    }
  }

  Future<void> _onReorderMenu(int oldIndex, int newIndex) async {
    await _menuOrderService.reorder(oldIndex, newIndex);
  }

  _HomeOptionData _optionData(
    HomeMenuOption option,
    AppLocalizations l10n,
    ColorScheme colors,
  ) {
    switch (option) {
      case HomeMenuOption.gymDay:
        return _HomeOptionData(
          title: l10n.homeGymDayTitle,
          subtitle: l10n.homeGymDaySubtitle,
          icon: Icons.fitness_center,
          color: colors.tertiary,
          onTap: _openTodayGym,
        );
      case HomeMenuOption.routines:
        return _HomeOptionData(
          title: l10n.homeRoutineTitle,
          subtitle: l10n.homeRoutineSubtitle,
          icon: Icons.dashboard_customize,
          color: colors.primary,
          onTap: () => AppNavigation.openRoutines(context),
        );
      case HomeMenuOption.planner:
        return _HomeOptionData(
          title: l10n.homePlannerTitle,
          subtitle: l10n.homePlannerSubtitle,
          icon: Icons.calendar_month,
          color: colors.secondary,
          onTap: () => AppNavigation.openPlanner(context),
        );
      case HomeMenuOption.exercises:
        return _HomeOptionData(
          title: l10n.homeExercisesTitle,
          subtitle: l10n.homeExercisesSubtitle,
          icon: Icons.fitness_center_outlined,
          color: colors.primary,
          onTap: () => AppNavigation.openExerciseLibrary(context),
        );
      case HomeMenuOption.stretching:
        return _HomeOptionData(
          title: l10n.homeStretchingTitle,
          subtitle: l10n.homeStretchingSubtitle,
          icon: Icons.self_improvement,
          color: colors.secondary,
          onTap: () => AppNavigation.openStretchingLibrary(context),
        );
      case HomeMenuOption.warmUp:
        return _HomeOptionData(
          title: l10n.homeWarmUpTitle,
          subtitle: l10n.homeWarmUpSubtitle,
          icon: Icons.local_fire_department,
          color: colors.tertiary,
          onTap: () => AppNavigation.openWarmUpLibrary(context),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return AppScaffold(
      title: l10n.appTitle,
      centerTitle: true,
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: TodayProgressRing(
                      summary: _progressSummary,
                      onTap: _openTodayGym,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.homeTagline,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            sliver: SliverReorderableList(
              itemCount: _menuOrder.length,
              onReorder: _onReorderMenu,
              proxyDecorator: (child, index, animation) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (context, _) {
                    final elevation =
                        Tween<double>(begin: 0, end: 6).evaluate(animation);
                    return Material(
                      elevation: elevation,
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      child: child,
                    );
                  },
                );
              },
              itemBuilder: (context, index) {
                final option = _menuOrder[index];
                final data = _optionData(option, l10n, theme.colorScheme);
                return ReorderableDelayedDragStartListener(
                  key: ValueKey<String>('home-menu-${option.storageId}'),
                  index: index,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _HomeOptionCard(
                      title: data.title,
                      subtitle: data.subtitle,
                      icon: data.icon,
                      color: data.color,
                      onTap: data.onTap,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeOptionData {
  const _HomeOptionData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
}

class _HomeOptionCard extends StatelessWidget {
  const _HomeOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: color.withOpacity(0.15),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
