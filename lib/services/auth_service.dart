import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'https://perpustakaansma1telker.web.id';

  static Future<String?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/siswa/login');

    try {
      final stopwatch = Stopwatch()..start();

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: {
              'email': email,
              'password': password,
            },
          )
          .timeout(const Duration(seconds: 10));

      stopwatch.stop();
      print('⏱️ Waktu login: ${stopwatch.elapsedMilliseconds} ms');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token'];
      } else {
        print('❌ Login gagal: ${response.statusCode} - ${response.body}');
        return null;
      }
    } on TimeoutException {
      print('❌ Login timeout');
      return null;
    } catch (e) {
      print('❌ Login error: $e');
      return null;
    }
  }

  static Future<bool> register({
    required String kode,
    required String nama,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/api/siswa/register');

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: {
              'kode': kode,
              'nama': nama,
              'email': email,
              'password': password,
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        print('✅ Register berhasil: ${response.body}');
        return true;
      } else {
        final data = jsonDecode(response.body);
        print('❌ Register gagal: ${data['message'] ?? response.body}');
        return false;
      }
    } on TimeoutException {
      print('❌ Register timeout');
      return false;
    } catch (e) {
      print('❌ Register error: $e');
      return false;
    }
  }
}
