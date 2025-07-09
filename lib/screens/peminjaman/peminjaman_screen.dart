import 'package:flutter/material.dart';

class PeminjamanScreen extends StatefulWidget {
  @override
  _PeminjamanScreenState createState() => _PeminjamanScreenState();
}

class _PeminjamanScreenState extends State<PeminjamanScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  final List<Map<String, String>> sedangDipinjam = [
    {
      "judul": "Fisika Dasar",
      "pengarang": "Budi Santosa",
      "tanggalPinjam": "2025-06-20",
      "tanggalKembali": "2025-07-05",
      "gambar": "https://via.placeholder.com/120"
    },
    {
      "judul": "Laskar Pelangi",
      "pengarang": "Andrea Hirata",
      "tanggalPinjam": "2025-06-25",
      "tanggalKembali": "2025-07-10",
      "gambar": "https://via.placeholder.com/120"
    },
  ];

  final List<Map<String, String>> riwayatPeminjaman = [
    {
      "judul": "Matematika Wajib",
      "pengarang": "Siti Aisyah",
      "tanggalPinjam": "2025-05-10",
      "tanggalKembali": "2025-05-25",
      "gambar": "https://via.placeholder.com/120"
    },
    {
      "judul": "KIMIA SMA",
      "pengarang": "Dr. Harun",
      "tanggalPinjam": "2025-04-01",
      "tanggalKembali": "2025-04-15",
      "gambar": "https://via.placeholder.com/120"
    },
  ];

  List<Map<String, String>> get filteredSedangDipinjam => sedangDipinjam
      .where((b) => b["judul"]!.toLowerCase().contains(searchQuery.toLowerCase()))
      .toList();

  List<Map<String, String>> get filteredRiwayat => riwayatPeminjaman
      .where((b) => b["judul"]!.toLowerCase().contains(searchQuery.toLowerCase()))
      .toList();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Cari judul buku...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
            const SizedBox(height: 20),

            // 🔵 Buku Sedang Dipinjam
            const Text("📘 Buku Sedang Dipinjam", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...filteredSedangDipinjam.map((book) => _buildBookTile(book, active: true)).toList(),

            const SizedBox(height: 20),

            // ⚪ Riwayat Peminjaman
            const Text("📚 Riwayat Peminjaman", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...filteredRiwayat.map((book) => _buildBookTile(book, active: false)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildBookTile(Map<String, String> book, {required bool active}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(book["gambar"]!, width: 50, height: 70, fit: BoxFit.cover),
        ),
        title: Text(book["judul"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pengarang: ${book["pengarang"]}"),
            Text("Pinjam: ${book["tanggalPinjam"]}"),
            Text("Kembali: ${book["tanggalKembali"]}"),
          ],
        ),
        trailing: Icon(active ? Icons.access_time : Icons.check_circle, color: active ? Colors.orange : Colors.green),
      ),
    );
  }
}
