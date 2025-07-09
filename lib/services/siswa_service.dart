import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SiswaService {
  static const String baseUrl = 'http://10.0.2.2:8000/api'; // untuk emulator Android

  // Ambil data siswa yang sedang login
  static Future<Map<String, dynamic>?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('$baseUrl/siswa/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['siswa'];
    } else {
      print("Gagal mengambil data: ${response.body}");
      return null;
    }
  }

  // Update profil siswa
  static Future<bool> updateProfile({
    required String nama,
    required String email,
    String? jenisKelamin,
    String? tempatLahir,
    String? tanggalLahir,
    String? telepon,
    String? alamat,
    File? foto,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.parse('$baseUrl/siswa/update-profile');

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['nama'] = nama;
    request.fields['email'] = email;
    if (jenisKelamin != null) request.fields['jenis_kelamin'] = jenisKelamin;
    if (tempatLahir != null) request.fields['tempat_lahir'] = tempatLahir;
    if (tanggalLahir != null) request.fields['tanggal_lahir'] = tanggalLahir;
    if (telepon != null) request.fields['telepon'] = telepon;
    if (alamat != null) request.fields['alamat'] = alamat;

    if (foto != null) {
      request.files.add(await http.MultipartFile.fromPath('foto', foto.path));
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    return response.statusCode == 200;
  }
}
