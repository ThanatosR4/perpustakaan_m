import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/kategori_model.dart';

class KategoriService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static Future<List<Kategori>> fetchKategori() async {
    final response = await http.get(Uri.parse('$baseUrl/kategori'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => Kategori.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat kategori');
    }
  }
}
