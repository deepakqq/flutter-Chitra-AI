import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';


import 'app/app.dart';
import 'core/config/app_constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox(AppConstants.boxCategories);
  await Hive.openBox(AppConstants.boxPrompts);
  await Hive.openBox(AppConstants.boxConfig);
  await Hive.openBox(AppConstants.boxFavorites);
  await Hive.openBox(AppConstants.boxMeta);

  bool firebaseReady = true;
  try {
    // await Firebase.initializeApp();
  } catch (e) {
    firebaseReady = false;
    debugPrint('Firebase init failed: $e');
  }

  runApp(App(firebaseReady: firebaseReady));
}
