// lib/models/lapangan_model.dart

import 'package:hive_flutter/hive_flutter.dart';

part 'lapangan_model.g.dart';

@HiveType(typeId: 1)
class TempatOlahraga extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String namaTempat;

  @HiveField(2)
  late String jenisLapangan;

  @HiveField(3)
  late String lokasiWilayah;

  @HiveField(4)
  late double ratingAvg;

  @HiveField(5)
  late int hargaSewa;

  @HiveField(6)
  late double latitude;

  @HiveField(7)
  late double longitude;

  @HiveField(8) // <--- KOLOM BARU UNTUK GAMBAR
  late String imageUrl; // Akan menyimpan URL gambar lapangan

  TempatOlahraga({
    required this.id,
    required this.namaTempat,
    required this.jenisLapangan,
    required this.lokasiWilayah,
    required this.ratingAvg,
    required this.hargaSewa,
    required this.latitude,
    required this.longitude,
    required this.imageUrl, // <--- TAMBAHKAN KE CONSTRUCTOR
  });

  factory TempatOlahraga.fromJson(Map<String, dynamic> json) {
    return TempatOlahraga(
      id: json['id'] as String,
      namaTempat: json['nama_tempat'] as String,
      jenisLapangan: json['jenis_lapangan'] as String,
      lokasiWilayah: json['wilayah'] as String,
      ratingAvg: (json['rating'] as num).toDouble(),
      hargaSewa: (json['harga'] as num).toInt(),
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lon'] as num).toDouble(),
      imageUrl: json['image_url'] as String, // <--- TAMBAHKAN MAPPING DARI JSON
    );
  }
}