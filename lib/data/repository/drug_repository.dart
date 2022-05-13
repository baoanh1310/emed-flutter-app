import 'package:emed/data/model/drug.dart';

abstract class DrugRepository {
  Future<List<Drug>> getAllDrugs();
}
