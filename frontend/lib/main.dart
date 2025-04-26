import 'package:flutter/material.dart';
import 'package:frontend/screens/splash_screen.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/expense_service.dart';
import 'package:frontend/theme/app_theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Using MultiProvider for dependency injection and state management
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ExpenseService()),
      ],
      child: MaterialApp(
        title: 'Expense Tracker',
        debugShowCheckedModeBanner: false, // Remove debug banner for clean UI
        theme: AppTheme.lightTheme, // Custom light theme
        darkTheme: AppTheme.darkTheme, // Custom dark theme
        themeMode: ThemeMode.system, // Use system theme by default
        home: const SplashScreen(), // Start with splash screen
      ),
    );
  }
}
