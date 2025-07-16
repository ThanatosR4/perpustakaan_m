import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  
  static const String baseUrl = 'http://10.0.2.2:8000';

  
  static Future<String?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/siswa/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token']; 
      } else {
        print('Login gagal: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Login error: $e');
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
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'kode': kode,
          'nama': nama,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        print('Register berhasil: ${response.body}');
        return true;
      } else {
        print('Register gagal: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }
}
