// lib/features/auth/reset/reset_password_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workradar/utils/theme.dart';
import 'package:workradar/features/auth/forgetpassword/forgetpassword_provider.dart';

/// Public page — bisa dipanggil dari luar, biarkan ada Key param (konvensi Flutter)
class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Buat provider khusus untuk halaman reset (atau reuse provider dari folder forgetpassword)
    return ChangeNotifierProvider(
      create: (_) => ForgetPasswordProvider(),
      child: const _ResetViewWrapper(),
    );
  }
}

/// Wrapper stateless untuk memisahkan provider dari Stateful widget
/// (tidak perlu menerima `key` karena ini private dan tidak pernah dipanggil dengan key)
class _ResetViewWrapper extends StatelessWidget {
  const _ResetViewWrapper();

  @override
  Widget build(BuildContext context) => const _ResetView();
}

/// Statefull view utama (memerlukan state karena ada toggle visibility password)
class _ResetView extends StatefulWidget {
  const _ResetView();

  @override
  State<_ResetView> createState() => _ResetViewState();
}

class _ResetViewState extends State<_ResetView> {
  final TextEditingController _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      filled: true,
      fillColor: Colors.grey[100],
      counterText: '', // sembunyikan counter jika ada maxLength
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
                      const SizedBox(height: 18),

                      // Title
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

                      const SizedBox(height: 28),

                      // Form area
                      Align(
                        alignment: Alignment.topCenter,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: maxFormWidth),
                          child: Form(
                            key: provider.formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Gmail
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

                                const SizedBox(height: 20),

                                // Username
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

                                const SizedBox(height: 20),

                                // Password baru
                                const Text(
                                  'Password baru',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscure,
                                  decoration:
                                      _inputDecoration(
                                        hint: 'Masukan Password Baru Kamu',
                                      ).copyWith(
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscure
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscure = !_obscure;
                                            });
                                          },
                                        ),
                                      ),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return 'Password wajib diisi';
                                    }
                                    if (v.trim().length < 6) {
                                      return 'Password minimal 6 karakter';
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

                      // Bottom button
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: maxFormWidth),
                            child: SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: provider.isLoading
                                    ? null
                                    : () async {
                                        FocusScope.of(context).unfocus();

                                        // Validasi semua field lewat formKey
                                        final okValidation =
                                            provider.formKey.currentState
                                                ?.validate() ??
                                            false;
                                        if (!okValidation) {
                                          return;
                                        }

                                        // Simulasi proses reset (ganti dengan method provider yang sesuai jika ada)
                                        // Saya reuse provider.requestOtp() hanya untuk simulasi loading; ganti bila membuat method resetPassword()
                                        final ok = await provider.requestOtp();
                                        if (!context.mounted) {
                                          return;
                                        }

                                        if (ok) {
                                          // Sukses: tampilkan pesan berhasil (atau navigasi ke login)
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Password berhasil direset (simulasi)',
                                              ),
                                            ),
                                          );

                                          // contoh: kembali ke halaman login
                                          Navigator.of(
                                            context,
                                          ).popUntil((route) => route.isFirst);
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Gagal reset — coba lagi',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
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
                                        'Reset Sandi',
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
