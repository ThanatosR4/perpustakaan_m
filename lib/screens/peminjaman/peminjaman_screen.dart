import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/peminjaman_service.dart';
import '../../models/peminjaman_model.dart';
import '../../models/buku_model.dart'; 
import '../../screens/buku/detail_buku_screen.dart'; 

class PeminjamanScreen extends StatefulWidget {
  @override
  _PeminjamanScreenState createState() => _PeminjamanScreenState();
}

class _PeminjamanScreenState extends State<PeminjamanScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  List<Peminjaman> sedangDipinjam = [];
  List<Peminjaman> riwayatPeminjaman = [];
  final NumberFormat rupiahFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    fetchPeminjaman();
  }

  Future<void> fetchPeminjaman() async {
    try {
      final data = await PeminjamanService.fetchPeminjaman();
      setState(() {
        sedangDipinjam = data.where((item) => item.status == 'dipinjam').toList();
        riwayatPeminjaman = data.where((item) => item.status == 'sudah kembali').toList();
      });
    } catch (e) {
      print('Gagal fetch peminjaman: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: fetchPeminjaman,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              const Text("📘 Buku Sedang Dipinjam", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...sedangDipinjam
                  .where((b) => b.bukuJudul.toLowerCase().contains(searchQuery.toLowerCase()))
                  .map((b) => _buildBookTile(b, active: true))
                  .toList(),
              const SizedBox(height: 20),
              const Text("📚 Riwayat Peminjaman", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...riwayatPeminjaman
                  .where((b) => b.bukuJudul.toLowerCase().contains(searchQuery.toLowerCase()))
                  .map((b) => _buildBookTile(b, active: false))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookTile(Peminjaman b, {required bool active}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(b.gambar, width: 50, height: 70, fit: BoxFit.cover),
        ),
        title: Text(b.bukuJudul, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pengarang: ${b.bukuPengarang}"),
            Text("Pinjam: ${DateFormat('yyyy-MM-dd').format(b.tanggalPinjam)}"),
            Text("Kembali: ${DateFormat('yyyy-MM-dd').format(b.tanggalKembali)}"),
            if (active && DateTime.now().isAfter(b.tanggalKembali))
              Text(
                "Denda: ${rupiahFormatter.format(DateTime.now().difference(b.tanggalKembali).inDays * Peminjaman.dendaPerHari)}",
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
          ],
        ),
        trailing: Icon(active ? Icons.access_time : Icons.check_circle, color: active ? Colors.orange : Colors.green),
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailBukuScreen(
                bukuId: b.id, 
                title: b.bukuJudul,
                image: b.gambar,
                author: b.bukuPengarang,
                category: "Kategori", 
                description: "Deskripsi", 
                isbn: "ISBN", 
                tahunTerbit: 2024,
                stok: 1,
              ),
            ),
          );

          
          if (result == true) {
            fetchPeminjaman();
          }
        },
      ),
    );
  }
}
