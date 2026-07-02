import 'package:life_fit/core/repositories/local/shared_prefs_json_store.dart';
import 'package:life_fit/core/repositories/routine_repository.dart';
import 'package:life_fit/core/repositories/stretching_template_repository.dart';
import 'package:life_fit/modules/estiramiento/models/stretching_template.dart';

class LocalStretchingTemplateRepository implements StretchingTemplateRepository {
  LocalStretchingTemplateRepository(this._store, this._routines);

  static const _key = 'stretching_templates';

  final SharedPrefsJsonStore _store;
  final RoutineRepository _routines;

  @override
  List<StretchingTemplate> getStretchingTemplates() {
    return _store.readList(_key, StretchingTemplate.fromJson);
  }

  @override
  StretchingTemplate? getStretchingTemplateById(String templateId) {
    for (final item in getStretchingTemplates()) {
      if (item.id == templateId) {
        return item;
      }
    }
    return null;
  }

  @override
  Future<void> upsertStretchingTemplate(StretchingTemplate template) async {
    final items = getStretchingTemplates();
    final index = items.indexWhere((existing) => existing.id == template.id);
    if (index >= 0) {
      items[index] = template;
    } else {
      items.add(template);
    }
    await _store.writeList(_key, items, (item) => item.toJson());
  }

  @override
  Future<bool> deleteStretchingTemplate(String templateId) async {
    if (_isInUse(templateId)) {
      return false;
    }
    final items = getStretchingTemplates()
      ..removeWhere((item) => item.id == templateId);
    await _store.writeList(_key, items, (item) => item.toJson());
    return true;
  }

  bool _isInUse(String templateId) {
    return _routines
        .getRoutineCards()
        .any((card) => card.referencesStretching(templateId));
  }
}
