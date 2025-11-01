import 'package:hive_flutter/hive_flutter.dart';

part 'booking_model.g.dart';

@HiveType(typeId: 2)
class BookingModel extends HiveObject {
  @HiveField(0)
  late String namaLapangan;

  @HiveField(1)
  late String jenisLapangan;

  @HiveField(2)
  late DateTime tanggalBooking; // Tanggal main

  @HiveField(3)
  late String jamMulai; // Misalnya "10:00"

  @HiveField(4)
  late int durasiJam; // Dalam jam

  @HiveField(5)
  late int totalHarga;

  @HiveField(6)
  late String statusPembayaran; // "Pending", "Paid", dll

  @HiveField(7)
  late String userId;

  @HiveField(8)
  late String imageUrl; // 🆕 Tambahan baru

  BookingModel({
    required this.namaLapangan,
    required this.jenisLapangan,
    required this.tanggalBooking,
    required this.jamMulai,
    required this.durasiJam,
    required this.totalHarga,
    required this.statusPembayaran,
    required this.userId,
    required this.imageUrl, // 🆕 jangan lupa tambahkan di constructor
  });

  // Helper: hitung jam selesai otomatis
  DateTime get _jamSelesaiDateTime {
    final timeParts = jamMulai.split(':');
    final hour = int.tryParse(timeParts[0]) ?? 0;
    final minute = int.tryParse(timeParts.length > 1 ? timeParts[1] : '0') ?? 0;

    final startDateTime = DateTime(
      tanggalBooking.year,
      tanggalBooking.month,
      tanggalBooking.day,
      hour,
      minute,
    );

    return startDateTime.add(Duration(hours: durasiJam));
  }

  String get jamSelesai {
    final endTime = _jamSelesaiDateTime;
    return '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
  }

  String get bookingType {
    if (statusPembayaran == 'Dibatalkan') return 'Riwayat';
    return _jamSelesaiDateTime.isAfter(DateTime.now()) ? 'Aktif' : 'Riwayat';
  }
}
