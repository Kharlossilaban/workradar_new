// lib/features/auth/login/login_google_confirm_page.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Halaman konfirmasi Google sign-in (UI-only).
/// - Menerima parameter [email] supaya dinamis
/// - Tombol "Setuju dan bagikan" adalah ElevatedButton berwarna
/// - Ada animasi klik (scale) saat tombol ditekan
class LoginGoogleConfirmPage extends StatefulWidget {
  final String email;

  const LoginGoogleConfirmPage({super.key, required this.email});

  @override
  State<LoginGoogleConfirmPage> createState() => _LoginGoogleConfirmPageState();
}

class _LoginGoogleConfirmPageState extends State<LoginGoogleConfirmPage>
    with SingleTickerProviderStateMixin {
  // warna primary — ganti dengan AppTheme.primaryTeal jika kamu punya AppTheme
  static const Color primary = Color(0xFF0FA39A);

  // Animasi scale untuk tombol
  double _buttonScale = 1.0;
  bool _isProcessing = false;

  // singkatkan animasi tekan
  Future<void> _animateButtonAndProceed() async {
    if (_isProcessing) return;
    setState(() {
      _isProcessing = true;
      _buttonScale = 0.97; // sedikit mengecil
    });

    // durasi tekan
    await Future.delayed(const Duration(milliseconds: 100));

    // kembali ke ukuran normal
    setState(() => _buttonScale = 1.0);

    await Future.delayed(const Duration(milliseconds: 120));

    if (!mounted) return;

    // simulasi proses sign-in / share consent
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Setuju dan bagikan — simulasi...')),
    );

    // contoh: setelah sukses, kembali ke layar sebelumnya
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    Navigator.of(context).pop(); // atau lanjut ke layar lain
    setState(() => _isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    final String email = widget.email;
    final maxWidth = MediaQuery.of(context).size.width > 700
        ? 520.0
        : double.infinity;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 8),
            // kecilkan icon Google, ganti path jika kamu pakai nama file lain
            Image.asset(
              'assets/google.png',
              width: 14,
              height: 14,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const SizedBox(width: 14, height: 14),
            ),
            const SizedBox(width: 8),
            const Text(
              'Sign in with Google',
              style: TextStyle(color: Colors.black87, fontSize: 14),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 22.0,
                vertical: 18,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 22),

                  // Judul
                  Column(
                    children: [
                      const Text(
                        'Izinkan Google untuk\nmembuat Anda login ke',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'WorkRadar',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // akun yang dipilih (avatar + email)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.purple.shade700,
                        child: Text(
                          email.isNotEmpty ? email[0].toUpperCase() : 'U',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          email,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Informational paragraph (rich text dengan link)
                  RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        height: 1.6,
                      ),
                      children: [
                        const TextSpan(
                          text:
                              'Dengan melanjutkan, Google akan membagikan nama, alamat email, dan foto profil Anda ke WorkRadar. Lihat ',
                        ),
                        TextSpan(
                          text: 'Kebijakan Privasi',
                          style: const TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // aksi: buka kebijakan (simulasi)
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Buka Kebijakan Privasi (simulasi)',
                                  ),
                                ),
                              );
                            },
                        ),
                        const TextSpan(text: ' dan '),
                        TextSpan(
                          text: 'Persyaratan Layanan',
                          style: const TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Buka Persyaratan Layanan (simulasi)',
                                  ),
                                ),
                              );
                            },
                        ),
                        const TextSpan(text: ' WorkRadar.'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Anda dapat mengelola Login dengan google di Akun Google Anda',
                      style: TextStyle(color: Colors.black54, fontSize: 13.5),
                    ),
                  ),

                  const Spacer(),

                  // ACTIONS: Batal (TextButton) + Setuju (ElevatedButton with scale animation)
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: _isProcessing
                              ? null
                              : () => Navigator.of(context).pop(),
                          child: const Text(
                            'Batal',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AnimatedScale(
                          scale: _buttonScale,
                          duration: const Duration(milliseconds: 120),
                          curve: Curves.easeOut,
                          child: SizedBox(
                            height: 46,
                            child: ElevatedButton(
                              onPressed: _isProcessing
                                  ? null
                                  : _animateButtonAndProceed,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child: _isProcessing
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Setuju dan bagikan',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
