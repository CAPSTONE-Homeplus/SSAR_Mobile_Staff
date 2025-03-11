import 'package:home_staff/constants/constants.dart';
import 'package:home_staff/features/planner/trip_details/widgets/map_marker.dart';
import 'package:home_staff/infra/planner/model/trip_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';

/// Custom map view with tile and marker layer.
///
/// Marker layer displays markers from [locations].
/// Map interactivity can be disabled by setting [isMapEnabled] to `false`.
///
/// [selectedMarkerId] is the ID of the marker/location that is selected and should be highlighted.
/// Pass the [onSelectMarker] callback to control what happens when tapping a marker.
///
/// [mapBottomPadding] defines the bottom padding of [locations] bounds.
/// Pass this argument if there is something on the bottom of the page blocking the map,
/// and you want to move the markers up.
class MapView extends StatelessWidget {
  final MapController? mapController;
  final List<TripLocation> locations;
  final bool isMapEnabled;
  final String? selectedMarkerId;
  final Function(String selectedId)? onSelectMarker;
  final double mapBottomPadding;

  const MapView({
    super.key,
    this.mapController,
    this.locations = const <TripLocation>[],
    this.isMapEnabled = true,
    this.selectedMarkerId,
    this.onSelectMarker,
    this.mapBottomPadding = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(

      ),
      children: [
        TileLayer(
          // For this to work, both light and dark style URLs should be provided in the .env file.
          // Styles can be obtained from different providers, such as Mapbox.
          // In case URLs are not set in the .env file, this will use the fallback URL.
          urlTemplate: MediaQuery.of(context).platformBrightness == Brightness.dark
              ? dotenv.env['MAPS_TILE_DARK_URL']
              : dotenv.env['MAPS_TILE_LIGHT_URL'],
          fallbackUrl: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: AppConstants.mapUserAgent,
        ),
      ],
    );
  }
}
