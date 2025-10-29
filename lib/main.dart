// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// providers
import 'package:workradar/features/auth/login/login_provider.dart';

// pages (dipakai di routes)
import 'package:workradar/features/auth/login/login_page.dart';
import 'package:workradar/features/auth/register/register_page.dart';
import 'package:workradar/forgetpassword/forgetpassword_page.dart';

// theme
import 'package:workradar/utils/theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        // tambahkan provider global lain di sini jika perlu
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workradar',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/reset': (context) => const ResetPasswordPage(),
      },
    );
  }
}
