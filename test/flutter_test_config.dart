import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Layout checks must measure the same bundled font used in production.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final font = FontLoader('GameRoboto');
  for (final weight in ['Regular', 'Medium', 'Bold']) {
    font.addFont(rootBundle.load('assets/fonts/Roboto-$weight.ttf'));
  }
  await font.load();
  await testMain();
}
