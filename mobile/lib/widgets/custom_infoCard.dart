import 'package:flutter/material.dart';
import '../constant/app_colors.dart';

class ActiveTripCard extends StatelessWidget {
  final String routeName;
  final String status; 
  final String driverName;
  final String busNumber;
  final String scheduleTime;
  final String nextStop;
  final int onboardPassengers;
  final int totalPassengers;

  const ActiveTripCard({
    Key? key,
    required this.routeName,
    required this.status,
    required this.driverName,
    required this.busNumber,
    required this.scheduleTime,
    required this.nextStop,
    required this.onboardPassengers,
    required this.totalPassengers,
  }) : super(key: key);

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case "sos":
        return AppColors.sos;
      case "running":
        return AppColors.running;
      case "delayed":
        return AppColors.delayed;
      case "on time":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Route & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  routeName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: _getStatusColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Driver & Bus Info
            Text(
              "Driver: $driverName • Bus: $busNumber",
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 6),

            // Schedule
            Row(
              children: [
                const Icon(Icons.schedule, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  "$scheduleTime",
                  style: TextStyle(
                    fontSize: 14,
                    color: _getStatusColor(), 
                  ),
                ),
              ],
            ),

            // Next Stop
            Row(
              children: [
                const Icon(Icons.stop_circle_outlined, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  "Next: $nextStop",
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),

            // Passenger Count
            Row(
              children: [
                const Icon(Icons.person, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  "$onboardPassengers/$totalPassengers onboard",
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}