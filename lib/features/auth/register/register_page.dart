// lib/features/auth/register/register_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workradar/features/auth/login/login_provider.dart';
import 'package:workradar/features/auth/register/register_kodeotp.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            filled: true,
            fillColor: Colors.grey[200],
            suffixIcon: suffix,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(
      context,
    ); // gunakan provider yang sama jika controller ada di sini
    final primary = const Color.fromRGBO(36, 161, 156, 100);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Buat Akun')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                label: 'Email',
                hint: 'contoh@gmail.com',
                controller: provider.emailController,
              ),
              const SizedBox(height: 14),
              _buildTextField(
                label: 'Username',
                hint: 'Masukan Username Kamu',
                controller: provider.usernameController,
              ),
              const SizedBox(height: 14),
              _buildTextField(
                label: 'Password',
                hint: 'At least 8 characters',
                controller: provider.passwordController,
                obscure: provider.obscure,
                suffix: IconButton(
                  icon: Icon(
                    provider.obscure ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () => provider.toggleObscure(),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Aksi: buka halaman kode OTP
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateAccountOtpScreen(),
                        // Jika halaman OTP menerima parameter (mis. email), ganti dengan:
                        // builder: (context) => RegisterKodeOtpPage(email: provider.emailController.text),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Daftar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
