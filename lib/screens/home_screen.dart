import 'package:flutter/material.dart';
import 'buku/menu_buku_screen.dart';
import 'package:perpustakaan_m/screens/peminjaman/peminjaman_screen.dart';
import 'package:perpustakaan_m/screens/profil/profil_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    MenuBukuScreen(),
    PeminjamanScreen(),
    ProfilScreen(),
  ];

  final List<String> _titles = [
    "Menu Buku",
    "Peminjaman Buku",
    "Profil",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Color.fromARGB(255, 0, 58, 230),
              Color.fromARGB(255, 8, 0, 239),
              Color.fromARGB(255, 38, 38, 255),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Icon(Icons.menu, color: Colors.white),
                    const SizedBox(width: 10),
                    Text(
                      _titles[_currentIndex],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 18,
                      child: Icon(Icons.person, color: Colors.blue),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: _pages[_currentIndex],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.orange[900],
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Buku"),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "Peminjaman"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}
