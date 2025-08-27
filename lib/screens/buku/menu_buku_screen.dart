import 'package:flutter/material.dart';
import '../../models/buku_model.dart';
import '../../models/kategori_model.dart';
import '../../services/buku_service.dart';
import '../../services/kategori_service.dart';
import 'detail_buku_screen.dart';
import 'lihat_semua_buku_screen.dart';

class MenuBukuScreen extends StatefulWidget {
  @override
  _MenuBukuScreenState createState() => _MenuBukuScreenState();
}

class _MenuBukuScreenState extends State<MenuBukuScreen> {
  late Future<void> _initData;

  List<Buku> allBooks = [];
  Map<String, String> kategoriMap = {}; // kategoriId -> kode
  List<String> kategoriIdList = [];

  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _initData = _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final books = await BukuService.fetchBuku();
      final kategoriList = await KategoriService.fetchKategori();

      kategoriMap = {
        for (var k in kategoriList) k.id.toString(): k.kode
      };

      // Hanya tampilkan kategori yang digunakan oleh buku
      kategoriIdList = kategoriMap.keys
          .where((id) => books.any((b) => b.kategoriKode == id))
          .toList();

      setState(() {
        allBooks = books;
      });
    } catch (e) {
      print("❌ Gagal fetch data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat data buku/kategori")),
      );
    }
  }

  List<Buku> _filterBooks(String query) {
    return allBooks.where((book) {
      return book.judul.toLowerCase().contains(query.toLowerCase()) ||
             book.pengarang.toLowerCase().contains(query.toLowerCase()) ||
             book.isbn.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initData,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final bukuTerbaru = allBooks.take(3).toList();
        final hasilCari = _filterBooks(searchQuery);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),

              if (searchQuery.isNotEmpty) ...[
                Text("Hasil Pencarian:", style: _judulStyle),
                ...hasilCari.map(_buildListTile),
                const SizedBox(height: 20),
              ],

              Text("📌 Buku Terbaru", style: _judulStyle),
              const SizedBox(height: 10),
              ...bukuTerbaru.map(_buildListTile),
              _lihatSemuaButton(allBooks, "Semua Buku"),

              const SizedBox(height: 20),

              for (String kategoriId in kategoriIdList) ...[
                Text("📚 Kategori: ${kategoriMap[kategoriId] ?? 'Tidak Diketahui'}", style: _judulStyle),
                const SizedBox(height: 10),
                _buildHorizontalList(kategoriId),
                _lihatSemuaButton(
                  allBooks.where((b) => b.kategoriKode == kategoriId).toList(),
                  kategoriMap[kategoriId] ?? 'Kategori Tidak Diketahui',
                ),
                const SizedBox(height: 20),
              ]
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: (val) => setState(() => searchQuery = val),
      decoration: InputDecoration(
        hintText: "Cari judul/pengarang/ISBN...",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildListTile(Buku buku) {
    return ListTile(
      leading: _buildImage(buku.gambarUrl),
      title: Text(buku.judul),
      subtitle: Text(buku.pengarang),
      onTap: () => _goToDetail(buku),
    );
  }

  Widget _buildHorizontalList(String kategoriId) {
    final list = allBooks.where((b) => b.kategoriKode == kategoriId).take(5).toList();

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (_, i) {
          final buku = list[i];
          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => _goToDetail(buku),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _buildImage(buku.gambarUrl, width: 120, height: 120),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    buku.judul,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _lihatSemuaButton(List<Buku> daftar, String judul) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        child: const Text("Lihat Semua >"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LihatSemuaBukuScreen(
                judulKategori: judul,
                daftarBuku: daftar,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImage(String url, {double width = 50, double height = 70}) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loading) =>
              loading == null ? child : const Center(child: CircularProgressIndicator()),
          errorBuilder: (context, error, _) => const Icon(Icons.broken_image, size: 40, color: Colors.grey),
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
          category: kategoriMap[book.kategoriKode] ?? 'Kategori Tidak Diketahui',
          description: book.sinopsis,
          isbn: book.isbn,
          stok: book.stok,
          tahunTerbit: book.tahunTerbit,
          bukuId: book.id,
        ),
      ),
    );
  }

  final _judulStyle = const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
}
