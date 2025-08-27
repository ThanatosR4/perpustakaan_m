import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../services/siswa_service.dart';

class UbahPasswordScreen extends StatefulWidget {
  @override
  _UbahPasswordScreenState createState() => _UbahPasswordScreenState();
}

class _UbahPasswordScreenState extends State<UbahPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void _handleUbahPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Apakah Anda yakin ingin mengubah password?"),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[900]),
            child: const Text("Ya, Ubah"),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final error = await SiswaService.ubahPassword(
      currentPassword: oldPasswordController.text.trim(),
      newPassword: newPasswordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
    );

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password berhasil diubah')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Color(0xFF003AE6),
              Color(0xFF0800EF),
              Color(0xFF2626FF),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 40,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.85,
                padding: const EdgeInsets.all(30),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 900),
                          child: const Text(
                            "Ubah Password",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1000),
                          child: _buildPasswordField(
                            controller: oldPasswordController,
                            label: 'Password Lama',
                            obscureText: _obscureOld,
                            toggleObscure: () =>
                                setState(() => _obscureOld = !_obscureOld),
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1100),
                          child: _buildPasswordField(
                            controller: newPasswordController,
                            label: 'Password Baru',
                            obscureText: _obscureNew,
                            toggleObscure: () =>
                                setState(() => _obscureNew = !_obscureNew),
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1200),
                          child: _buildPasswordField(
                            controller: confirmPasswordController,
                            label: 'Konfirmasi Password',
                            obscureText: _obscureConfirm,
                            toggleObscure: () =>
                                setState(() => _obscureConfirm = !_obscureConfirm),
                            validator: (value) {
                              if (value!.isEmpty) return 'Tidak boleh kosong';
                              if (value != newPasswordController.text) {
                                return 'Konfirmasi password tidak cocok';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 40),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1300),
                          child: MaterialButton(
                            onPressed: _handleUbahPassword,
                            height: 50,
                            color: Colors.orange[900],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Center(
                              child: Text(
                                "Simpan",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback toggleObscure,
    FormFieldValidator<String>? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(225, 95, 27, .3),
            blurRadius: 20,
            offset: Offset(0, 10),
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator ?? (value) => value!.isEmpty ? 'Tidak boleh kosong' : null,
        decoration: InputDecoration(
          hintText: label,
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: toggleObscure,
          ),
        ),
      ),
    );
  }
}
