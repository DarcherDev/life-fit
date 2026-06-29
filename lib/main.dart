import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';
import 'screens/home_screen.dart';
import 'services/locale_service.dart';
import 'services/local_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init();
  await LocaleService.instance.init();
  runApp(const LifeFitApp());
}

class LifeFitApp extends StatefulWidget {
  const LifeFitApp({super.key});

  @override
  State<LifeFitApp> createState() => _LifeFitAppState();
}

class _LifeFitAppState extends State<LifeFitApp> {
  final _localeService = LocaleService.instance;

  @override
  void initState() {
    super.initState();
    _localeService.addListener(_onLocaleChanged);
  }

  @override
  void dispose() {
    _localeService.removeListener(_onLocaleChanged);
    super.dispose();
  }

  void _onLocaleChanged() {
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
