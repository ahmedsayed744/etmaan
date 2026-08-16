import '../models/azkar_model.dart';

abstract class AzkarRepo {
  Future<List<AzkarModel>> getAzkar(String jsonFile);
}