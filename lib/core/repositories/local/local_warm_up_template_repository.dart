import 'package:life_fit/core/repositories/local/shared_prefs_json_store.dart';
import 'package:life_fit/core/repositories/routine_repository.dart';
import 'package:life_fit/core/repositories/warm_up_template_repository.dart';
import 'package:life_fit/modules/calentamiento/models/warm_up_template.dart';

class LocalWarmUpTemplateRepository implements WarmUpTemplateRepository {
  LocalWarmUpTemplateRepository(this._store, this._routines);

  static const _key = 'warm_up_templates';

  final SharedPrefsJsonStore _store;
  final RoutineRepository _routines;

  @override
  List<WarmUpTemplate> getWarmUpTemplates() {
    return _store.readList(_key, WarmUpTemplate.fromJson);
  }

  @override
  WarmUpTemplate? getWarmUpTemplateById(String templateId) {
    for (final item in getWarmUpTemplates()) {
      if (item.id == templateId) {
        return item;
      }
    }
    return null;
  }

  @override
  Future<void> upsertWarmUpTemplate(WarmUpTemplate template) async {
    final items = getWarmUpTemplates();
    final index = items.indexWhere((existing) => existing.id == template.id);
    if (index >= 0) {
      items[index] = template;
    } else {
      items.add(template);
    }
    await _store.writeList(_key, items, (item) => item.toJson());
  }

  @override
  Future<bool> deleteWarmUpTemplate(String templateId) async {
    if (_isInUse(templateId)) {
      return false;
    }
    final items = getWarmUpTemplates()
      ..removeWhere((item) => item.id == templateId);
    await _store.writeList(_key, items, (item) => item.toJson());
    return true;
  }

  bool _isInUse(String templateId) {
    return _routines
        .getRoutineCards()
        .any((card) => card.referencesWarmUp(templateId));
  }
}
