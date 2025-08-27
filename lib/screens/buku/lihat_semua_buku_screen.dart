import 'package:flutter/material.dart';
import '../../models/buku_model.dart';
import 'detail_buku_screen.dart';

class LihatSemuaBukuScreen extends StatelessWidget {
  final String judulKategori;
  final List<Buku> daftarBuku;

  const LihatSemuaBukuScreen({
    Key? key,
    required this.judulKategori,
    required this.daftarBuku,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // AppBar Custom
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 0, 82, 197),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(25),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Kategori: $judulKategori',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Grid Buku
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: daftarBuku.isEmpty
                    ? const Center(
                        child: Text(
                          "Belum ada buku dalam kategori ini.",
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : GridView.builder(
                        itemCount: daftarBuku.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.55,
                        ),
                        itemBuilder: (context, index) {
                          final buku = daftarBuku[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailBukuScreen(
                                    title: buku.judul,
                                    image: buku.gambarUrl,
                                    author: buku.pengarang,
                                    category: buku.kategoriKode,
                                    description: buku.sinopsis,
                                    isbn: buku.isbn,
                                    stok: buku.stok,
                                    tahunTerbit: buku.tahunTerbit,
                                    bukuId: buku.id,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    buku.gambarUrl,
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 120,
                                        width: double.infinity,
                                        color: Colors.grey[300],
                                        alignment: Alignment.center,
                                        child: const Icon(Icons.image_not_supported, color: Colors.grey),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  buku.judul,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                Text(
                                  buku.pengarang,
                                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
