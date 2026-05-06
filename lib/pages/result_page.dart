import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final String nama, gender, kategori, bmiKategori;
  final double bmi;
  final double berat;
  final double tinggi; // meter

  const ResultPage({
    required this.nama,
    required this.bmi,
    required this.gender,
    required this.kategori,
    required this.bmiKategori,
    required this.berat,
    required this.tinggi,
    super.key,
  });

  Color getColor() {
    switch (bmiKategori) {
      case "Kurus":
        return Colors.blue;
      case "Normal":
        return Colors.green;
      case "Overweight":
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  // 🔥 HITUNG BERAT IDEAL
  double get minIdealWeight => 18.5 * tinggi * tinggi;
  double get maxIdealWeight => 24.9 * tinggi * tinggi;

  String getAdvice() {
    if (bmiKategori == "Normal") {
      return "Berat badan kamu sudah ideal, pertahankan ya!";
    } else if (bmiKategori == "Kurus") {
      final diff = minIdealWeight - berat;
      return "Kamu perlu menambah sekitar ${diff.toStringAsFixed(1)} kg";
    } else {
      final diff = berat - maxIdealWeight;
      return "Kamu perlu menurunkan sekitar ${diff.toStringAsFixed(1)} kg";
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getColor();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hasil BMI"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),

            Text(
              nama,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text("$gender • $kategori"),

            const SizedBox(height: 30),

            // 🔥 CARD BMI
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    bmi.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    bmiKategori,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // 🔥 BERAT IDEAL
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).cardColor,
              ),
              child: Column(
                children: [
                  const Text(
                    "Berat Ideal",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${minIdealWeight.toStringAsFixed(1)} – ${maxIdealWeight.toStringAsFixed(1)} kg",
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 SARAN
            Text(
              getAdvice(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Hitung Ulang"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}