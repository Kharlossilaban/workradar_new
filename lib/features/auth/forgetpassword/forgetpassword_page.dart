// lib/features/auth/reset/reset_password_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workradar/utils/theme.dart';
import 'package:workradar/features/auth/forgetpassword/forgetpassword_provider.dart';
import 'package:workradar/features/auth/forgetpassword/forgetpassword_kodeotp.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForgetPasswordProvider(),
      child: const _ResetView(),
    );
  }
}

class _ResetView extends StatelessWidget {
  const _ResetView();

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ForgetPasswordProvider>();
    final primary = AppTheme.primaryTeal;

    return Scaffold(
      backgroundColor: AppTheme.themeData.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Reset Sandi'), elevation: 0.5),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final horizontalPadding = width > 600 ? width * 0.18 : 24.0;
            final maxFormWidth = width > 700 ? 520.0 : double.infinity;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 24,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 24,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),
                      const Center(
                        child: Text(
                          'Reset Sandi',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Align(
                        alignment: Alignment.topCenter,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: maxFormWidth),
                          child: Form(
                            key: provider.formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Gmail',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: provider.emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: _inputDecoration(
                                    hint: 'contoh@gmail.com',
                                  ),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return 'Email wajib diisi';
                                    }
                                    if (!RegExp(
                                      r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$',
                                    ).hasMatch(v)) {
                                      return 'Format email tidak valid';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Username',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: provider.usernameController,
                                  decoration: _inputDecoration(
                                    hint: 'Masukan username kamu',
                                  ),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return 'Username wajib diisi';
                                    }
                                    if (v.trim().length < 3) {
                                      return 'Username minimal 3 karakter';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: maxFormWidth),
                            child: SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: provider.isLoading
                                    ? null
                                    : () async {
                                        FocusScope.of(context).unfocus();

                                        final navigator = Navigator.of(context);
                                        final messenger = ScaffoldMessenger.of(
                                          context,
                                        );

                                        try {
                                          final ok = await provider
                                              .requestOtp();
                                          if (!context.mounted) return;

                                          if (ok == true) {
                                            messenger.showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Kode OTP terkirim (simulasi)',
                                                ),
                                              ),
                                            );
                                            navigator.push(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    const VerifyOtpPage(),
                                              ),
                                            );
                                          } else {
                                            messenger.showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Gagal minta OTP — periksa input',
                                                ),
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          if (!context.mounted) return;
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Terjadi kesalahan: $e',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: provider.isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Minta Kode OTP',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
