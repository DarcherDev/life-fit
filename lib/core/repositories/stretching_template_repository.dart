import 'package:life_fit/modules/estiramiento/models/stretching_template.dart';

abstract class StretchingTemplateRepository {
  List<StretchingTemplate> getStretchingTemplates();

  StretchingTemplate? getStretchingTemplateById(String templateId);

  Future<void> upsertStretchingTemplate(StretchingTemplate template);

  Future<bool> deleteStretchingTemplate(String templateId);
}
