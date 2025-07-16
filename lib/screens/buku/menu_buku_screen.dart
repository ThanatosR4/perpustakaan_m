import 'package:flutter/material.dart';
import '../../models/buku_model.dart';
import '../../services/buku_service.dart';
import '../../services/kategori_service.dart';
import 'detail_buku_screen.dart';
import 'lihat_semua_buku_screen.dart';

class MenuBukuScreen extends StatefulWidget {
  @override
  _MenuBukuScreenState createState() => _MenuBukuScreenState();
}

class _MenuBukuScreenState extends State<MenuBukuScreen> {
  List<Buku> allBooks = [];
  List<String> categories = [];
  bool isLoading = true;

  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final books = await BukuService.fetchBuku();
      final kategoriList = await KategoriService.fetchKategori();

      setState(() {
        allBooks = books;
        categories = kategoriList.map((e) => e.kode).toList();
        isLoading = false;
      });
    } catch (e) {
      print("Gagal memuat data: $e");
    }
  }

  List<Buku> filterBooks(String query) {
    return allBooks.where((book) {
      return book.judul.toLowerCase().contains(query.toLowerCase()) ||
          book.pengarang.toLowerCase().contains(query.toLowerCase()) ||
          book.isbn.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<Buku> bukuTerbaru = allBooks.take(3).toList();

    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    onChanged: (value) => setState(() => searchQuery = value),
                    decoration: InputDecoration(
                      hintText: "Cari berdasarkan judul, pengarang, atau ISBN",
                      prefixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  if (searchQuery.isNotEmpty) ...[
                    Text("Hasil Pencarian:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ...filterBooks(searchQuery).map((buku) => ListTile(
                          leading: Image.network(buku.gambarUrl, width: 50, fit: BoxFit.cover),
                          title: Text(buku.judul),
                          subtitle: Text(buku.pengarang),
                          onTap: () => _goToDetail(buku),
                        )),
                    SizedBox(height: 20),
                  ],

                  Text("\ud83d\udccc Buku Terbaru", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  ...bukuTerbaru.map((buku) => ListTile(
                        // leading: Image.network(buku.gambarUrl, width: 50, fit: BoxFit.cover),
                        leading: SizedBox(
                            width: 50,
                            height: 70,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                buku.gambarUrl,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return Center(child: CircularProgressIndicator());
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.broken_image, size: 40, color: Colors.grey);
                                },
                              ),
                            ),
                          ),

                        title: Text(buku.judul),
                        subtitle: Text(buku.pengarang),
                        onTap: () => _goToDetail(buku),
                      )),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      child: Text("Lihat Semua >"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LihatSemuaBukuScreen(
                              judulKategori: "Semua Buku",
                              daftarBuku: allBooks,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 20),
                  for (String kategori in categories) ...[
                    Text("\ud83d\udcda Kategori: $kategori", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 180,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: allBooks
                            .where((b) => b.kategoriKode == kategori)
                            .take(5)
                            .map((buku) => Container(
                                  width: 120,
                                  margin: EdgeInsets.only(right: 10),
                                  child: GestureDetector(
                                    onTap: () => _goToDetail(buku),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.network(
                                            buku.gambarUrl,
                                            height: 120,
                                            width: 120,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          buku.judul,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        child: Text("Lihat Semua >"),
                        onPressed: () {
                          final kategoriBuku = allBooks.where((b) => b.kategoriKode == kategori).toList();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LihatSemuaBukuScreen(
                                judulKategori: kategori,
                                daftarBuku: kategoriBuku,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ],
              ),
            ),
    );
  }

  void _goToDetail(Buku book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailBukuScreen(
          title: book.judul,
          image: book.gambarUrl,
          author: book.pengarang,
          category: book.kategoriKode,
          description: book.sinopsis,
          isbn: book.isbn,
          stok: book.stok,
          tahunTerbit: book.tahunTerbit,
          bukuId: book.id,
        ),
      ),
    );
  }
}
