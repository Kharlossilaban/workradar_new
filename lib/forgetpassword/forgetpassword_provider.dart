// lib/forgetpassword/forgetpassword_provider.dart
import 'package:flutter/material.dart';

/// Provider untuk halaman Forget / Reset Password.
/// - Menyimpan controller, formKey, loading state
/// - requestOtp() saat tombol ditekan (simulasi)
class ForgetPasswordProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  bool _validateInput() {
    final f = formKey.currentState;
    if (f == null) return false;
    return f.validate();
  }

  /// Simulasi request OTP. Kembalikan true saat sukses.
  Future<bool> requestOtp() async {
    if (!_validateInput()) return false;

    isLoading = true;
    notifyListeners();

    try {
      // Ganti dengan panggilan API nyata jika sudah tersedia.
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      debugPrint('requestOtp error: $e');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Kosongkan field
  void clear() {
    emailController.clear();
    usernameController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    super.dispose();
  }
}
