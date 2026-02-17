<<<<<<< HEAD
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

=======

>>>>>>> f124215ba6bd6d49555cd1c85f21e13b1bd7f198
