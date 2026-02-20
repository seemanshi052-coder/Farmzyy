import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/splash_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/navigation/main_navigation.dart';
import 'features/crop/screens/crop_recommendation_screen.dart';
import 'features/yield/screens/yield_prediction_screen.dart';
import 'features/pest/screens/pest_prediction_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: FarmZyyApp(),
    ),
  );
}

class FarmZyyApp extends StatelessWidget {
  const FarmZyyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FarmZyy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/home': (_) => const MainNavigation(),
        '/crop': (_) => const CropRecommendationScreen(),
        '/yield': (_) => const YieldPredictionScreen(),
        '/pest': (_) => const PestPredictionScreen(),
      },
    );
  }
}
