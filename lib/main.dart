import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pearlibrary/providers/cart_provider.dart';
import 'package:pearlibrary/providers/favorites_provider.dart';
import 'package:pearlibrary/screens/splash/splash_screen.dart';
import 'package:pearlibrary/utils/app_colors.dart';
import 'package:pearlibrary/utils/app_styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Wrap MaterialApp with MultiProvider to make providers available globally
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        // Add other global providers here if needed
      ],
      child: MaterialApp(
        title: 'Pear Library',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          fontFamily: 'Poppins', // Ensure Poppins font is added
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.background,
            elevation: 0,
            iconTheme: IconThemeData(color: AppColors.textPrimary),
            titleTextStyle: AppStyles.headline2,
            centerTitle: true,
          ),
          colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColors.primary),
        ),
        // Start with the SplashScreen
        home: const SplashScreen(),
        // Define routes here if needed for named navigation
        // routes: {
        //   '/home': (context) => const HomeScreen(),
        //   '/login': (context) => const LoginScreen(), // Example
        // },
      ),
    );
  }
}

