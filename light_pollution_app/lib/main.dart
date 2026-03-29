import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';
import 'core/services/auth_service.dart';
import 'features/community/models/mock_data.dart';
import 'features/reserve/providers/reserve_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    await MockData.seedFirestore();
    await seedTripsIfNeeded();
    await AuthService().ensurePremiumStatus();
  } catch (e) {
    debugPrint('Initialization error: $e');
  }
  runApp(const ProviderScope(child: LightPollutionApp()));
}
