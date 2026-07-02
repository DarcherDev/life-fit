import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:life_fit/core/profile/models/personal_profile.dart';
import 'package:life_fit/core/services/personal_profile_service.dart';
import 'package:life_fit/core/services/weight_unit_service.dart';
import 'package:life_fit/core/utils/weight_format.dart';
import 'package:life_fit/core/widgets/app_scaffold.dart';
import 'package:life_fit/l10n/app_localizations.dart';

class MyProcessScreen extends StatefulWidget {
  const MyProcessScreen({super.key});

  @override
  State<MyProcessScreen> createState() => _MyProcessScreenState();
}

class _MyProcessScreenState extends State<MyProcessScreen> {
  final _formKey = GlobalKey<FormState>();
  final _profileService = PersonalProfileService.instance;
  late final TextEditingController _ageController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    final profile = _profileService.profile;
    _ageController = TextEditingController(
      text: profile.ageYears?.toString() ?? '',
    );
    _heightController = TextEditingController(
      text: profile.heightCm == null
          ? ''
          : formatWeightValue(profile.heightCm!),
    );
    _weightController = TextEditingController(
      text: weightInputFromKg(
            profile.bodyWeightKg,
            WeightUnitService.instance.unit,
          ) ??
          '',
    );
  }

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final ageText = _ageController.text.trim();
    final heightText = _heightController.text.trim();
    final weightText = _weightController.text.trim();

    final profile = PersonalProfile(
      ageYears: ageText.isEmpty ? null : int.parse(ageText),
      heightCm: heightText.isEmpty
          ? null
          : double.parse(heightText.replaceAll(',', '.')),
      bodyWeightKg: parseWeightInput(
        weightText,
        WeightUnitService.instance.unit,
      ),
    );

    await _profileService.saveProfile(profile);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).profileSaved)),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final unit = WeightUnitService.instance.unit;

    return AppScaffold(
      title: l10n.myProcessTitle,
      actions: [
        IconButton(
          onPressed: _save,
          icon: const Icon(Icons.check, color: Colors.green),
          tooltip: l10n.save,
        ),
      ],
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              l10n.myProcessDescription,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _ageController,
              decoration: InputDecoration(
                labelText: l10n.personalAgeLabel,
                hintText: l10n.personalAgeHint,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                final trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) {
                  return null;
                }
                final age = int.tryParse(trimmed);
                if (age == null || age < 1 || age > 120) {
                  return l10n.invalidAge;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _heightController,
              decoration: InputDecoration(
                labelText: l10n.personalHeightLabel,
                hintText: l10n.personalHeightHint,
                border: const OutlineInputBorder(),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
              ],
              validator: (value) {
                final trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) {
                  return null;
                }
                final height =
                    double.tryParse(trimmed.replaceAll(',', '.'));
                if (height == null || height <= 0 || height > 300) {
                  return l10n.invalidHeight;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _weightController,
              decoration: InputDecoration(
                labelText: l10n.personalBodyWeightLabel,
                hintText: l10n.exerciseWeightHint,
                suffixText: weightUnitLabel(unit, l10n),
                border: const OutlineInputBorder(),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
              ],
              validator: (value) {
                final trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) {
                  return null;
                }
                if (parseWeightInput(trimmed, unit) == null) {
                  return l10n.invalidWeight;
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
