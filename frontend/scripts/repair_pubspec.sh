#!/usr/bin/env bash
set -euo pipefail

cat > pubspec.yaml <<'YAML'
name: frontend
description: FarmZyy Frontend Application
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.3.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: '1.0.8'
  dio: '5.4.0'
  flutter_riverpod: '2.5.1'
  riverpod_annotation: '2.3.0'
  provider: '6.1.2'
  shared_preferences: '2.2.0'
  flutter_secure_storage: '9.0.0'
  google_fonts: '6.2.1'
  cached_network_image: '3.3.0'
  fl_chart: '0.64.0'
  intl: '0.19.0'
  logger: '2.0.1'

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: '6.0.0'
  build_runner: '2.4.0'
  riverpod_generator: '2.3.0'

flutter:
  uses-material-design: true
  assets:
    - assets/images/
YAML

echo "✅ Repaired pubspec.yaml"