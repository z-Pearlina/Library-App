import 'package:flutter/material.dart';
import 'package:pearlibrary/data/repositories/user_repository_impl.dart'; // Direct import for simplicity
import 'package:pearlibrary/domain/repositories/user_repository.dart';
import 'package:pearlibrary/screens/home/home_screen.dart';
import 'package:pearlibrary/screens/auth/login_screen.dart';
import 'package:pearlibrary/utils/app_colors.dart';
import 'package:pearlibrary/utils/app_styles.dart';
import 'package:pearlibrary/widgets/rounded_button.dart';
import 'package:pearlibrary/services/shared_prefs_service.dart'; // Import SharedPreferences service

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController(); // Added name controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final UserRepository _userRepository = UserRepositoryImpl();
  final SharedPrefsService _prefsService = SharedPrefsService(); // Instantiate SharedPrefsService
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final name = _nameController.text.trim(); // Get name
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      try {
        // Call registerUser with name
        final user = await _userRepository.registerUser(name, email, password);
        if (user != null) {
          // Signup successful
          // Save session using SharedPreferences (including name)
          await _prefsService.saveUserSession(userId: user.id, userName: user.name);

          // Navigate to HomeScreen, replacing the signup/login stack
          if (mounted) { // Check if widget is still mounted
             Navigator.pushAndRemoveUntil(
               context,
               MaterialPageRoute(builder: (context) => const HomeScreen()),
               (Route<dynamic> route) => false, // Remove all previous routes
             );
          }
        } else {
          // User already exists or other registration error
          setState(() {
            _errorMessage = 'Email already registered. Please try logging in.';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'An error occurred during signup. Please try again.';
        });
        print("Signup Error: $e");
      }

      // Ensure isLoading is set to false even if widget is unmounted during async gap
      if (mounted) {
         setState(() {
           _isLoading = false;
         });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose(); // Dispose name controller
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Create Account",
                  style: AppStyles.headline1,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Sign up to get started",
                  style: AppStyles.subtitle1,
                ),
                SizedBox(height: size.height * 0.05),
                // Added Name Field
                _buildTextField(
                  controller: _nameController,
                  hintText: "Full Name",
                  icon: Icons.person_outline,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _emailController,
                  hintText: "Email Address",
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                       return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _passwordController,
                  hintText: "Password",
                  icon: Icons.lock_outline,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _confirmPasswordController,
                  hintText: "Confirm Password",
                  icon: Icons.lock_outline,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.redAccent, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator(color: AppColors.primary)
                    : RoundedButton(
                        text: "SIGN UP",
                        press: _signup,
                        widthFactor: 0.8,
                      ),
                SizedBox(height: size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Already have an Account ? ",
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate back to Login Screen
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: AppStyles.bodyText1,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppStyles.bodyText2,
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
        filled: true,
        fillColor: AppColors.cardBackground.withOpacity(0.8),
        contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
      validator: validator,
    );
  }
}

