import 'package:flutter/material.dart';
import 'package:pearlibrary/screens/auth/login_screen.dart';
import 'package:pearlibrary/services/shared_prefs_service.dart';
import 'package:pearlibrary/domain/usecases/get_logged_in_user_name_usecase.dart';
import 'package:pearlibrary/utils/app_colors.dart';
import 'package:pearlibrary/utils/app_styles.dart';
import 'package:pearlibrary/widgets/rounded_button.dart'; // For logout button

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SharedPrefsService _prefsService = SharedPrefsService();
  late final GetLoggedInUserNameUseCase _getUserNameUseCase;
  late Future<String?> _userNameFuture; // Use FutureBuilder

  @override
  void initState() {
    super.initState();
    _getUserNameUseCase = GetLoggedInUserNameUseCase(_prefsService);
    _userNameFuture = _loadUserName(); // Initialize the future
    print("ProfileScreen initState: Kicking off _loadUserName");
  }

  Future<String?> _loadUserName() async {
    print("ProfileScreen _loadUserName: Attempting to get user name...");
    try {
      final name = await _getUserNameUseCase.execute();
      print("ProfileScreen _loadUserName: Retrieved name: $name");
      return name;
    } catch (e) {
      print("Error loading user name in ProfileScreen: $e");
      return null; // Return null on error
    }
  }

  Future<void> _logout() async {
    await _prefsService.clearUserSession();
    if (mounted) {
      // Navigate back to Login Screen and remove all previous routes
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile', style: AppStyles.headline2),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimary), // Ensure back button is visible
      ),
      body: FutureBuilder<String?>(
        future: _userNameFuture,
        builder: (context, snapshot) {
          print("ProfileScreen FutureBuilder: snapshot state = ${snapshot.connectionState}");
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("ProfileScreen FutureBuilder: Waiting for user name...");
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (snapshot.hasError) {
            print("ProfileScreen FutureBuilder: Error loading name - ${snapshot.error}");
            return const Center(child: Text('Error loading profile', style: AppStyles.bodyText2));
          }

          final userName = snapshot.data;
          print("ProfileScreen FutureBuilder: User name loaded: $userName");

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Icon(
                      Icons.person_outline,
                      size: 50,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    userName != null && userName.isNotEmpty
                        ? 'Welcome, $userName!'
                        : 'Welcome!', // Fallback text
                    style: AppStyles.headline1.copyWith(fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Manage your account details here.', // Placeholder text
                    style: AppStyles.bodyText2,
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(), // Pushes logout button to the bottom
                  RoundedButton(
                    text: "LOGOUT",
                    press: _logout,
                    color: Colors.redAccent.withOpacity(0.8),
                    textColor: Colors.white,
                    widthFactor: 0.8,
                  ),
                  const SizedBox(height: 20), // Some padding at the bottom
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

