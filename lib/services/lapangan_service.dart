import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/lapangan_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class LapanganService {
  final String apiUrl =
      'https://raw.githubusercontent.com/Kuwaann/lapangan-API/refs/heads/main/lapangan.json';

  Future<List<TempatOlahraga>> fetchLapangan() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final List<dynamic> lapanganList = jsonData['data'];

        final List<TempatOlahraga> listTempat = lapanganList
            .map((item) => TempatOlahraga.fromJson(item))
            .toList();

        final box = await Hive.openBox<TempatOlahraga>('lapanganBox');
        await box.clear(); 
        await box.addAll(listTempat);

        return listTempat;
      } else {
        throw Exception(
            'Gagal memuat data (status code: ${response.statusCode})');
      }
    } catch (e) {
      print('❌ Error saat fetch data: $e');

      final box = await Hive.openBox<TempatOlahraga>('lapanganBox');
      if (box.isNotEmpty) {
        print('📦 Menampilkan data dari cache Hive');
        return box.values.toList();
      } else {
        rethrow; 
      }
    }
  }

  void openMap(double latitude, double longitude) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
