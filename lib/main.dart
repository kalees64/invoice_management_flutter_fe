import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:invoice_management_flutter_fe/providers/invoice_provider.dart';
import 'package:invoice_management_flutter_fe/providers/payment_provider.dart';
import 'package:invoice_management_flutter_fe/providers/product_provider.dart';
import 'package:invoice_management_flutter_fe/providers/quotation_provider.dart';
import 'package:invoice_management_flutter_fe/providers/receipt_provider.dart';
import 'package:invoice_management_flutter_fe/providers/user_provider.dart';
import 'package:invoice_management_flutter_fe/screens/landing_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => QuotationProvider()),
        ChangeNotifierProvider(create: (_) => InvoiceProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => ReceiptProvider()),
      ],
      child: const MainApp(),
    ),
  );
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
