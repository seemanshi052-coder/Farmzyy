import 'package:flutter/material.dart';
import '../features/authentication/login_screen.dart';
import '../features/authentication/otp_screen.dart';
import '../features/authentication/splash_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/predictions/yield_prediction_screen.dart';
import '../features/predictions/pest_risk_screen.dart';
import '../features/predictions/price_forecast_screen.dart';
import '../features/market/market_screen.dart';

/// App Routes
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String home = '/home';
  static const String chatbot = '/chatbot';
  static const String crop = '/crop';
  static const String predictions = '/predictions';
  static const String yieldPrediction = '/predictions/yield';
  static const String pestRisk = '/predictions/pest';
  static const String priceForecast = '/predictions/price';
  static const String weather = '/weather';
  static const String market = '/market';
  static const String support = '/support';
}

/// App Router Configuration
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.otp:
        final phone = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => OtpScreen(phone: phone),
        );

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());

      case AppRoutes.yieldPrediction:
        return MaterialPageRoute(builder: (_) => const YieldPredictionScreen());

      case AppRoutes.pestRisk:
        return MaterialPageRoute(builder: (_) => const PestRiskScreen());

      case AppRoutes.priceForecast:
        final crop = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => PriceForecastScreen(initialCrop: crop),
        );

      case AppRoutes.market:
        return MaterialPageRoute(builder: (_) => const MarketScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('404')),
            body: const Center(
              child: Text('Page not found'),
            ),
          ),
        );
    }
  }
}
