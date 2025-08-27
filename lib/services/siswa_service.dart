import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/siswa_model.dart';

class SiswaService {
  static const String baseUrl = 'https://perpustakaansma1telker.web.id/api';

  static Future<Siswa?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("Token tidak ditemukan");
      return null;
    }

    final response = await http.get(
      Uri.parse('$baseUrl/siswa/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Siswa.fromJson(json['siswa']);
    } else {
      print("Gagal mengambil data: ${response.statusCode} - ${response.body}");
      return null;
    }
  }

  static Future<bool> updateProfile({
    required String nama,
    required String email,
    String? jenisKelamin,
    String? tempatLahir,
    String? tanggalLahir,
    String? telepon,
    String? alamat,
    String? kelas,
    File? foto,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("Token tidak ditemukan");
      return false;
    }

    final url = Uri.parse('$baseUrl/siswa/update');
    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Accept'] = 'application/json'
      ..fields['nama'] = nama
      ..fields['email'] = email;

    if (jenisKelamin != null && jenisKelamin.isNotEmpty) {
      request.fields['jenis_kelamin'] = jenisKelamin;
    }
    if (tempatLahir != null && tempatLahir.isNotEmpty) {
      request.fields['tempat_lahir'] = tempatLahir;
    }
    if (tanggalLahir != null && tanggalLahir.isNotEmpty) {
      request.fields['tanggal_lahir'] = tanggalLahir;
    }
    if (telepon != null && telepon.isNotEmpty) {
      request.fields['telepon'] = telepon;
    }
    if (alamat != null && alamat.isNotEmpty) {
      request.fields['alamat'] = alamat;
    }
    if (kelas != null && kelas.isNotEmpty) {
    request.fields['kelas'] = kelas;
    }
    if (foto != null) {
      request.files.add(await http.MultipartFile.fromPath('foto', foto.path));
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("STATUS CODE: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {
        return true;
      } else {
        final json = jsonDecode(response.body);
        print("Pesan Laravel: ${json['message'] ?? 'Tidak ada'}");
        return false;
      }
    } catch (e) {
      print("Error saat update profil: $e");
      return false;
    }
  }
  static Future<String?> ubahPassword({
      required String currentPassword,
      required String newPassword,
      required String confirmPassword,
    }) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) return 'Token tidak ditemukan';

      final response = await http.post(
        Uri.parse('$baseUrl/siswa/ubah-password'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: {
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': confirmPassword,
        },
      );

      if (response.statusCode == 200) {
        return null; // sukses
      } else {
        final error = jsonDecode(response.body);
        return error['message'] ?? 'Terjadi kesalahan';
      }
    }

}
