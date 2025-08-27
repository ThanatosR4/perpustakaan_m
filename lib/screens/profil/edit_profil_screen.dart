import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../services/siswa_service.dart';
import 'ubah_password_screen.dart';

class EditProfilScreen extends StatefulWidget {
  @override
  _EditProfilScreenState createState() => _EditProfilScreenState();
}

class _EditProfilScreenState extends State<EditProfilScreen> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _tempatLahirController = TextEditingController();
  final _tanggalLahirController = TextEditingController();
  final _teleponController = TextEditingController();
  final _alamatController = TextEditingController();

  String? _selectedKelas;
  String? _selectedGender;
  File? _selectedImage;
  String? _fotoUrl;
  bool _loading = false;

  final List<String> kelasList = ['X', 'XI', 'XII'];
  final List<String> genderList = ['L', 'P'];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final siswa = await SiswaService.getProfile();
    if (siswa != null) {
      setState(() {
        _namaController.text = siswa.nama;
        _emailController.text = siswa.email;
        _selectedGender = siswa.jenisKelamin;
        _tempatLahirController.text = siswa.tempatLahir ?? '';
        _tanggalLahirController.text = siswa.tanggalLahir ?? '';
        _teleponController.text = siswa.telepon ?? '';
        _alamatController.text = siswa.alamat ?? '';
        _selectedKelas = siswa.kelas;
        _fotoUrl = siswa.fotoUrl;
      });
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = DateTime.tryParse(_tanggalLahirController.text) ?? DateTime(now.year - 15);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1980),
      lastDate: now,
    );
    if (picked != null) {
      _tanggalLahirController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);
      final success = await SiswaService.updateProfile(
        nama: _namaController.text,
        email: _emailController.text,
        jenisKelamin: _selectedGender,
        kelas: _selectedKelas,
        tempatLahir: _tempatLahirController.text,
        tanggalLahir: _tanggalLahirController.text,
        telepon: _teleponController.text,
        alamat: _alamatController.text,
        foto: _selectedImage,
      );
      setState(() => _loading = false);

      final msg = success ? 'Profil berhasil diperbarui' : 'Gagal memperbarui profil';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      if (success) Navigator.pop(context);
    }
  }

  void _confirmSimpan() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Konfirmasi"),
        content: Text("Apakah Anda yakin ingin menyimpan perubahan?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text("Batal")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _submitForm();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[900]),
            child: Text("Ya, Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profil')),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : (_fotoUrl != null && _fotoUrl!.isNotEmpty
                                  ? NetworkImage(_fotoUrl!)
                                  : AssetImage('assets/images/profile_default.jpg')) as ImageProvider,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.orange,
                              child: Icon(Icons.edit, size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    _buildInput('Nama', _namaController, Icons.person),
                    _buildInput('Email', _emailController, Icons.email),
                    Row(
                      children: [
                        Expanded(child: _buildDropdown('Kelas', _selectedKelas, kelasList, (val) => setState(() => _selectedKelas = val))),
                        SizedBox(width: 10),
                        Expanded(child: _buildDropdown('Jenis Kelamin', _selectedGender, genderList, (val) => setState(() => _selectedGender = val))),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: _buildInput('Tempat Lahir', _tempatLahirController, Icons.location_city)),
                        SizedBox(width: 10),
                        Expanded(child: _buildDateField('Tanggal Lahir', _tanggalLahirController)),
                      ],
                    ),
                    _buildInput('No. HP', _teleponController, Icons.phone),
                    _buildInput('Alamat', _alamatController, Icons.home),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _confirmSimpan,
                      child: Text('Simpan'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        backgroundColor: Colors.orange[900],
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => UbahPasswordScreen())),
                      child: Text('Ubah Password', style: TextStyle(color: Colors.blue)),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) => value!.isEmpty ? '$label tidak boleh kosong' : null,
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: _pickDate,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(Icons.date_range),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) => value!.isEmpty ? '$label tidak boleh kosong' : null,
      ),
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> options, void Function(String?) onChanged) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField<String>(
        value: value,
        items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(Icons.arrow_drop_down),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (val) => (val == null || val.isEmpty) ? '$label harus dipilih' : null,
      ),
    );
  }
}
