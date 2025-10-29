// lib/features/auth/login/login_google_page.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:workradar/utils/theme.dart'; // opsional, kalau kamu punya AppTheme
import 'package:workradar/features/auth/login/login_googlekonfirmasi_page.dart'; // import halaman konfirmasi

class LoginGooglePage extends StatelessWidget {
  const LoginGooglePage({super.key});

  // contoh data akun — ganti dengan data nyata jika diperlukan
  final List<Map<String, String>> accounts = const [
    {'name': 'angelbatam1@gmail.com', 'subtitle': 'email@gmail.com'},
    {'name': 'afangku1105@gmail.com', 'subtitle': 'email@gmail.com'},
  ];

  @override
  Widget build(BuildContext context) {
    final primary = AppTheme.primaryTeal; // atau warna langsung
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
            Image.asset(
              'assets/google.png', // kecilkan icon Google; ganti path sesuai assetmu
              width: 30,
              height: 30,
              fit: BoxFit.contain,
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth > 700
                ? 520.0
                : double.infinity;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),

                      // Company logo
                      Image.asset(
                        'assets/workradar_logo.png',
                        width: 90,
                        height: 90,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'Pilih akun untuk',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 6),

                      // subtitle with colored app name
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                          children: [
                            const TextSpan(text: 'melanjutkan ke '),
                            TextSpan(
                              text: 'WorkRadar',
                              style: TextStyle(
                                color: primary,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // list akun
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (int i = 0; i < accounts.length; i++) ...[
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.purple.shade700,
                                  child: Text(
                                    (accounts[i]['name'] ?? 'U')
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(
                                  accounts[i]['name'] ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  accounts[i]['subtitle'] ?? '',
                                  style: const TextStyle(color: Colors.black54),
                                ),
                                onTap: () {
                                  // --- NAVIGASI KE HALAMAN KONFIRMASI ---
                                  final selectedEmail =
                                      accounts[i]['name'] ?? '';
                                  // Jika kamu hanya ingin melakukan navigasi untuk afangku1105@gmail.com,
                                  // uncomment block berikut dan gunakan kondisi:
                                  //
                                  // if (selectedEmail == 'afangku1105@gmail.com') {
                                  //   Navigator.of(context).push(
                                  //     MaterialPageRoute(
                                  //       builder: (_) => LoginGoogleConfirmPage(email: selectedEmail),
                                  //     ),
                                  //   );
                                  // } else {
                                  //   // fallback: tampilkan snack atau lakukan aksi lain
                                  // }

                                  // Umum: navigasi untuk semua pilihan akun (lebih fleksibel)
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => LoginGoogleConfirmPage(
                                        email: selectedEmail,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              if (i < accounts.length - 1)
                                const Divider(height: 1),
                            ],
                            // separator & "Use another account"
                            const Divider(height: 1),
                            ListTile(
                              leading: const Icon(Icons.person_add_outlined),
                              title: const Text(
                                'Use another account',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Use another account (simulasi)',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      const Divider(),

                      const SizedBox(height: 10),

                      // Informational paragraph
                      RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 13.5,
                            height: 1.4,
                          ),
                          children: [
                            const TextSpan(
                              text:
                                  'Untuk melanjutkan, Google akan membagikan nama, alamat email, preferensi bahasa, dan foto profil Anda dengan Perusahaan. Sebelum menggunakan aplikasi ini, Anda dapat meninjau Kebijakan Privasi Perusahaan. ',
                            ),
                            TextSpan(
                              text: 'kebijakan privasi',
                              style: const TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Buka kebijakan privasi (simulasi)',
                                      ),
                                    ),
                                  );
                                },
                            ),
                            const TextSpan(text: ' dan '),
                            TextSpan(
                              text: 'ketentuan layanan',
                              style: const TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Buka ketentuan layanan (simulasi)',
                                      ),
                                    ),
                                  );
                                },
                            ),
                            const TextSpan(text: '.'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // footer links (small)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DropdownButton<String>(
                            value: 'Indonesia',
                            items: const [
                              DropdownMenuItem(
                                value: 'Indonesia',
                                child: Text('Indonesia'),
                              ),
                              DropdownMenuItem(
                                value: 'English',
                                child: Text('English'),
                              ),
                            ],
                            onChanged: (_) {},
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {},
                                child: const Text('Help'),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text('Privacy'),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text('Terms'),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
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
