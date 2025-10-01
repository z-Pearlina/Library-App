import 'package:flutter/material.dart';
import 'package:pearlibrary/screens/home/home_screen.dart';
import 'package:pearlibrary/screens/auth/login_screen.dart'; // Import LoginScreen
import 'package:pearlibrary/services/shared_prefs_service.dart'; // Import SharedPrefsService
import 'package:pearlibrary/utils/app_colors.dart';
import 'package:pearlibrary/utils/app_styles.dart';
// Removed RoundedButton import as it's not used here anymore

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SharedPrefsService _prefsService = SharedPrefsService();

  @override
  void initState() {
    super.initState();
    _checkLoginStatusAndNavigate();
  }

  Future<void> _checkLoginStatusAndNavigate() async {
    // Wait for a short duration for splash effect
    await Future.delayed(const Duration(seconds: 3));

    // Check login status
    final bool isLoggedIn = await _prefsService.isUserLoggedIn();

    // Navigate based on login status
    if (mounted) { // Check if the widget is still in the tree
      if (isLoggedIn) {
        print("User is logged in, navigating to Home");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        print("User is not logged in, navigating to Login");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.menu_book, // Example icon
              size: size.width * 0.3,
              color: AppColors.primary,
            ),
            const SizedBox(height: 40),
            const Text(
              "ZK Library",
              style: AppStyles.headline1,
            ),
            const SizedBox(height: 10),
            Text(
              "Buy and read your favorite books",
              style: AppStyles.subtitle1,
            ),
            SizedBox(height: size.height * 0.1),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            const SizedBox(height: 20),
            const Text("Loading..."),
          ],
        ),
      ),
    );
  }
}

