import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:life_fit/core/home/home_screen.dart';
import 'package:life_fit/core/home/locale_prompt_host.dart';
import 'package:life_fit/core/services/locale_service.dart';
import 'package:life_fit/core/services/local_storage_service.dart';
import 'package:life_fit/core/services/theme_service.dart';
import 'package:life_fit/core/services/weight_unit_service.dart';
import 'package:life_fit/core/theme/app_theme.dart';
import 'package:life_fit/l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init();
  await LocaleService.instance.init();
  await ThemeService.instance.init();
  await WeightUnitService.instance.init();
  runApp(const LifeFitApp());
}

class LifeFitApp extends StatefulWidget {
  const LifeFitApp({super.key});

  @override
  State<LifeFitApp> createState() => _LifeFitAppState();
}

class _LifeFitAppState extends State<LifeFitApp> {
  final _localeService = LocaleService.instance;
  final _themeService = ThemeService.instance;
  final _weightUnitService = WeightUnitService.instance;

  @override
  void initState() {
    super.initState();
    _localeService.addListener(_onChanged);
    _themeService.addListener(_onChanged);
    _weightUnitService.addListener(_onChanged);
  }

  @override
  void dispose() {
    _localeService.removeListener(_onChanged);
    _themeService.removeListener(_onChanged);
    _weightUnitService.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Life Fit',
      debugShowCheckedModeBanner: false,
      locale: _localeService.locale,
      supportedLocales: LocaleService.supportedLocales,
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        return _localeService.resolve(deviceLocale);
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _themeService.themeMode,
      home: const LocalePromptHost(child: HomeScreen()),
    );
  }
}
