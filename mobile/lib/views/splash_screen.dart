import 'dart:async';
import 'package:flutter/material.dart';
import 'package:school_bus_management_mini_app/constant/app_string.dart';
import '../constant/app_dimensions.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  void _navigateToLogin() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  AppDimensions.radiusXLarge, 
                ),
                image: const DecorationImage(
                  image: AssetImage('assets/images/school_bus_logo.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(height: AppDimensions.paddingLarge),

            Text(
              AppString.busbuddy,
              style: TextStyle(
                color: Colors.white,
                fontSize: AppDimensions.fontSizeHeadline,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}