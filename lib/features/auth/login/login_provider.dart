// lib/features/auth/login/login_provider.dart
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  bool obscure = true;
  bool isLoading = false;

  // properti baru untuk menandai status login
  bool isAuthenticated = false;

  void toggleObscure() {
    obscure = !obscure;
    notifyListeners();
  }

  // Tetap Future<void>, tapi set isAuthenticated yg bisa dibaca dari UI
  Future<void> login() async {
    isLoading = true;
    notifyListeners();

    // contoh: simulasi panggilan API
    await Future.delayed(const Duration(seconds: 1));

    // contoh validasi sederhana: (ganti dgn logic aslinya)
    final emailNotEmpty = emailController.text.trim().isNotEmpty;
    final passwordValid = passwordController.text.trim().length >= 8;

    if (emailNotEmpty && passwordValid) {
      // login sukses
      isAuthenticated = true;
    } else {
      // login gagal
      isAuthenticated = false;
    }

    isLoading = false;
    notifyListeners();
  }

  // opsional: panggil ini saat logout
  void logout() {
    isAuthenticated = false;
    notifyListeners();
  }
}
