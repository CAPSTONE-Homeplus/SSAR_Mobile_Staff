import 'dart:io';

import 'package:home_staff/infra/planner/data_source/trip_data_source.dart';
import 'package:home_staff/infra/planner/entity/trip_itinerary.dart';
import 'package:home_staff/infra/planner/model/trip_itinerary.dart';
import 'package:home_staff/infra/planner/repository/trip_repository_implementation.dart';
import 'package:home_staff/infra/traveler/data_source/traveler_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_staff/infra/auth/service/firebase_auth_service.dart';

final Provider<TripRepository> tripRepositoryProvider = Provider<TripRepository>((ProviderRef<TripRepository> ref) {
  final String userId = ref.watch(userIdProvider);
  final TripDataSource tripDataSource = ref.watch(tripDataSourceProvider);
  final TravelerDataSource travelerDataSource = ref.watch(travelerDataSourceProvider);

  return TripRepositoryImplementation(tripDataSource, travelerDataSource, userId);
});

abstract interface class TripRepository {
  Stream<List<TripItinerary>> getTripItineraries();

  Stream<TripItinerary> getSingleTripItinerary(String itineraryId);

  Future<void> updateTripItineraryData(TripItinerary tripItinerary, File? coverPhotoFile);

  Future<void> createTripItinerary(TripItineraryEntity tripItinerary, File? coverPhotoFile);

  Future<void> createMocked();

  Future<void> removeUserTrips();


}
