import 'package:flutter/material.dart';

class RegisterProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscure = true;
  bool isLoading = false;

  void toggleObscure() {
    obscure = !obscure;
    notifyListeners();
  }

  Future<void> register() async {
    isLoading = true;
    notifyListeners();

    // simulasi proses register (misalnya ke database)
    await Future.delayed(const Duration(seconds: 1));

    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
