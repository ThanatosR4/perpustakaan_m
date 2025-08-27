import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/kategori_model.dart';

class KategoriService {
  static const String baseUrl = 'https://perpustakaansma1telker.web.id';

  static Future<List<Kategori>> fetchKategori() async {
    final url = Uri.parse('$baseUrl/api/kategori');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body)['data'];
      return data.map((e) => Kategori.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat kategori');
    }
  }
}
