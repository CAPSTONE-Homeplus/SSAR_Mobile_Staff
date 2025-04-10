import 'package:home_staff/infra/house/entity/building_entity.dart';
import 'package:home_staff/infra/house/entity/house.dart';

abstract class HouseRepository {
  Future<House> getHouseById(String id);
  Future<Building> getBuildingById(String id);
}
