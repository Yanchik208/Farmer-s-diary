
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers.dart/journal_controller2.dart';
import 'screens/cover_screen4.dart';

void main() {
  print('🚀 [MAIN] Запуск програми "Щоденник фермера"...');
  // Ініціалізація контролера GetX
  Get.put(JournalController());
  runApp(const FarmerJournalApp());
}

class FarmerJournalApp extends StatelessWidget {
  const FarmerJournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Farmer`s diary',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
      home: const CoverScreen(),
    );
  }
}