import 'package:flutter/material.dart';
import 'profile_widgets.dart';
import 'profile_provider.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final ProfilProvider provider = ProfilProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Row(
              children: [
                ProfilWidgets.profileImage(),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Hai Kharlos daylo saut silaban',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ProfilWidgets.proFeatureCard(),
            const SizedBox(height: 24),
            const Text(
              'Beban Kerja',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 4),
            const Text(
              'Lihat tren beban kerja dan bantu prioritas hari ini',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            DropdownButton<String>(
              value: provider.selectedFilter,
              items: provider.filters.map((filter) {
                return DropdownMenuItem<String>(
                  value: filter,
                  child: Text(filter),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  provider.selectedFilter = value!;
                });
              },
            ),
            const SizedBox(height: 24),
            Expanded(child: ProfilWidgets.workloadChart(provider.workloadData)),
          ],
        ),
      ),
      bottomNavigationBar: ProfilWidgets.profilBottomNavigationBar(1),
    );
  }
}
