import 'package:flutter/material.dart';
import 'package:invoice_management_flutter_fe/screens/landing_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LandingScreen(),
      scrollBehavior: ScrollBehavior().copyWith(scrollbars: true),
      theme: ThemeData(useMaterial3: true),
      themeMode: ThemeMode.light,
    );
  }
}
