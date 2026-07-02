import 'package:life_fit/modules/calentamiento/models/warm_up_template.dart';

abstract class WarmUpTemplateRepository {
  List<WarmUpTemplate> getWarmUpTemplates();

  WarmUpTemplate? getWarmUpTemplateById(String templateId);

  Future<void> upsertWarmUpTemplate(WarmUpTemplate template);

  Future<bool> deleteWarmUpTemplate(String templateId);
}
