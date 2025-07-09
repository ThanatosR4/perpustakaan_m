import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/siswa_service.dart';
import 'package:intl/intl.dart';

class EditProfilScreen extends StatefulWidget {
  @override
  _EditProfilScreenState createState() => _EditProfilScreenState();
}

class _EditProfilScreenState extends State<EditProfilScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _tempatLahirController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();

  String? _selectedKelas;
  String? _selectedGender;
  File? _selectedImage;
  bool _loading = false;

  final List<String> kelasList = ['X', 'XI', 'XII'];
  final List<String> genderList = ['L', 'P'];

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final data = await SiswaService.getProfile();
    if (data != null) {
      setState(() {
        _namaController.text = data['nama'] ?? '';
        _emailController.text = data['email'] ?? '';
        _selectedGender = data['jenis_kelamin'];
        _tempatLahirController.text = data['tempat_lahir'] ?? '';
        _tanggalLahirController.text = data['tanggal_lahir'] ?? '';
        _teleponController.text = data['telepon'] ?? '';
        _alamatController.text = data['alamat'] ?? '';
        _selectedKelas = data['kelas'];
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
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_tanggalLahirController.text) ?? DateTime(2000),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        _tanggalLahirController.text = formattedDate;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);

      bool success = await SiswaService.updateProfile(
        nama: _namaController.text,
        email: _emailController.text,
        jenisKelamin: _selectedGender,
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
                    // Foto profil
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
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
                    _buildDropdown('Jenis Kelamin', _selectedGender, genderList, (val) {
                      setState(() => _selectedGender = val);
                    }),
                    _buildDropdown('Kelas', _selectedKelas, kelasList, (val) {
                      setState(() => _selectedKelas = val);
                    }),
                    _buildField('Tempat Lahir', _tempatLahirController, Icons.location_city),
                    _buildDateField('Tanggal Lahir', _tanggalLahirController),
                    _buildField('No. HP', _teleponController, Icons.phone),
                    _buildField('Alamat', _alamatController, Icons.home),

                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        backgroundColor: Colors.orange[900],
                      ),
                      child: const Text('Simpan'),
                    ),
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
          hintText: 'dd/mm/yyyy',
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
