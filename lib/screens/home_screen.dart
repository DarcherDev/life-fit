import 'package:flutter/material.dart';

import '../navigation/app_navigation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Life Fit'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'gestiona tu vida',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          _RoutineOptionCard(
            title: 'Dia de gym',
            subtitle: 'Rutina asignada para hoy',
            icon: Icons.fitness_center,
            color: Colors.deepOrange,
            onTap: () => AppNavigation.openTodayGym(context),
          ),
          const SizedBox(height: 16),
          _RoutineOptionCard(
            title: 'Rutina',
            subtitle: 'Crea y personaliza tus tarjetas',
            icon: Icons.dashboard_customize,
            color: Colors.teal,
            onTap: () => AppNavigation.openRoutines(context),
          ),
          const SizedBox(height: 16),
          _RoutineOptionCard(
            title: 'Planificador',
            subtitle: 'Asigna rutinas a tu calendario',
            icon: Icons.calendar_month,
            color: Colors.indigo,
            onTap: () => AppNavigation.openPlanner(context),
          ),
        ],
      ),
    );
  }
}

class _RoutineOptionCard extends StatelessWidget {
  const _RoutineOptionCard({
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
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
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
