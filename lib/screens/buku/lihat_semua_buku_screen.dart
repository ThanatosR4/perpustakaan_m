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
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16,
              right: 16,
              bottom: 20,
            ),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 0, 82, 197),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(25),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back, color: Colors.white),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Kategori: $judulKategori',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

         
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: daftarBuku.isEmpty
                  ? Center(child: Text("Belum ada buku dalam kategori ini."))
                  : GridView.builder(
                      itemCount: daftarBuku.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                buku.judul,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              Text(
                                buku.pengarang,
                                style: TextStyle(fontSize: 11, color: Colors.grey),
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
    );
  }
}
