import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'utils/app_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLogger.info('🚀 Starting FarmZyy Application');
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

