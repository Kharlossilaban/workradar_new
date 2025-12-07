// lib/features/auth/reset/verify_otp_page.dart
import 'package:flutter/material.dart';
import 'package:workradar/utils/theme.dart';

// IMPORT: halaman tujuan setelah verifikasi OTP
import 'package:workradar/features/auth/forgetpassword/forgetpassword_page.dart';

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({super.key});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

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

  Future<void> _submitOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      // TOO: ganti dengan verifikasi OTP ke backend jika ada
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      // Beri notifikasi singkat (opsional)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP terverifikasi (simulasi)')),
      );

      // Matikan loading dulu
      if (mounted) setState(() => _isLoading = false);

      // Setelah verifikasi sukses: navigasi ke ResetPasswordPage
      // Gunakan pushReplacement agar VerifyOtpPage tidak tersimpan di back stack
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ResetPasswordPage()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal verifikasi: $e')));
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppTheme.primaryTeal;

    return Scaffold(
      backgroundColor: AppTheme.themeData.scaffoldBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final horizontal = width > 600 ? width * 0.18 : 24.0;
            final maxFormWidth = width > 700 ? 520.0 : double.infinity;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontal,
                vertical: 20,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 20,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),

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

                      Align(
                        alignment: Alignment.topCenter,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: maxFormWidth),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Kode OTP',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Single numeric OTP field (sesuaikan validator sesuai kebutuhan)
                                TextFormField(
                                  controller: _otpController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  decoration: _inputDecoration(
                                    hint: 'Masukkan kode OTP (contoh: 123456)',
                                  ),
                                  maxLength: 6,
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty)
                                      return 'Kode OTP wajib diisi';
                                    if (v.trim().length < 4)
                                      return 'Kode OTP tidak valid';
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 8),
                                // optional: info / resend link
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(), // placeholder untuk menjaga jarak
                                    TextButton(
                                      onPressed: () {
                                        // Implement resend logic
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Kode OTP dikirim ulang (simulasi)',
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Kirim ulang',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Button bottom
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: maxFormWidth),
                            child: SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _submitOtp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Kirim Kode OTP',
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
