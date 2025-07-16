import 'package:flutter/material.dart';
import '../../services/peminjaman_service.dart';

class DetailBukuScreen extends StatefulWidget {
  final int bukuId;
  final String title;
  final String image;
  final String author;
  final String category;
  final String description;
  final String isbn;
  final int tahunTerbit;
  final int stok;

  const DetailBukuScreen({
    super.key,
    required this.bukuId,
    required this.title,
    required this.image,
    required this.author,
    required this.category,
    required this.description,
    required this.isbn,
    required this.tahunTerbit,
    required this.stok,
  });

  @override
  State<DetailBukuScreen> createState() => _DetailBukuScreenState();
}

class _DetailBukuScreenState extends State<DetailBukuScreen> {
  bool showDetails = false;

  void _toggleDetails() {
    setState(() => showDetails = !showDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [Color(0xFF003AE6), Color(0xFF0800EF), Color(0xFF2626FF)],
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Detail Buku",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(widget.image, height: 200, fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 20),
                  Text(widget.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: _toggleDetails,
                    child: Row(
                      children: [
                        Icon(showDetails ? Icons.expand_less : Icons.expand_more, color: Colors.blue),
                        const SizedBox(width: 6),
                        Text(
                          showDetails ? "Sembunyikan Detail Tambahan" : "Tampilkan Detail Tambahan",
                          style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (showDetails)
                    GridView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3.5,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      children: [
                        _infoCard(Icons.person, "Penulis", widget.author),
                        _infoCard(Icons.category, "Kategori", widget.category),
                        _infoCard(Icons.qr_code, "ISBN", widget.isbn),
                        _infoCard(Icons.calendar_today, "Tahun", widget.tahunTerbit.toString()),
                        _infoCard(Icons.inventory, "Stok", widget.stok.toString()),
                      ],
                    ),

                  const Divider(height: 30),
                  const Text("Deskripsi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(widget.description, textAlign: TextAlign.justify),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ElevatedButton.icon(
              onPressed: widget.stok <= 0 ? null : _pinjamBuku,
              icon: const Icon(Icons.library_books),
              label: const Text("Pinjam Buku"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[900],
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6FD),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 6, offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.blue[800]),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pinjamBuku() async {
    int? lamaPinjam;
    String? keterangan;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        final TextEditingController lamaController = TextEditingController();
        final TextEditingController ketController = TextEditingController();

        return AlertDialog(
          title: const Text("Pinjam Buku"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Masukkan lama peminjaman (hari):"),
              const SizedBox(height: 10),
              TextField(
                controller: lamaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Contoh: 7",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text("Masukkan keterangan peminjaman:"),
              const SizedBox(height: 10),
              TextField(
                controller: ketController,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: "Contoh: Untuk tugas sejarah",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
            ElevatedButton(
              onPressed: () {
                lamaPinjam = int.tryParse(lamaController.text);
                keterangan = ketController.text.trim();
                if (lamaPinjam != null && lamaPinjam! > 0) {
                  Navigator.pop(context, true);
                }
              },
              child: const Text("Pinjam"),
            ),
          ],
        );
      },
    );

    if (confirm == true && lamaPinjam != null) {
      try {
        await PeminjamanService.pinjamBuku(
          bukuId: widget.bukuId,
          tanggalPinjam: DateTime.now(),
          lamaPinjam: lamaPinjam!,
          keterangan: keterangan ?? "",
        );

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Buku berhasil dipinjam!")),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal meminjam: $e")),
        );
      }
    }
  }
}
