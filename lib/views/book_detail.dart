import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/booking_model.dart';

class BookDetail extends StatelessWidget {
  final BookingModel booking;

  const BookDetail({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('dd/MM/yyyy HH:mm', 'id_ID');
    final tanggalMain =
        DateFormat('dd/MM/yyyy', 'id_ID').format(booking.tanggalBooking);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Detail Booking',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            color: Colors.white,
            child: Column(
              children: [
                // --- Gambar Lapangan ---
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[200],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: booking.imageUrl.isNotEmpty
                        ? Image.network(
                            booking.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                          )
                        : Image.network(
                            // fallback gambar berdasarkan jenis lapangan
                            booking.jenisLapangan.contains('Basket')
                                ? 'https://images.unsplash.com/photo-1519861155730-0b5b0bf7ce19'
                                : booking.jenisLapangan.contains('Badminton')
                                    ? 'https://images.unsplash.com/photo-1505664194779-8beaceb93744'
                                    : booking.jenisLapangan.contains('Volley')
                                        ? 'https://images.unsplash.com/photo-1509822929063-6b6cfc9b42f2'
                                        : booking.jenisLapangan
                                                .contains('Mini Soccer')
                                            ? 'https://images.unsplash.com/photo-1603031976405-27b8bbff3a3d'
                                            : booking.jenisLapangan
                                                    .contains('Soccer')
                                                ? 'https://images.unsplash.com/photo-1508261305430-3b38e3b54a56'
                                                : 'https://images.unsplash.com/photo-1599058917212-d750089bc07c',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // --- Detail Booking ---
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.namaLapangan,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Detail Booking",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 5),

                      // --- Box Detail Booking ---
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          border: Border.all(color: Colors.grey[200]!),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            _buildRow(
                                "ID Booking", "#${booking.key ?? 'N/A'}"),
                            _buildRow("Tanggal Booking",
                                dateFormatter.format(booking.tanggalBooking)),
                            _buildRow("Tanggal Main", tanggalMain),
                            _buildRow("Jam Main",
                                "${booking.jamMulai} - ${booking.jamSelesai} WIB"),
                            _buildRow("Jenis Lapangan", booking.jenisLapangan),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),
                      const Text(
                        "Detail Pembayaran",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 5),

                      // --- Box Detail Pembayaran ---
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          border: Border.all(color: Colors.grey[200]!),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            _buildRow(
                              "Total Pembayaran",
                              NumberFormat.currency(
                                      locale: 'id_ID', symbol: 'Rp')
                                  .format(booking.totalHarga),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Status Pembayaran",
                                  style: TextStyle(color: Colors.black),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(
                                            booking.statusPembayaran)
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    booking.statusPembayaran,
                                    style: TextStyle(
                                      color: _getStatusColor(
                                          booking.statusPembayaran),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget helper untuk baris teks kiri-kanan
  Widget _buildRow(String left, String right) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(left, style: const TextStyle(color: Colors.black)),
          Flexible(
            child: Text(
              right,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk menentukan warna status pembayaran
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.blue;
      case 'Paid':
      case 'Lunas':
        return Colors.green;
      case 'Dibatalkan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
