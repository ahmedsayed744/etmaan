import 'package:etmaan/features/azkar/data/repo/azkar_repo.dart';
import '../datasource/azkar_local_datasource.dart';
import '../models/azkar_model.dart';

class AzkarRepoImp implements AzkarRepo {
  final AzkarLocalDataSource dataSource;

  AzkarRepoImp(this.dataSource);

  @override
  Future<List<AzkarModel>> getAzkar(String jsonFile) {
    return dataSource.getAzkar(jsonFile);
  }
}