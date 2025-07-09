import 'package:flutter/material.dart';
import 'edit_profil_screen.dart';
import '../auth/login_page.dart';

class ProfilScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/profile_default.png'),
          ),
          const SizedBox(height: 10),
          const Text(
            'Nama Pengguna',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Text(
            'email@example.com',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 30),
          _buildInfoTile(Icons.badge, "NISN", "1234567890"),
          _buildInfoTile(Icons.school, "Kelas", "XII IPA 1"),
          _buildInfoTile(Icons.phone_android, "No. Telepon", "0812-3456-7890"),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilScreen()),
              );
            },
            icon: const Icon(Icons.edit),
            label: const Text("Edit Profil"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[900],
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 10),
            Text("$title:", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 5),
            Flexible(child: Text(value)),
          ],
        ),
        const Divider(height: 25),
      ],
    );
  }
}
