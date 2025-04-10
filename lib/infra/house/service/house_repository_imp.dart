// lib/infra/house/service/house_repository_impl.dart

import 'package:home_staff/infra/house/entity/building_entity.dart';
import 'package:home_staff/infra/house/entity/house.dart';
import 'package:home_staff/infra/house/service/house_repository.dart';
import 'package:home_staff/infra/house/service/request/get_building_by_id_request.dart';
import 'package:home_staff/infra/house/service/request/get_house_by_id_request.dart';
import 'package:home_staff/infra/http/http_service.dart';

class HouseRepositoryImpl implements HouseRepository {
  final HttpService http;

  HouseRepositoryImpl(this.http);

  @override
  Future<House> getHouseById(String id) async {
    try {
      final response = await http.request(
        GetHouseByIdRequest(houseId: id),
        transformer: (json) => House.fromJson(json),
      );
      return response;
    } catch (_) {
      throw Exception("Không thể tải thông tin căn hộ.");
    }
  }

  @override
  Future<Building> getBuildingById(String id) async {
    try {
      final response = await http.request(
        GetBuildingByIdRequest(buildingId: id),
        transformer: (json) => Building.fromJson(json),
      );
      return response;
    } catch (e) {
      throw Exception("Không thể lấy thông tin toà nhà.");
    }
  }
}
