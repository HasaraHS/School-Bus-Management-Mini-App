import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:school_bus_management_mini_app/constant/app_string.dart';
import 'dart:typed_data';
import '../providers/auth_provider.dart';
import '../providers/school_provider.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/custom_infoCard.dart';
import '../widgets/custom_search_bar.dart';
import '../constant/app_dimensions.dart';
import '../navigation/bottom_nav_logic.dart';

class MapScreen extends StatefulWidget {
  final List<Map<String, dynamic>> trips;

  const MapScreen({Key? key, required this.trips}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapboxMap? _map;
  PointAnnotationManager? _pointAnnotationManager;
  String _lastSchoolSignature = '';
  Uint8List? _markerImageBytes;
  int _currentIndex = 1;

  String selectedVehicle = "All Active Vehicle";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSchoolsIfNeeded();
    });
  }

  Future<void> _loadMarkerImage() async {
    try {
      final data = await rootBundle.load('assets/images/marker.png');
      _markerImageBytes = data.buffer.asUint8List();
      if (mounted) setState(() {}); 
    } catch (_) {
      _markerImageBytes = null;
    }
  }

  Future<void> _loadSchoolsIfNeeded() async {
    if (!mounted) return;

    final authProvider = context.read<AuthProvider>();
    final schoolProvider = context.read<SchoolProvider>();
    final token = authProvider.token;

    if (schoolProvider.schools.isEmpty && token != null && token.isNotEmpty) {
      await schoolProvider.loadSchools(token);
    }

    await _loadMarkerImage();
  }

  void _onNavBarTap(int index) {
    final oldIndex = _currentIndex;
    setState(() => _currentIndex = index);
    BottomNavLogic.handleTap(
      context,
      currentIndex: oldIndex,
      newIndex: index,
      trips: widget.trips,
    );
  }

  String _buildSchoolSignature(SchoolProvider provider) {
    return provider.schools
        .map((s) => '${s.id}:${s.latitude}:${s.longitude}')
        .join('|');
  }

  Future<void> _syncMapWithSchools(SchoolProvider provider) async {
    if (_map == null) return;

    final schools = provider.schools;

    if (schools.isEmpty) {
      await _map!.flyTo(
        CameraOptions(
          center: Point(coordinates: Position(79.8612, 6.9271)), // Colombo
          zoom: 10.0,
        ),
        MapAnimationOptions(duration: 1500),
      );
      return;
    }

    await _map!.flyTo(
      CameraOptions(
        center: Point(
          coordinates: Position(
            schools.first.longitude,
            schools.first.latitude,
          ),
        ),
        zoom: 13.0,
      ),
      MapAnimationOptions(duration: 1500),
    );

    _pointAnnotationManager ??= await _map!.annotations
        .createPointAnnotationManager();
    await _pointAnnotationManager!.deleteAll();

    for (var school in schools) {
      final point = Point(
        coordinates: Position(school.longitude, school.latitude),
      );

      await _pointAnnotationManager!.create(
        PointAnnotationOptions(
          geometry: point,
          image: _markerImageBytes,
          iconImage: _markerImageBytes == null ? 'marker-15' : null,
          iconSize: 0.3,
          textField: school.name,
          textOffset: [0.0, 1.5],
          textSize: 14.0,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final schoolProvider = Provider.of<SchoolProvider>(context);
    final schoolSignature = _buildSchoolSignature(schoolProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // sync schools if updated
    if (_map != null && _lastSchoolSignature != schoolSignature) {
      _lastSchoolSignature = schoolSignature;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _syncMapWithSchools(schoolProvider);
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          // Map 
          SizedBox(
            height: screenHeight,
            width: screenWidth,
            child: MapWidget(
              styleUri: MapboxStyles.MAPBOX_STREETS,
              onMapCreated: (mapboxMap) async {
                _map = mapboxMap;
              },
              onStyleLoadedListener: (_) async {
                if (_map != null && _markerImageBytes != null) {
                  await _syncMapWithSchools(schoolProvider);
                }
              },
            ),
          ),

          // Search bar
          Positioned(
            top: screenHeight * 0.06,
            left: screenWidth * 0.02,
            right: screenWidth * 0.04,
            child: CustomSearchBar(
              selectedValue: selectedVehicle,
              items: const [
                "All Active Vehicle",
                "North Route A",
                "South Route B",
              ],
              onChanged: (value) {
                setState(() {
                  selectedVehicle = value!;
                });
              },
            ),
          ),

          // Trips 
          Positioned(
            top: screenHeight * 0.5, 
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.radius),
                  topRight: Radius.circular(AppDimensions.radius),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: ListView.builder(
                itemCount: widget.trips.length,
                itemBuilder: (context, index) {
                  final trip = widget.trips[index];
                  return ActiveTripCard(
                    routeName: trip['routeName'] ?? 'Unknown Route',
                    status: trip['status'] ?? 'Unknown',
                    driverName: trip['driverName'] ?? 'Unknown',
                    busNumber: trip['busNumber'] ?? 'N/A',
                    scheduleTime: trip['scheduleTime'] ?? 'N/A',
                    nextStop: trip['nextStop'] ?? 'No next stop',
                    onboardPassengers: trip['onboardPassengers'] ?? 0,
                    totalPassengers: trip['totalPassengers'] ?? 0,
                  );
                },
              ),
            ),
          ),

          // Map error
          if (schoolProvider.schools.isEmpty)
            const Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    AppString.mapError,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}
