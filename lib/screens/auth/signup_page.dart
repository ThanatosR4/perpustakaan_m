import 'package:flutter/material.dart';
import 'login_page.dart';
import '../../services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nisnController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    nisnController.dispose();
    namaController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final success = await AuthService.register(
        kode: nisnController.text.trim(),
        nama: namaController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      setState(() => _isLoading = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Pendaftaran berhasil. Silakan login")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Pendaftaran gagal. Coba lagi")),
        );
      }
    }
  }

  String? _validateField(String value) {
    return value.isEmpty ? "Field ini wajib diisi" : null;
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) return "Email wajib diisi";
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return "Format email tidak valid";
    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) return "Password wajib diisi";
    if (value.length < 6) return "Minimal 6 karakter";
    return null;
  }

  String? _validatePasswordMatch(String value) {
    if (value.isEmpty) return "Konfirmasi password wajib diisi";
    if (value != passwordController.text) return "Password tidak cocok";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 58, 230),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 80),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Daftar",
                  style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      _buildTextField("NISN", nisnController),
                      _buildTextField("Nama Lengkap", namaController),
                      _buildTextField("Email", emailController, isEmail: true),
                      _buildPasswordField("Password", passwordController, _obscurePassword, () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      }),
                      _buildPasswordField("Konfirmasi Password", confirmPasswordController, _obscureConfirmPassword, () {
                        setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                      }, isConfirm: true),
                      const SizedBox(height: 30),
                      _isLoading
                          ? CircularProgressIndicator()
                          : MaterialButton(
                              onPressed: _handleSignUp,
                              height: 50,
                              minWidth: double.infinity,
                              color: Colors.orange[900],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Text(
                                "Daftar",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          "Sudah punya akun? Login",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, {bool isEmail = false}) {
    return _buildInputContainer(
      child: TextFormField(
        controller: controller,
        validator: (value) => isEmail ? _validateEmail(value!) : _validateField(value!),
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        autofillHints: isEmail ? [AutofillHints.email] : null,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildPasswordField(String hint, TextEditingController controller, bool obscure, VoidCallback toggle, {bool isConfirm = false}) {
    return _buildInputContainer(
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: (value) => isConfirm ? _validatePasswordMatch(value!) : _validatePassword(value!),
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
            onPressed: toggle,
          ),
        ),
      ),
    );
  }

  Widget _buildInputContainer({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}
