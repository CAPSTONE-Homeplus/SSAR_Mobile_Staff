

import 'package:home_clean_crew/core/api_constant.dart';
import 'package:home_clean_crew/core/base_model.dart';
import 'package:home_clean_crew/core/exception_handler.dart';
import 'package:home_clean_crew/core/request.dart';
import 'package:home_clean_crew/data/mappers/time_slot_mapper.dart';
import 'package:home_clean_crew/data/models/time_slot/time_slot_model.dart';
import 'package:home_clean_crew/data/repositories/time_slot/time_slot_repository.dart';
import 'package:home_clean_crew/domain/entities/time_slot/time_slot.dart';

class TimeSlotRepositoryImpl implements TimeSlotRepository {
  @override
  Future<BaseResponse<TimeSlot>> getTimeSlots(
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) async {
    try {
      final response =
          await request.get('${ApiConstant.TIME_SLOTS}', queryParameters: {
        'search': search,
        'orderBy': orderBy,
        'page': page,
        'size': size,
      });

      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> data = response.data['items'] ?? [];

        List<TimeSlot> timeSlotList = data
            .map(
                (item) => TimeSlotMapper.toEntity(TimeSlotModel.fromJson(item)))
            .toList();

        return BaseResponse<TimeSlot>(
          size: response.data['size'] ?? 0,
          page: response.data['page'] ?? 0,
          total: response.data['total'] ?? 0,
          totalPages: response.data['totalPages'] ?? 0,
          items: timeSlotList,
        );
      } else {
        throw ApiException(
          errorCode: response.statusCode,
          errorMessage: response.statusMessage ?? 'Lỗi không xác định',
          errorStatus: response.statusCode.toString(),
        );
      }
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }
}
