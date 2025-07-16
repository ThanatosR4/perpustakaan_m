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

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _tempatLahirController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();

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
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
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
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<void> _pickDate() async {
    DateTime initialDate = DateTime.tryParse(_tanggalLahirController.text) ?? DateTime(2000);
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final formatted = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {
        _tanggalLahirController.text = formatted;
      });
    }
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Konfirmasi"),
        content: Text("Apakah Anda yakin ingin menyimpan perubahan?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[900]),
            onPressed: () {
              Navigator.pop(context); 
              _submitForm(); 
            },
            child: Text("Ya, Simpan"),
          ),
        ],
      ),
    );
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success ? 'Profil berhasil diperbarui' : 'Gagal memperbarui profil')),
      );

      if (success) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
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
                                  : const AssetImage('assets/images/default_avatar.png'))
                                  as ImageProvider,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: const CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.orange,
                              child: Icon(Icons.edit, size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    _buildField('Nama', _namaController, Icons.person),
                    _buildField('Email', _emailController, Icons.email),

                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdown('Kelas', _selectedKelas, kelasList, (val) {
                            setState(() => _selectedKelas = val);
                          }),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildDropdown('Jenis Kelamin', _selectedGender, genderList, (val) {
                            setState(() => _selectedGender = val);
                          }),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: _buildField('Tempat Lahir', _tempatLahirController, Icons.location_city),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildDateField('Tanggal Lahir', _tanggalLahirController),
                        ),
                      ],
                    ),

                    _buildField('No. HP', _teleponController, Icons.phone),
                    _buildField('Alamat', _alamatController, Icons.home),

                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _showConfirmDialog,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        backgroundColor: Colors.orange[900],
                      ),
                      child: const Text('Simpan'),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => UbahPasswordScreen()),
                        );
                      },
                      child: const Text(
                        'Ubah Password',
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
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
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: _pickDate,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.date_range),
          hintText: 'yyyy-mm-dd',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) => value!.isEmpty ? '$label tidak boleh kosong' : null,
      ),
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items, void Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.arrow_drop_down),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
        validator: (value) => value == null || value.isEmpty ? '$label harus dipilih' : null,
      ),
    );
  }
}
