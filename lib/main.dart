import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:invoice_management_flutter_fe/screens/landing_screen.dart';
import 'package:invoice_management_flutter_fe/services/user_service.dart';
import 'package:invoice_management_flutter_fe/store/products/product_bloc.dart';
import 'package:invoice_management_flutter_fe/store/user/user_bloc.dart';
import 'package:invoice_management_flutter_fe/store/user/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProductBloc()),
        BlocProvider(
          create: (context) => UserBloc(UserRepository(UserService())),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LandingScreen(),
        scrollBehavior: ScrollBehavior().copyWith(scrollbars: true),
        theme: ThemeData(useMaterial3: true),
        themeMode: ThemeMode.light,
      ),
    );
  }
}
