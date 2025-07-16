import 'package:flutter/material.dart';
import '../../services/siswa_service.dart';
import '../../models/siswa_model.dart';
import 'edit_profil_screen.dart';
import '../auth/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilScreen extends StatefulWidget {
  @override
  _ProfilScreenState createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  Siswa? siswa;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final data = await SiswaService.getProfile();
    print("🔍 Profil diterima: ${data?.nama}, ${data?.email}, ${data?.nisn}");
    setState(() {
      siswa = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("Profil")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final fotoUrl = siswa?.fotoUrl;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: (fotoUrl != null && fotoUrl.isNotEmpty)
                  ? NetworkImage(fotoUrl)
                  : AssetImage('assets/images/profile_default.png') as ImageProvider,
            ),
            const SizedBox(height: 10),
            Text(
              siswa?.nama ?? 'Nama tidak tersedia',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              siswa?.email ?? 'Email tidak tersedia',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            _buildInfoTile(Icons.badge, "NISN", siswa?.nisn ?? '-'),
            _buildInfoTile(Icons.school, "Kelas", siswa?.kelas ?? '-'),
            _buildInfoTile(Icons.phone_android, "No. Telepon", siswa?.telepon ?? '-'),
            _buildInfoTile(Icons.location_on, "Alamat", siswa?.alamat ?? '-'),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilScreen()),
                );
              },
              icon: Icon(Icons.edit),
              label: Text("Edit Profil"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[900],
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () async {
              
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('token');
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false,
                );
              },

              icon: Icon(Icons.logout),
              label: Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
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
            Text("$title:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 5),
            Flexible(child: Text(value)),
          ],
        ),
        const Divider(height: 25),
      ],
    );
  }
}
