import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'result_page.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  String? _selectedCategory;
  String _selectedGender = 'Laki-laki';

  final List<String> _categories = [
    'Anak-anak',
    'Remaja',
    'Dewasa',
  ];

  // 🔥 LIMIT REALISTIS
  static const double minWeight = 10;
  static const double maxWeight = 635;

  static const double minHeight = 50;
  static const double maxHeight = 272;

  String getBmiCategory(double bmi) {
    if (bmi < 18.5) return "Kurus";
    if (bmi < 25) return "Normal";
    if (bmi < 30) return "Overweight";
    return "Obesitas";
  }

  void _calculateBMI() {
    if (_formKey.currentState!.validate()) {
      final nama = _nameController.text.trim();
      final berat = double.parse(_weightController.text);
      final tinggiCm = double.parse(_heightController.text);

      final tinggi = tinggiCm / 100;
      final bmi = berat / (tinggi * tinggi);

      final kategoriBMI = getBmiCategory(bmi);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(
            nama: nama,
            bmi: bmi,
            gender: _selectedGender,
            kategori: _selectedCategory!,
            bmiKategori: kategoriBMI,
            berat: berat,
            tinggi: tinggi,
          ),
        ),
      );
    }
  }

  InputDecoration inputDecoration(String label, String hint,
      {IconData? icon, String? suffix}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon) : null,
      suffixText: suffix,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kalkulator BMI"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // NAMA
              TextFormField(
                controller: _nameController,
                decoration: inputDecoration(
                    'Nama Lengkap', 'Masukkan nama...',
                    icon: Icons.person),
                validator: (value) =>
                    value!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 20),

              // BERAT
              TextFormField(
                controller: _weightController,
                decoration:
                    inputDecoration('Berat Badan', 'Contoh: 65',
                        suffix: 'kg'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Wajib diisi';
                  }

                  final weight = double.tryParse(value);
                  if (weight == null) return 'Input tidak valid';

                  if (weight < minWeight) {
                    return 'Minimal $minWeight kg';
                  }
                  if (weight > maxWeight) {
                    return 'Maksimal $maxWeight kg';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),

              // TINGGI
              TextFormField(
                controller: _heightController,
                decoration:
                    inputDecoration('Tinggi Badan', 'Contoh: 170',
                        suffix: 'cm'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Wajib diisi';
                  }

                  final height = double.tryParse(value);
                  if (height == null) return 'Input tidak valid';

                  if (height < minHeight) {
                    return 'Minimal $minHeight cm';
                  }
                  if (height > maxHeight) {
                    return 'Maksimal $maxHeight cm';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),

              // DROPDOWN
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: inputDecoration('Kategori Usia', ''),
                hint: const Text('Pilih kategori...'),
                items: _categories
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                validator: (value) =>
                    value == null ? 'Wajib dipilih' : null,
                onChanged: (value) =>
                    setState(() => _selectedCategory = value),
              ),
              const SizedBox(height: 20),

              // GENDER
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Jenis Kelamin",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  RadioListTile(
                    value: 'Laki-laki',
                    groupValue: _selectedGender,
                    title: const Text("Laki-laki"),
                    onChanged: (value) =>
                        setState(() => _selectedGender = value!),
                  ),
                  RadioListTile(
                    value: 'Perempuan',
                    groupValue: _selectedGender,
                    title: const Text("Perempuan"),
                    onChanged: (value) =>
                        setState(() => _selectedGender = value!),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _calculateBMI,
                  child: const Text(
                    "Hitung BMI",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}