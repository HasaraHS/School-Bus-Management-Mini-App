import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_bus_management_mini_app/constant/app_string.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_infoCard.dart';
import '../providers/auth_provider.dart';
import '../constant/app_text_styles.dart';
import '../constant/app_dimensions.dart';
import '../constant/app_colors.dart';
import '../navigation/bottom_nav_logic.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import 'map_screen.dart';



class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0; // Dashboard index

  // Dummy trips data
  final List<Map<String, dynamic>> trips = [
    {
      "routeName": "Route A",
      "status": "On Time",
      "driverName": "Kamal",
      "busNumber": "NB-1234",
      "scheduleTime": "7:30 AM",
      "nextStop": "Main Gate",
      "onboardPassengers": 32,
      "totalPassengers": 40,
    },
    {
      "routeName": "Route B",
      "status": "Delayed",
      "driverName": "Sunil",
      "busNumber": "NB-5678",
      "scheduleTime": "8:00 AM",
      "nextStop": "Town Junction",
      "onboardPassengers": 25,
      "totalPassengers": 40,
    },
  ];

  void _onNavBarTap(int index) {
    final oldIndex = _currentIndex;
    setState(() => _currentIndex = index);
    BottomNavLogic.handleTap(
      context,
      currentIndex: oldIndex,
      newIndex: index,
      trips: trips,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userName = authProvider.user?.fullName ?? "User";

    // Dummy metrics
    final double fleetOtp = 92;
    final int activeTripsCount = 4;
    final int tripCount = 12;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            Container(
              margin: const EdgeInsets.only(top: AppDimensions.paddingLarge),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingSmall),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: AppColors.primary,
                      size: AppDimensions.iconLarge,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingMedium),
                  Expanded(
                    child: Text(
                      "Good morning, \n$userName",
                      style: AppTextStyles.title.copyWith(
                        fontSize: AppDimensions.fontSizeLarge,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.paddingLarge),

            // Live Map Button
            Center(
              child: CustomButton(
                icon: Icons.map,
                text: AppString.goToLiveMap,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapScreen(trips: trips,)),
                  );
                },
                color: Colors.black,
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.07,
              ),
            ),

            const SizedBox(height: AppDimensions.paddingMedium),

            // Metrics Row
            Row(
              children: [
                _buildMetricCard(context, AppString.fleetOTP, "${fleetOtp.toStringAsFixed(0)}%"),
                _buildMetricCard(context, AppString.activeTrips, "$activeTripsCount"),
                _buildMetricCard(context, AppString.tripCount, "$tripCount"),
              ],
            ),

            const SizedBox(height: AppDimensions.paddingLarge),

            // Log Incident & Contact Support Buttons
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 320;

                    if (isNarrow) {
                      return Column(
                        children: [
                          CustomButton(
                            text: AppString.logIncident,
                            onPressed: () {},
                            color: AppColors.primary,
                            height: AppDimensions.buttonHeight,
                            width: double.infinity,
                          ),
                          const SizedBox(height: AppDimensions.paddingSmall),
                          CustomButton(
                            text: AppString.contactSupport,
                            onPressed: () {},
                            color: AppColors.primary,
                            height: AppDimensions.buttonHeight,
                            width: double.infinity,
                          ),
                        ],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: AppString.logIncident,
                            onPressed: () {},
                            color: AppColors.primary,
                            height: AppDimensions.buttonHeight,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.paddingSmall),
                        Expanded(
                          child: CustomButton(
                            text: AppString.contactSupport,
                            onPressed: () {},
                            color: AppColors.primary,
                            height: AppDimensions.buttonHeight,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: AppDimensions.paddingLarge),

            // Active Trips Title
            const Text(
              AppString.activeTrips,
              style: TextStyle(
                fontSize: AppDimensions.fontSizeHeadline,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingSmall),

            // Trip List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips[index];
                return ActiveTripCard(
                  routeName: trip['routeName'],
                  status: trip['status'],
                  driverName: trip['driverName'],
                  busNumber: trip['busNumber'],
                  scheduleTime: trip['scheduleTime'],
                  nextStop: trip['nextStop'],
                  onboardPassengers: trip['onboardPassengers'],
                  totalPassengers: trip['totalPassengers'],
                );
              },
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, String title, String value) {
    return Expanded(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
