import 'package:flutter/material.dart';

class DetailBukuScreen extends StatelessWidget {
  final String title;
  final String image;
  final String author;
  final String category;
  final String description;

  const DetailBukuScreen({
    super.key,
    required this.title,
    required this.image,
    required this.author,
    required this.category,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Color.fromARGB(255, 0, 58, 230),
                  Color.fromARGB(255, 8, 0, 239),
                  Color.fromARGB(255, 38, 38, 255),
                ],
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
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Konten
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      image,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text("Penulis: $author", style: const TextStyle(color: Colors.grey)),
                  Text("Kategori: $category", style: const TextStyle(color: Colors.grey)),
                  const Divider(height: 30),
                  const Text("Deskripsi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(description, textAlign: TextAlign.justify),
                ],
              ),
            ),
          ),

          // Tombol Pinjam
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Buku berhasil dipinjam!")),
                );
              },
              icon: const Icon(Icons.library_books),
              label: const Text("Pinjam Buku"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[900],
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
