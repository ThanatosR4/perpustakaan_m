import 'package:flutter/material.dart';
import '../../models/buku_model.dart';
import '../../services/buku_service.dart';
import 'detail_buku_screen.dart';

class MenuBukuScreen extends StatefulWidget {
  @override
  _MenuBukuScreenState createState() => _MenuBukuScreenState();
}

class _MenuBukuScreenState extends State<MenuBukuScreen> {
  List<Buku> allBooks = [];
  List<Buku> filteredBooks = [];
  List<String> categories = ["Semua", "Novel", "LKS", "Komik"];
  String selectedCategory = "Semua";
  String searchQuery = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBuku();
  }

  Future<void> fetchBuku() async {
    final books = await BukuService.fetchBuku();
    setState(() {
      allBooks = books;
      filteredBooks = books;
      isLoading = false;
    });
  }

  void _showFilterPopup() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) {
        return Wrap(
          children: categories.map((category) {
            return ListTile(
              title: Text(category),
              onTap: () {
                setState(() {
                  selectedCategory = category;
                  applyFilters();
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  void applyFilters() {
    setState(() {
      filteredBooks = allBooks.where((book) {
        final matchesCategory = selectedCategory == "Semua" || book.kategoriKode == selectedCategory;
        final matchesSearch = book.judul.toLowerCase().contains(searchQuery.toLowerCase());
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔍 Search & Filter
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            searchQuery = value;
                            applyFilters();
                          },
                          decoration: InputDecoration(
                            hintText: "Cari buku...",
                            prefixIcon: Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _showFilterPopup,
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(12),
                          backgroundColor: Colors.orange[900],
                        ),
                        child: Icon(Icons.filter_list, color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text("📚 Buku Populer", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) {
                      final book = allBooks[index % allBooks.length];
                      return _buildBookCard(book);
                    },
                  ),

                  SizedBox(height: 20),
                  Text("📖 Buku Lainnya", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 190,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredBooks.length,
                      itemBuilder: (context, index) {
                        final book = filteredBooks[index];
                        return _buildHorizontalBook(book);
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("📄 Daftar Buku", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  ...filteredBooks.map((book) => _buildFilteredList(book)).toList(),
                ],
              ),
            ),
          );
  }

  Widget _buildBookCard(Buku book) {
    return GestureDetector(
      onTap: () => _goToDetail(book),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(book.gambarUrl, height: 120, width: double.infinity, fit: BoxFit.cover),
          ),
          SizedBox(height: 5),
          Text(book.judul, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(book.pengarang, style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildHorizontalBook(Buku book) {
    return GestureDetector(
      onTap: () => _goToDetail(book),
      child: Container(
        width: 120,
        margin: EdgeInsets.only(right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(book.gambarUrl, height: 120, width: 120, fit: BoxFit.cover),
            ),
            SizedBox(height: 5),
            Text(book.judul, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  Widget _buildFilteredList(Buku book) {
    return ListTile(
      leading: Image.network(book.gambarUrl, width: 50, height: 50, fit: BoxFit.cover),
      title: Text(book.judul),
      subtitle: Text(book.pengarang),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _goToDetail(book),
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
        ),
      ),
    );
  }
}
